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

### Install leiningen plugins (lein 1.x only)

We will need leiningen plugins for lein 1.x (1.6.2 or later). Let's install
them:

{% highlight bash %}
bash$ lein plugin install lein-newnew 0.3.4
bash$ lein plugin install pallet/lein-template 0.2.5
{% endhighlight %}

Note that this is only required for lein 1 (as installed when following the
steps above). For lein 2, no plugins need to be installed.

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
(require 'pallet.core 'pallet.compute 'pallet.configure)
{% endhighlight %}

## Start a cloud node

You can now start your first compute node:

{% highlight clojure %}
(pallet.core/converge
  (pallet.core/group-spec "mygroup"
   :count 1
   :node-spec (pallet.core/node-spec :image {:os-family :ubuntu}))
  :compute (pallet.configure/compute-service :aws))
{% endhighlight %}

To shut the node down again, change the `:count` value to `zero`:

{% highlight clojure %}
(pallet.core/converge
  (pallet.core/group-spec "mygroup" :count 0)
  :compute (pallet.configure/compute-service :aws))
{% endhighlight %}

## Authorising yourself

Of course it would be nice to be able to ssh into the node. To enable this we
add a call to `automated-admin-user` in the `:bootstrap` phase, which is run
whenever a new node is started with the group-spec.

{% highlight clojure %}
(use '[pallet.action.automated-admin-user :only [automated-admin-user]])
(pallet.core/converge
  (pallet.core/group-spec "mygroup"
   :count 1
   :node-spec (pallet.core/node-spec :image {:os-family :ubuntu})
   :phases {:bootstrap automated-admin-user})
  :compute (pallet.configure/compute-service :aws))
{% endhighlight %}

You should now be able to log into your new node via ssh. You can find the host
IP address by listing your nodes:

{% highlight clojure %}
(pallet.compute/nodes (pallet.configure/compute-service :aws))
{% endhighlight %}

## Installing something

Now we can log into the node, we can ask pallet to install and configure things.

Pallet can run as many different phases as you need, but by default it runs the
`:configure` phase. Here we use the `:configure` phase to install curl.

{% highlight clojure %}
(use '[pallet.action.package :only [package]]
     '[pallet.phase :only [phase-fn]])
(pallet.core/converge
  (pallet.core/group-spec "mygroup"
   :count 1
   :node-spec (pallet.core/node-spec :image {:os-family :ubuntu})
   :phases {:bootstrap automated-admin-user
            :configure (phase-fn (package "curl"))})
  :compute (pallet.configure/compute-service :aws))
{% endhighlight %}

## Next

Hopefully this has given you a small taste of running pallet from the REPL.

The example project generates some code as a template for how you might define
your group-specs, so explore under the `src` directory.

The pallet plugin for lein that is enabled in the generated project is also
useful for things like triggering a lift or converge, or listing nodes, from the
command line.

Don't hesitate to ask questions, either through the site here, via the
[mailing list](http://groups.google.com/group/pallet-clj), or on
[#pallet](http://webchat.freenode.net/?channels=#pallet) on freenode irc.
