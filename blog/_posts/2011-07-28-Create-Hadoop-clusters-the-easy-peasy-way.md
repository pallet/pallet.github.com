---
layout: news
title: Create Hadoop clusters the easy peasy way with Pallet
permalink: create-hadoop-clusters-the-easy-peasy-way-wit
author: Antoni Batchelli
section: blog
---
Setting up a Hadoop cluster
[is usually a pretty involved task](http://hadoop.apache.org/common/docs/current/cluster_setup.html).
There are certain rules about how the cluster is to be
configured. These rules need to be followed strictly for the cluster
to work. For example, some nodes need to know how to talk to the other
nodes, and some nodes need to allow other nodes to talk to them. Go
ahead and check out the
[official instructions](http://hadoop.apache.org/common/docs/current/cluster_setup.html),
or this more detailed tutorial on
[setting up multi-node Hadoop clusters](http://www.michael-noll.com/tutorials/running-hadoop-on-ubuntu-linux-multi-node-cluster/). In
this article we describe a solution that will create a fully
functional hadoop cluster on any public cloud with very few steps, and
in a very flexible way.

We present [`pallet-hadoop`](https://github.com/pallet/pallet-hadoop),
a library that builds a set of hadoop abstractions on top
[`Pallet`](https://github.com/pallet/pallet).

One of the most defining aspects of `Pallet` is that it is a library,
not a service, and hence there is no server to install in your
network, just something that you embed in your code or use in your
scripts. Also, as a library, Pallet provides a set of abstractions to
make it easier for you to build cluster configurations on top of
it. These two aspects of Pallet are what has allowed us to provide a
solution to tame Hadoop cluster setups.

This work is a collaboration effort by
[Sam Ritchie (@sritchie09)](https://github.com/sritchie), who provided
tons of Hadoop insight and did most of the work on `pallet-hadoop`, and the
[Pallet Team (@palletops)](https://github.com/pallet), that provided
the `Hadoop Crate`.
 
Before we get into the details of how `pallet-hadoop` is implemented,
let's see how it works, by using the project
[`pallet-hadoop-example`](https://github.com/pallet/pallet-hadoop-example)
in GitHub.


## Build a Hadoop Cluster with Pallet-hadoop-example ##

To start a hadoop cluster we will use a project called
[`pallet-hadoop-example`](https://github.com/pallet/pallet-hadoop-example)
that's hosted on github. That project's `README.md` file contains
[very detailed instructions](https://github.com/pallet/pallet-hadoop-example), which I'll summarize here.

1. First we load pallet and pallet-hadoop at the REPL:

        ``` clojure
        (use 'pallet-hadoop-example.core) (bootstrap)
        ```

1. Then we need to provide the credentials for pallet to connect to
EC2 (or any other cloud provider, really). You will need to have your
EC2 credentials available for this (how you identify yourself to the
cloud provider varies from provider to provider):

        ``` clojure
        user=>; (def cloud-service
                   (compute-service "aws-ec2"
                                    :identity ""         
                                    :credential ""))
        ```
                                    
1. Next we create a cluster. `pallet-hadoop-examples` provides a handy
function for this, which takes two parameters, the number of task
tracker nodes (slaves) and the memory devoted to each machine in the
cluster. The following will define a hadoop cluster with 2 `slave`
nodes and one `master` node (To keep things simple, the `master` node
of our example cluster will serve double duty as
[`jobtracker`](http://wiki.apache.org/hadoop/JobTracker) and
[`namenode`](http://wiki.apache.org/hadoop/NameNode), while our
`slave` nodes will act as both
[`tasktrackers`](http://wiki.apache.org/hadoop/TaskTracker) and
[`datanodes`](http://wiki.apache.org/hadoop/DataNode). These are the
four hadoop `roles` currently supported by `pallet-hadoop`.)

        ``` clojure
        user=> (def my-cluster (make-example-cluster 2 (* 4 1024)))
        ```
        
1. Now we are ready to instantiate our cluster on the cloud. For this
we just need to do:

        ``` clojure
        user=> (create-cluster my-cluster cloud-service)
        ```
   
   And wait for it to come back.
   
1. At this point, the cluster is all configured, and we should be able
to ssh into the jobtracker node. To find the IP address of the
jobtacker we can do the following:

        ``` clojure
        user=> (jobtracker-ip cloud-service)
        ```

There you go! You now have a fully functional hadoop cluster all set
up. To operate it, once you ssh into jobtracker, you just need to you
need to sudo as hadoop (`sudo su - hadoop`). The hadoop binaries are
found in `/usr/local/hadoop-0.20.2/`.

(To run your first MapReduce job on the cluster, see the "Running Word Count" section of [`pallet-hadoop-example` `README`](https://github.com/pallet/pallet-hadoop-example).)

## Pallet-hadoop ##

[`Pallet-hadoop`](https://github.com/pallet/pallet-hadoop) is a library
built on top of pallet. Pallet provides a
[`hadoop-crate`](https://github.com/pallet/pallet-apache-crates/blob/master/hadoop/src/pallet/crate/hadoop.clj)
that takes care of the low level operation of hadoop: install it,
create the hadoop user with a preconfigured profile, create ssh
authorizations between nodes, write configuration files from a data
map, etc.

`Pallet-hadoop` builds a set of abstractions on top of `pallet` and
the hadoop crate.

First, for each type of node, it defines what configuration phases
should be run for each role that a node plays. A node can play more
than one role at the same time, as we'll see later.

    ``` clojure
    (def role->phase-map
    {:default #{:bootstrap
                :reinstall
                :configure
                :reconfigure
                :authorize-jobtracker}
     :namenode #{:start-namenode}
     :datanode #{:start-hdfs}
     :jobtracker #{:publish-ssh-key :start-jobtracker}
     :tasktracker #{:start-mapred}})
     ```
     
For example, `jobtracker` is just like any other node, but
it creates and publishes its own public ssh key so that other nodes
can authorize it. This way, `jobtracker` can ssh to all the other
nodes (a requirement for a functioning hadoop cluster).

By default, each node bootstraps (setting basic configuration, e.g.
authorizing your own public ssh keys so you can ssh into each of the
nodes directly), installs and configures hadoop, and authorizes the
jobtracker.

Next it defines what will be done for each phase:

    ``` clojure
    (defn hadoop-phases
      "Returns a map of all possible hadoop phases. IP-type specifies..."
      [{:keys [nodedefs ip-type]} properties]
      (let [[jt-tag nn-tag] 
                    (roles->tags [:jobtracker :namenode] nodedefs)
            configure (phase
                       (h/configure ip-type nn-tag jt-tag properties))]
        {:bootstrap automated-admin-user
         :configure (phase (java :jdk)
                           (h/install :cloudera)
                           configure)
         :reinstall (phase (h/install :cloudera)
                           configure)
         :reconfigure configure
         :publish-ssh-key h/publish-ssh-key
         :authorize-jobtracker (phase (h/authorize-tag jt-tag))
         :start-mapred h/task-tracker
         :start-hdfs h/data-node
         :start-jobtracker h/job-tracker
         :start-namenode (phase (h/name-node "/tmp/node-name/data"))}))
    ```

These phases usually use the `hadoop crate` along with other crates in
`pallet`.

Next, it defines a function to create a `hadoop cluster spec`:

    ``` clojure
    (defn cluster-spec
      "Generates a data representation of a hadoop cluster.

        ip-type: `:public` or `:private`. (Hadoop keeps track of
      jobtracker and namenode identity via IP address. This option toggles
      the type of IP address used. (EC2 requires `:private`, while a local
      cluster running on virtual machines will require `:public`."
      [ip-type nodedefs &amp; {:as options}]
      {:pre [(#{:public :private} ip-type)]}
      (merge {:base-machine-spec {}
              :base-props {}}
             options
             {:ip-type ip-type
              :nodedefs nodedefs}))
    ```
              
A cluster spec can take the following form:

    ``` clojure                     
    (cluster-spec 
        :private
         {:jobtracker (node-group [:jobtracker :namenode])
          :slaves     (slave-group 10)}
         :base-machine-spec {:os-family :ubuntu
                             :os-version-matches "10.10"
                             :os-64-bit true
                             :min-ram (* 4 1024)}
         :base-props {:hdfs-site 
                       {:dfs.data.dir "/mnt/dfs/data"
                        :dfs.name.dir "/mnt/dfs/name"}
                      :mapred-site
                       {:mapred.local.dir "/mnt/hadoop/mapred/local"
                        :mapred.task.timeout 300000
                        :mapred.reduce.tasks 3
                        :mapred.tasktracker.map.tasks.maximum 3
                        :mapred.tasktracker.reduce.tasks.maximum 3
                        :mapred.child.java.opts "-Xms1024m"}})                         
    ```
                         
In this example, we're defining a hadoop cluster that will use private
IP addresses for its communication, that will have two types of nodes:
a `jobtracker` node and `slave` nodes. `jobtracker` nodes will play
the roles of both `jobtracker` and `namenode`, while a `slave` will be
both a `datanode` and a `tasktracker`. There will be 10 slaves in this cluster.

Next, `:base-machine-spec` specifies on what type of hardware will be
used for all the nodes. This specifies a 64bit machine with 4GB of
RAM, running `Ubuntu 10.10`.

`:base-props` provides the shared properties that we want to
customize. These are divided between `HDFS` properties (`:hdfs-site`)
and `MapReduce` properties (`:mapred-site`). These properties should
be self-explanatory.

Here are the full lists of options for
[mapred](http://hadoop.apache.org/core/docs/r0.20.0/mapred-default.html),
[hdfs](http://hadoop.apache.org/core/docs/r0.20.0/hdfs-default.html)
and
[core](http://hadoop.apache.org/core/docs/r0.20.0/core-default.html).
    
## Future ##

This work simplifies significantly the task of setting up a Hadoop
cluster, but also this is very much work in progress and we already
have plenty of ideas on how to provide the best Hadoop experience.

**Help us get there** by sharing this post (see widgets
below) and by telling us about your use cases or any advice you think
would make this project rock even more, either by dropping by the #pallet
channel at [freenode.net](http://freenode.net/irc_servers.shtml), or
by emailing the [`pallet` list](mailto:pallet-clj@googlegroups.com)  .  
