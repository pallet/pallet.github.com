---
title: Project Configuration File
layout: reference
permalink: /doc/reference/0.8/project-configuration
section: documentation
subsection: reference
summary: Description of the pallet.clj project configuration file
apiver: 0.8
---

The `pallet.clj` project configuration file allows you to specify project
infrastructure in a form that can be checked into your source repository.  The
file describes the [group-specs and node-specs](/doc/reference/0.8/node-types)
you wish to use with the project.  This allows a developer to check out your
project, and run `lein pallet up`.

## Getting started

Working with project files is easiest using the pallet plugin for lein.  Add the
following in your `~/.lein/profiles.clj` file:

{% highlight clojure %}
{:user {:plugins [[com.palletops/pallet-lein "0.6.0-beta.4"]]}}
{% endhighlight %}

To create a default configuration file, run `lein pallet project-init`, which
will create a `pallet.clj` file.

We will also need a pallet service configuration.  By default `lein pallet` will
look for virtualbox, but you can generate an explicit service descriptor with:

`lein pallet add-service vbox vmfest`

## pallet.clj Options

Take a look at the
(sample project)[https://github.com/pallet/pallet/blob/develop/sample-project-pallet.clj]
for an annotated description of the options available.


This assumes you have a project with a
[leiningen](https://github.com/technomancy/leiningen) `project.clj` build.
