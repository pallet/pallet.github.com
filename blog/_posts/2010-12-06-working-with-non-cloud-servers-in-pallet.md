---
layout: news
title: Working with Non-Cloud Servers in Pallet
permalink: working-with-non-cloud-servers-in-pallet
author: Hugo Duncan
---
If have tried to configure local vm's or non-virtualised servers in
[Pallet](http://palletops.com), you might well have given up. The recent
[0.3 release](http://palletops.com/pallet-release-030-agile-cloud-development)
has made working with existing servers much easier, however.

Pallet now has a `node-list` provider, which you can use to specify the tags and
address of the machine that you want to manage.

    {% highlight clojure %}
    (require 'pallet.compute.node-list)
    (def service 
      (pallet.compute/compute-service
        "node-list"
         :node-list [(pallet.compute.node-list/make-node
                       "hostname" "tag" "192.168.2.23" :ubuntu)])
    {% endhighlight %}

Use `defnode` and `lift` to configure the machines based on the tag.

    {% highlight clojure %}
    (require 'pallet.core)
    (pallet.core/defnode tag
      :configure (pallet.resource/phase
                   (pallet.resource.package/package "wget")))
    (pallet.core/lift tag)
    {% endhighlight %}

Pallet has it's roots in [jclouds](http://jclouds.org/), and was originally
meant to work directly with a cloud provisioning api. Adding the abitility to
work with a fixed list of nodes was a simple case of wiring up a subset of
pallet's capabilities. The `converge` command has the capability of starting and
stopping nodes, and is obviously not supported by `node-list`.