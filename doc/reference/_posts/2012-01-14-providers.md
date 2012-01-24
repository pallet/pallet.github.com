---
title: Providers
layout: doc
permalink: /doc/reference/providers
section: documentation
subsection: reference
summary: Pallet reference documentation for providers
---

Pallet uses [jclouds](http://jclouds.org) to create, start and stop nodes.  In order to use the
cloud, you will need to specify which cloud to use and your cloud credentials.

## Cloud Provider Names

In order to sign in to your cloud API, you will need to tell pallet the name of
your provider.  The names pallet recognises can be displayed with the following
from the REPL:

{% highlight clojure %}
   (require 'pallet.compute)
   (pallet.compute/supported-providers)
{% endhighlight %}

From the command line, you can use the lein plugin to list providers:

{% highlight sh %}
   lein pallet providers
{% endhighlight %}

## Explicit credentials

You can log in to the cloud explicitly, using the provider name, and your
credentials.

{% highlight clojure %}
  (require 'pallet.compute)
  (def service
    (pallet.configure/compute-service
     "provider" :identity "username" :credential "password"))
{% endhighlight %}

Pallet uses [jclouds](http://jclouds.org)' terminology, `identity` and
`credential`, but your cloud provider will probably use different
terms for these. Identity may be called username or key and credential
may be called password or secret.

## Credentials in config.clj

You can use the pallet configuration file
[~/.pallet/config.clj](/doc/reference/config.clj) to specify credentials.

{% highlight clojure %}
  (defpallet
    :services
      {:aws {:provider "ec2"
             :identity "key"
             :credential "secret-key"}
       :rs  {:provider "cloudservers"
             :identity "username"
             :credential "key"}})
{% endhighlight %}

The provider key, `:aws` and `:rs` above, has to be unqiue, but you can have
multiple accounts for the same provider.

To create a compute service object from this file, that you can pass to `lift`
or `converge`, you use `pallet.configure/compute-service`. By default, the first
provider entry will be used, and you can specify an alternative provider by
passing the key to the function.

{% highlight clojure %}
  (pallet.compute/service "rs")
{% endhighlight %}

The [~/.pallet/config.clj](/doc/reference/config.clj) file is read
automatically by the `lein` and `cake` plugins, and in `lein`, you can
switch between providers using the `-P` command line option.

{% highlight sh %}
  lein pallet -P rs nodes
  cake pallet nodes -- -P rs
{% endhighlight %}


## Credentials in settings.xml

The maven settings.xml file is often used to hold user specific configuration for
maven.  You can add your cloud provider information to this file, which is
normally located at [~/.m2/settings.xml](/doc/reference/settings.xml).

{% highlight xml %}
  <settings>
    <profiles>
      <profile>
        <id>terremark</id>
        <activation>
          <activeByDefault>true</activeByDefault>
        </activation>
        <properties>
          <jclouds.compute.provider>
            Your Cloud serivce name
          </jclouds.compute.provider>
          <jclouds.compute.identity>
            Your Cloud API username or key
          </jclouds.compute.identity>
          <jclouds.compute.credential>
            Your Cloud API secret or password
          </jclouds.compute.credential>
        </properties>
      </profile>
    </profiles>
  </settings>
{% endhighlight %}

To create a compute service object from settings.xml, you use
`pallet.compute/service`. The default is determined by the active profile. You
can specify a different profile by passing the profile's id to the function.

{% highlight clojure %}
  (require 'pallet.compute)
  (def service (pallet.compute/service "aws"))
{% endhighlight %}

You will need the following maven-settings dependency in your project for this
to work:

{% highlight xml %}
    <dependency>
      <groupId>org.apache.maven</groupId>
      <artifactId>maven-settings</artifactId>
      <version>2.0.10</version>
      <optional>true</optional>
    </dependency>
{% endhighlight %}
