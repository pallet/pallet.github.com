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
or `wget` or your favourite download tool. Here we show using `curl`.

{% highlight bash %}
bash$ curl -O https://raw.github.com/technomancy/leiningen/raw/stable/bin/lein
bash$ chmod +x lein
{% endhighlight %}

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

Congratulations!
