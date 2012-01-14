---
title: First Steps
layout: doc
permalink: /doc/first-steps
section: documentation
subsection: first-steps
---

Zero to running in five minutes with lein.

## Install leiningen

The first thing we need is [leiningen](http://github.com/technomancy/leiningen),
a build tool for clojure. You can downlaod this with your web browser, `curl` or
`wget` or your favourite download tool. Here we show using `curl`.

{% highlight clojure %}
    bash$ curl -O http://github.com/technomancy/leiningen/raw/stable/bin/lein
    bash$ chmod +x lein
{% endhighlight %}

## Create a new project

Now we can create a new clojure project using lein. This uses quickstart as the
name of the project:

{% highlight clojure %}
    bash$ lein new quickstart
    Created new project in: quickstart
    bash$ cd quickstart
{% endhighlight %}

## Setup the project for pallet

Pallet is just a library, and can be used as a jar file. Release
versions are available at the
[Sonatype](http://oss.sonatype.org/content/repositories/releases/org/cloudhoist)
maven repository.

Include the following in the `project.clj` file, which describes the project
dependencies.

{% highlight clojure %}
    :dependencies [[org.cloudhoist/pallet "0.5.0"]
                   [org.cloudhoist/pallet-crates-standalone "0.5.0"]
                   [org.jclouds/jclouds-all "1.0-beta-9c"]
                   [org.jclouds.driver/jclouds-jsch "1.0-beta-9c"]
                   [org.jclouds.driver/jclouds-log4j "1.0-beta-9c"]]
    :repositories {"sonatype"
                   "http://oss.sonatype.org/content/repositories/releases"}
{% endhighlight %}

You should end up with a `project.clj` that looks something like this:

{% highlight clojure %}
    (defproject blank-project "0.1.0-SNAPSHOT"
      :description "quickstart for pallet"
      :dependencies [[org.cloudhoist/pallet "0.5.0"]
                     [org.cloudhoist/pallet-crates-standalone "0.5.0"]
                     [org.jclouds/jclouds-all "1.0-beta-9c"]
                     [org.jclouds.driver/jclouds-jsch "1.0-beta-9c"]
                     [org.jclouds.driver/jclouds-log4j "1.0-beta-9c"]]
      :repositories {"sonatype"
                     "http://oss.sonatype.org/content/repositories/releases"})
{% endhighlight %}

## Start the REPL and load pallet

Start a repl with `lein repl` and load pallet with `require` at the repl
`user=>` prompt.

{% highlight clojure %}
    (require 'pallet.core 'pallet.compute)
{% endhighlight %}


## Configure your credentials

Now you can configure your credentials in a `~/.pallet/config.clj` file, under
the `:services` key. You will need to create this file.

{% highlight clojure %}
    (defpallet
      :serivces
        {:gogrid {:provider "gogrid" 
                  :identity "key" 
                  :credential "secret-key"}
         :aws {:provider "ec2-aws" 
               :identity "key" 
               :credential "secret-key"}
         :rs  {:provider "cloudservers-us" 
               :identity "user" 
               :credential "key"}})
{% endhighlight %}

Each service is named (the key in the map supplied to =:services=).

The `:provider` key specifies the jclouds provider to use.  For a list of the
valid `:provider` values, you can enter the following command:

{% highlight clojure %}
    (pallet.compute/supported-providers)
{% endhighlight %}


## Start a cloud node

You can now start your first compute node:

{% highlight clojure %}
    (pallet.core/converge
      (pallet.core/group-spec "mygroup" :count 1)
      :compute (pallet.compute/service :gogrid))
{% endhighlight %}

To shut the node down again, change the `:count` value to `zero`:

{% highlight clojure %}
    (pallet.core/converge
      (pallet.core/group-spec "mygroup" :count 0)
      :compute (pallet.compute/service :gogrid))
{% endhighlight %}

Congratulations!
