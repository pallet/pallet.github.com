---
layout: news
title: How to Configure your Credentials in Pallet
permalink: how-to-configure-your-cloud-credentials-in-pa
author: Hugo Duncan
---
The recent
[0.3.0 release](http://palletops.com/pallet-release-030-agile-cloud-development)
of [pallet](https://github.com/hugoduncan/pallet) added a new way to configure
your cloud credentials, using a clojure file, `~/.pallet/config.clj`.

    {% highlight clojure %}
    (defpallet
      :providers
        {:aws {:provider "ec2"
               :identity "key"
               :credential "secret-key"}
         :rs  {:provider "cloudservers"
               :identity "username"
               :credential "key"}})
     {% endhighlight %}

The provider key, `:aws` and `:rs` above, has to be unqiue, but you can have
multiple accounts for the same provider. The provider string is the
[jclouds](http://jclouds.org/) provider string, and can be found with a call to
`pallet.compute/supported-providers`, or using the lein plugin,
`pallet lein providers` (in which case you can see if you have the appropriate
jclouds provider jars set up correctly).  Pallet uses jcloud's terminology,
`identity` and `credential`, but your cloud provider will probably use different
terms for these.

To create a compute service object from this file, that you can pass to `lift`
or `converge`, you use `pallet.compute/compute-service-from-config`. By default,
the first provider entry will be used, and you can specify an alternative
provider by passing the key to the function.

    {% highlight clojure %}
    (pallet.compute/compute-service-from-config "rs")
    {% endhighlight %}

The `config.clj` file is read automatically by the lein and cake plugins, and
in lein, you can switch between providers using the `-P` command line option.

    {% highlight bash %}
    lein pallet -P rs nodes
    {% endhighlight %}


## Admin User

At the same time, the `config.clj` file can be used to set the admin user, that
is used by pallet to run the node configuration. By default in pallet, this is
set to your current username and uses your id_rsa key.

    {% highlight clojure %}
    (defpallet
      :admin-user
        {:username "admin"
         :private-key-path "/path/to/private-key"
         :public-key-path "/path/to/public-key"})
    {% endhighlight %}

Another possibility, which could be useful if you are working in a team
environment, is to set the admin user in the project code.

    {% highlight clojure %}
    (ns pallet.config
      (:require [pallet.utils :as utils]))

    (def admin-user (utils/make-user "admin"))
    {% endhighlight %}

## settings.xml

The `config/clj` file is an alternative to the existing `settings.xml`.

    {% highlight xml %}
    <settings>
      <profiles>
        <profile>
          <id>rackspacedev</id>
          <activation>
	    <activeByDefault>false</activeByDefault>
          </activation>
          <properties>
            <jclouds.compute.provider>
              cloudservers
            </jclouds.compute.provider>
            <jclouds.compute.identity>
              username
            </jclouds.compute.identity>
            <jclouds.compute.credential>
              key
            </jclouds.compute.credential>
          </properties>
        </profile>
        <profile>
          <id>aws</id>
          <activation>
	    <activeByDefault>true</activeByDefault>
          </activation>
          <properties>
            <jclouds.compute.provider>
              ec2
            </jclouds.compute.provider>
            <jclouds.compute.identity>
              key
            </jclouds.compute.identity>
            <jclouds.compute.credential>
              secret key
            </jclouds.compute.credential>
          </properties>
        </profile>
      </profiles>
    </settings>
    {% endhighlight %}


To create a compute service object from `settings.xml`, you use
`pallet.compute/compute-service-from-settings`. The default is determined by the
active profile. You can specify a different profile by passing the profile's id
to the function.

    {% highlight clojure %}
    (pallet.compute/compute-service-from-settigs "rackspacedev")
    {% endhighlight %}