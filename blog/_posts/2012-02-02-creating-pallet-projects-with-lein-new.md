---
layout: news
title: Creating Pallet Projects with lein-pallet-new
author: Hugo Duncan
section: blog
---

Creating a new project to use pallet just became easier.

{% highlight bash %}
lein new pallet my-project
{% endhighlight %}

For this to work, you will need to install [lein][lein], [lein-newnew][newnew]
and [lein-pallet-new][palletnew]. [lein-newnew][newnew] is
[Anthony Grimes][raynes]' excellent new template plugin for [lein][lein].

{% highlight bash %}
lein plugin install lein-newnew 0.1.2
lein plugin install org.cloudhoist/lein-pallet-new 0.1.0
{% endhighlight %}

The `pallet` template actually accepts quite a few options. For example, to
specify an explicit Pallet version, just add `pallet-version` and the version
you would like.

{% highlight bash %}
lein new pallet my-project pallet-version 0.6.6
{% endhighlight %}

The template also has a few builtin smarts.  It will automatically add the
`automated-admin-user` crate for example.

This is the first release, so if you try it out and the resulting project is not
completely to your liking, then please let us know. Either raise an
[issue][issues] or post to the [mailing list][ml].

On a parting note, you might question why the templates are in a separate lein
plugin and not in [pallet-lein][palletlein]. The reason comes down to the a
clojure 1.2 issue triggered by [tools.namespace][tns] and [lein-newnew][newnew]
templates. A solution was proposed in the [TNS-1 issue][tns1], but declined.

For those still reading, templates are files on the classpath, but are not valid
clojure code. When tools.namespace discovers namespaces, it does not filter out
namespaces that are invalid (more details in the [issue][tns1]).

[issues]: https://github.com/pallet/pallet-lein-new/issues "lein-newnew issues"
[lein]: https://github.com/technomancy/leiningen "Leiningen Clojure Build Tool"
[ml]: http://groups.google.com/group/pallet-clj "Pallet mailing list"
[newnew]: https://github.com/Raynes/lein-newnew "lein-newnew"
[palletlein]: https://github.com/pallet/pallet-lein "pallet-lein"
[palletnew]: https://github.com/pallet/pallet-lein-new "Pallet lein new"
[raynes]: http://blog.raynes.me/ "Anthony Grimes"
[tns1]: http://dev.clojure.org/jira/browse/TNS-1 "tools.namespace issue TNS-1"
[tns]: https://github.com/clojure/tools.namespace "tools.namespace"
