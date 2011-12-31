---
layout: news
title: Zi, the Maven plugin in Clojure
permalink: zi-the-maven-plugin-in-clojure
---
YACMP doesn't trip off the tongue, so this clojure maven plugin is called [Zi](http://bit.ly/zicljpops), and it's written in clojure. Some highlights:

* lein style checkout projects -- develop your project's dependencies without repackaging them
* no forking -- goals run in the maven process
* can be installed globally -- some goals run without adding the plugin to the pom
* written (mainly) in clojure -- can use all of clojure's expressive power and libraries

## Why another maven plugin for clojure?

[leiningen](https://github.com/technomancy/leiningen) and [cake](https://github.com/flatland/cake) are both great tools for an ever expanding set of use cases, but there are still many reasons to fall back on maven.

[Mark](http://www.talios.com) has done a fantastic job with [clojure-maven-plugin](https://github.com/talios/clojure-maven-plugin), but it feels wrong coding in java to work with clojure code, and using clojure brings all of clojure's libraries within easy reach. Zi also works a little differently to clojure-maven-plugin.

## What's different

The goals use a non-forked execution model -- they are executed within the maven process itself, which should make it faster.

The clojure compiler is available as a compiler plugin for maven-compiler-plugin (see Zi's pom for an example of this).  The `compile` goal in Zi just extends maven-compiler-plugin to set the default language to clojure.  It inherits the inclusion and exclusion mechanism, as well as the detection of out of date target files.

The plugin is designed to be 'fat', in that it comes with dependencies on [ritz](http://bit.ly/ritzpops), [swank-clojure](https://github.com/technomancy/swank-clojure), [marginalia](https://github.com/fogus/marginalia), etc, so the plugin can be installed globally and used against an maven based clojure project without explicitly adding zi as a plugin.

It doesn't have all the bells and whistles of clojure-maven-plugin yet, but it does have support for leiningen style checkouts.

Lein style checkouts allow you to develop your project's dependencies without having to re-jar them after each modification -- just symlink your lein projects in a project level `checkouts` directory.  Support for maven based projects in `checkouts` is pending release of maven 3.0.4.

## So how do I use it?

The [Zi readme](http://bit.ly/zicljpops) has the details, bit here is an overview:

The plugin uses the `sourceDirectory` element from the `pom.xml`, and automatically translates any `/java` suffix to `/clojure`, which means it uses `src/main/clojure` by default.

To copy clojure source files to the output target directory, add the zi plugin, and add an execution for the `resource` goal.

To AOT compile, add an execution for the `compile` goal.

To start a [ritz](http://bit.ly/ritzpops) server, `mvn zi:ritz`

To start a [swank-clojure](https://github.com/technomancy/swank-clojure) server, `mvn zi:swank-clojure`.

To generate [marginalia](https://github.com/fogus/marginalia) documentation, `mvn zi:marginalia`