---
layout: main/blog-post
title: Pallet 0.4.10 -  environments, parallel lift and converge, and virtualbox too!
permalink: pallet-0410-environments-parallel-lift-and-co
author: Hugo Duncan
section: blog
---

This week saw the release of 0.4.10.

The pace of pallet development has picked up over the last couple of months.
Much of this has been driven by
[our work at GoGrid](http://blog.gogrid.com/2011/02/08/agile-development-at-gogrid-with-pallet-and-jclouds-presentation/),
where we are applying pallet to automate fully functional GoGrid environments
for use by development teams for test and development. Thanks
[GoGrid](htp://gogrid.com)!

The 0.4.x cycle has seen us switch to gitflow and to frequent releases to avoid
dependence on SNAPSHOTS. Personally, this has made development much more
enjoyable - hopefully it makes life easier for users of pallet too.

## 0.4.10 Release

Major changes since 0.4.0 include parallel converges and lifts, support for
vmfest, and environments.

Parallel converge ensures that the wait when starting nodes is minimised,
executing requests for all nodes to be created in parallel. Parallel lift
applies each phase across all nodes in parallel. Phases still run sequentially
(running each phase waits for all nodes to complete the previous
phase). Parallel converge and lift are not the default yet, but will be in
0.5.0.

To try out parallel lift and converge, add the following to your config.clj:

    ``` clojure
    :environment {:algorithms
                  {:lift-fn 
                     pallet.core/parallel-lift
                   :converge-fn 
                     pallet.core/parallel-adjust-node-counts}}
    ```

Which brings us to environments. Environments are a powerful way of injecting
data into your crates, and provide a customisation mechanism, as seen above.  An
:environment can be specified at the top level of the defpallet in config.clj,
or at the individual service provider level (same level as :provider), or in the
actual call to lift and converge. As an example use case, here is the
environment I use for running live tests in virtualbox via vmfest:

    ``` clojure
    :environment
      {:phases
        {:bootstrap (fn [request]
                      (pallet.resource.package/package-manager
                         request :configure
                         :proxy "http://192.168.1.37:3128"))}
       :proxy "http://192.168.1.37:3128"
       :mirror {:apache "http://apache.mirror.iweb.ca/"}
       :image {:min-ram 256 :bridged-network "en1: AirPort"}}
    ```

This example extends the bootstrap phase of all nodes to add a proxy for the
package manager, adds a proxy for remote-file operations, selects a mirror for
apache downloads, and specifies a default template for new nodes.

To access arbitrary data from the environment, use pallet.environment/get-for.

Finally, vmfest is Toni Batchelli's great new lib for using VirtualBox from
clojure.  Toni is simplifying the setup before announcing this more generally,
but it works very well, and is now my default development and testing setup for
pallet. If you want to give it a try, give tbatchelli a shout on #pallet in
freenode IRC.  [vmfest is on github](https://github.com/tbatchelli/vmfest).

For full details, check the [release notes](https://github.com/pallet/pallet/wiki/ReleaseNotes).

## Upcoming

Expect a post with a more in depth example of using environements soon.  There
are some other interesting features in the pipeline, including the use of spot
instances on EC2 - stay tuned...
