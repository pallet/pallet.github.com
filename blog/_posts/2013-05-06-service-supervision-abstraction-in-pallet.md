---
layout: news
title: Service Supervision in Pallet 0.8
permalink: service-supervision
published: false
summary: Pallet 0.8 introduces a service supervision abstraction.
author: Hugo Duncan
section: blog
---

# Service Supervision in Pallet 0.8

There are many choices for process supervision and Joshua Timberman has an
[excellent blog post](http://jtimberman.housepub.org/blog/2012/12/29/process-supervision-solved-problem/)
on some of these.  People tend to be pretty opinionated about the supervision
service they would like to use, so in pallet 0.8 we've made it possible to write
crates that provide a service process, and can easily be used with a choice of
supervision provider.  We're going to demonstrate this with the
[riemann crate](https://github.com/pallet/riemann-crate).

## Using Crates with the Service Abstraction

When using the riemann crate, you specify the supervision you wish to use via
the settings' `:supervisor` key.  The riemann crate supports running riemann
under runit, upstart or a simple nohup (not recommended) by setting the
appropriate value in the settings map `:supervisor` key.  The value should be
one of `:runit`, `:upstart` (and `:nohup`).

Secondly you need to make sure the supervision service is installed and
configured.  To do this, require the crate that provides the implementation of
the service supervision you have chosen, and make sure your `group-spec` extends
(possibly transitively) the implementation's server-spec.

So to install riemann and configure it to run under `runit` supervision, we
would use a group spec that extends the riemann `server-spec` like this:

{% highlight clojure %}
(require
  '[pallet.crate.java :as java]
  '[pallet.crate.riemann :as riemann]
  '[pallet.crate.runit :as runit])

(group-spec "riemann"
  :extends [(java/server-spec {})
            (runit/server-spec {})
            (riemann/server-spec {:supervisor :runit})])
{% endhighlight %}

The riemann crate defines the `:start-riemann`, `:stop-riemann` and
`:restart-riemann` phases to control the riemann server.

## Writing a Crate that Implements the Service Abstraction

For each supervisor a crate supports, there will be a `supervisor-config-map`
method, that returns a map that will be understood by the supervisor's
`service-supervisor-config` method.

The riemann crate
[defines](https://github.com/pallet/riemann-crate/blob/develop/src/pallet/crate/riemann.clj#L95)
configuration for running under `:runit`, `:upstart` (and `nohup`).

{% highlight clojure %}
(defmethod supervisor-config-map [:riemann :runit]
  [_ {:keys [run-command service-name user] :as settings} options]
  {:service-name service-name
   :run-file {:content (str "#!/bin/sh\nexec chpst -u " user " " run-command)}})

(defmethod supervisor-config-map [:riemann :upstart]
  [_ {:keys [run-command service-name user] :as settings} options]
  {:service-name service-name
   :exec run-command
   :setuid user})
{% endhighlight %}

Both of these are constructed based on a `:user` and a `:run-command` in the
riemann settings.  The `:run-command` is defaulted based on the riemann install
location (controlled via the `:home` key in settings).

At a minimum, the `:supervisor` key should be exposed in the crate's `settings`
function.

## Conclusion

The new service supervision abstraction makes it quite simple to use, and write,
crates that can be used with a configurable choice of service supervision.

