---
layout: news
title: Alembic - a library to control your classpath
permalink: alembic-clojure-classpath-control
summary: Alembic allows you to control the classpath of your clojure REPL
author: Hugo Duncan
section: blog
---

Working at the REPL in clojure flows well until you need to add a dependency.
The edit `project.clj` and restart your REPL dance is time consuming, and throws
away the state of your REPL.

Chas Emerick's [pomegranate](https://github.com/cemerick/pomegranate) provides
all the functionality required to add dependencies to you classpath, but comes
at the cost of introducing a boatload of dependencies that may conflict with
your project's own dependencies.

[Alembic](https://github.com/pallet/alembic) is a new library that solves this
by using [classlojure](https://github.com/flatland/classlojure) to put
[pomegranate](https://github.com/cemerick/pomegranate) (and lein as a whole, in
fact), into a separate classloader.  It then uses the same
[dynapath](https://github.com/tobias/dynapath) library used by pomegranate, to
add the resolved dependencies into your classpath.  This greatly cuts down the
chance of conflict, and will all but eliminate it if we can remove the `useful`
dependency from classlojure.

The main function in alembic today is `distill`, which adds a dependency to your
classpath.  For example, to add `tools.logging`, you would call `distill` like
this:

{% highlight clojure %}
(require 'alembic.still)
(alembic.still/distill [org.clojure/tools.logging "0.2.0"])
{% endhighlight %}

Transitive dependencies are of course added as well, which brings up the
possibility of version conflicts.  Alembic will not add any new version of a
dependency if it is already on the classpath, and will warn about the possible
version conflict.

The `dependencies-added` function can be used to retrieve a sequence of the
dependencies you have added, so you can add them to your `project.clj` as
needed.

To use these functions, you will need to add Alembic to you development
dependencies.  For a leiningen based project, you can do this by adding it to
the `:dependencies` vector of the `:dev` profile in `project.clj`.

{% highlight clojure %}
:profiles {:dev {:dependencies [[alembic "0.1.0"]]}}
{% endhighlight %}


[Alembic](https://github.com/pallet/alembic) is in its infancy.  Having lein
running in a classloader, off to the side as it were, will probably enable lots
more goodies.  Look forward to your comments and suggestions, either in the
project's [issues](https://github.com/pallet/alembic), or on the
[clojure-tools](https://groups.google.com/forum/?fromgroups#!forum/clojure-tools)
google group.
