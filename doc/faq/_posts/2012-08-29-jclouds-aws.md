---
layout: doc
title: FAQ Using AWS with the jclouds provider
section: documentation
---

# How do I run a node on an availability zone or region outside of us-east-1?

To run a node outside of us-east-1, you will need to specify a `:location-id` in
your node-spec. You will also need to ensure that your AMI is available in the
specified location.

{% highlight clojure %}
:image {:image-id "us-east-1/ami-1aad5273"}
:location {:location-id "us-east-1a"}
{% endhighlight %}

# How do I run a node in a VPC?

To run a node inside a VPC, you will need to specify a `:subnet-id` in
your node-spec.

{% highlight clojure %}
:location {:subnet-id "subxxxx"}
{% endhighlight %}

# Why does it take 20mins to list images?

When jclouds starts, it requests a list of images from the provider. On AWS,
this list is very long.  If you have DEBUG level logging to the console for
jclouds.wire, then this takes a very long time. The solutions is to set the log
level for jclouds.wire to INFO or WARN.

# How can I make jclouds see my AMIs?

Since AWS has a very long list of images, jclouds filters the image lists by
owner in order to improve performance. You can add your owner id to the list of
owners it uses, by specifying it in your service configuration in
`~/.pallet/config.clj` or `~/.pallet/services/*`, or when calling
`pallet.compute/compute-service`.

{% highlight clojure %}
:jclouds.ec2.ami-query "owner-id=137112412989"
{% endhighlight %}

See also
[Image Filters](http://www.jclouds.org/documentation/userguide/using-ec2/).
