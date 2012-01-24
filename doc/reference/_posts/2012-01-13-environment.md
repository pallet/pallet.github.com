---
title: Environment
layout: doc
permalink: /doc/reference/environment
section: documentation
subsection: reference
---

The environment is a map used for passing data and configuration choices into
pallet. The environment may be specified at various scopes.  The environment
contributed by each scope will be merged.

# Environment API

The environment can be accessed with [`pallet.environment/get-for`](http://pallet.github.com/pallet/api/0.6/pallet.environment.html).

# Pallet Specific Keys

Pallet recognises specific keys in the environment.

 `:algorithms`
: a map that can be used to specify specific algorithms to override the pallet defaults

 `:groups`
: a map, keyed on group name (keyword), that can specify node-spec details

 `:phase`
: a map of phase defintions, that all group-specs will extend

# Specifying Environment Values

## Config.clj

In config.clj, the environment may be specified at the top level, and/or at the
service level.

{% highlight clojure %}
(defpallet
  ;; general environment
  :environment {:algorithms
                {:lift-fn pallet.core/parallel-lift
                 :converge-fn pallet.core/parallel-adjust-node-counts}}
  :services {:vb4
             {:provider "aws-ec2"
              ;; environment specific to :vb4 service
              :environment
              {:proxy "http://192.168.1.37:3128"
               :mirror {:apache "http://apache.mirror.iweb.ca/"}}}})
{% endhighlight %}

## `lift` and `converge` Arguments

Both `lift` and `converge` can be passed an environment map using the `:environment` keyword.
