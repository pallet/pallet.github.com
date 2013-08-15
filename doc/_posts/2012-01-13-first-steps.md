---
title: First Steps
layout: doc
permalink: /doc/first-steps
section: documentation
subsection: first-steps
summary: Quickstart instructions for creating a new Pallet project. Covers installation
         of lein and configuration of project.clj.
---

Zero to running in five minutes with lein.

## Install leiningen

The first thing we need is [leiningen](http://github.com/technomancy/leiningen),
a build tool for clojure.  You can downlaod this with your web browser, `curl`
or `wget` or your favourite download tool, following the
[install instructions](https://github.com/technomancy/leiningen#installation).

We require leiningen 2.0 or greater.

## Create a new project

Now we can create a new clojure project using lein, we will call it
'quickstart'.

{% highlight bash %}
bash$ lein new pallet quickstart
Created new project in: quickstart
bash$ cd quickstart
{% endhighlight %}

## Configure your credentials

Now you can configure your credentials.

{% highlight bash %}
bash$ lein pallet add-service aws aws-ec2 "your-aws-key" "your-aws-secret-key"
{% endhighlight %}

Note that this creates a `~/.pallet/services/aws.clj` file with your credentials
in it.

The second argument above is the name of the jclouds provider, which is cloud
specific. To find the value for other clouds, you can list the supported
providers with:

{% highlight bash %}
bash$ lein pallet providers
{% endhighlight %}

## Start the REPL and load pallet

Start a repl with `lein repl` and load pallet with `require` at the repl
`user=>` prompt.

{% highlight clojure %}
(require 'pallet.api 'pallet.compute 'pallet.configure)
{% endhighlight %}

## Start a cloud node

You can now start your first compute node:

{% highlight clojure %}
(pallet.api/converge
  (pallet.api/group-spec "mygroup"
   :count 1
   :node-spec (pallet.api/node-spec :image {:os-family :ubuntu}))
  :compute (pallet.configure/compute-service :aws))
{% endhighlight %}

To shut the node down again, change the `:count` value to `zero`:

{% highlight clojure %}
(pallet.api/converge
  (pallet.api/group-spec "mygroup" :count 0)
  :compute (pallet.configure/compute-service :aws))
{% endhighlight %}

Congratulations!
