---
layout: doc
title: How To Use Pallet With Existing Servers
author: Hugo Duncan
section: documentation
subsection: how-tos
summary: How to make Pallet work with a server rack or existing virtual machines.
         Creates a compute service using Pallet's node-list provider, specifies
         the SSH username and keys, and runs a simple lift to make sure everything works.
---

Pallet has a `node-list` provider, which you can use to connect pallet to a
server rack or to existing virtual machines. To talk to these servers, you need
to tell pallet IP addresses and which group they belong to. You create a compute
service by instantiating a `node-list` provider with a sequence of nodes to
provide that information.

## Getting a `node-list` compute service

There are two ways you can obtain a compute service.

### Instantiate directly
The group is used to match nodes to the `group-spec`s that you use to define the
configuration to apply.

{% highlight clojure %}
(require 'pallet.compute)
(def my-data-center
  (pallet.compute/compute-service
    "node-list"
     :node-list [["qa" "fullstack" "10.11.12.13" :ubuntu]
                 ["fe" "tomcats" "10.11.12.14" :ubuntu]]))
{% endhighlight %}

### Instantiate based on `~/.pallet/config.clj`

If your nodes are fairly static, you may wish to just list them in `~/.pallet/config.clj`.

{% highlight clojure %}
(defpallet
  :services
  {:data-center {:provider "node-list"
                 :node-list [["qa" "fullstack" "10.11.12.13" :ubuntu]
                             ["fe" "tomcats" "10.11.12.14" :ubuntu]]})
{% endhighlight %}

You can then obtain the compute service using:

{% highlight clojure %}
(require 'pallet.configure)
(def my-data-center
  (pallet.configure/compute-service :data-center))
{% endhighlight %}

## Specifying the SSH username and credentials

Pallet uses SSH to talk to your nodes. The default is to use your local username
and your id_rsa key.

The credentials for ssh are specified using a user map, which can be constructed
using `pallet.utils/make-user`. This user map can be passed to `lift`.

## Running a command on each node

To test your configuration, trying running a simple `ls` command.

{% highlight clojure %}
(require 'pallet.action.exec-script 'pallet.phase)
(pallet.core/lift
 (pallet.core/group-spec
  "fe"
  :phases {:configure (pallet.phase/phase-fn
                       (pallet.action.exec-script/exec-script (ls)))})
  :compute data-center
  :user (pallet.utils/make-user
         "username"
         :private-key-path "~/.ssh/id1"
         :public-key-path "~/.ssh/id1.pub")
{% endhighlight %}
