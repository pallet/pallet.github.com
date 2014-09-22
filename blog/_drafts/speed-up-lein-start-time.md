---
layout: main/blog-post
title: Speed up your Leiningen Start-Up Time
author: Hugo Duncan
section: blog
categories:
    - clojure
    - leiningen
---

[leiningen][leiningen] suffers from JVM and [Clojure][clojure]
start-up times, and while [Phil][technomancy] does a lot to minimise these, your
leiningen `profiles.clj` file can significantly slow things down
again.

## How Much is `profiles.clj` Slowing You Down?

The first thing to try is to measure how much your lein configuration
is slowing you down.  Run these commands a few times to see the
difference:

```clj
time lein version
LEIN_NO_USER_PROFILES=1 time lein version
```

On my system, `lein` 2.5.0 takes about 2.6s to run without any user
profiles loaded.  Adding plugins to `:plugins` in the `:user` profile
in `profiles.clj` increases this time for each plugin you add.

So, to speed up leiningen startup times, all we need to do is remove
all the `:plugins` from your user profile.  Of course, you still want
all the functionality these provide, so let's be clever about how we
add them.

## Task Plugins

For plugins that provide a task, such as [lein-plz][lein-plz] or
[eastwood][eastwood], we only need the plugin when we want to run the
task.  We can achieve this using aliases and profiles.

```clj
{ …
 :user {:aliases {"eastwood" ["with-profile" "+eastwood" "eastwood"]}}
 :eastwood {:plugins [[jonase/eastwood "0.1.4"]]}
 … }
```

## REPL Plugins

Other plugins, such as [alembic][alembic] or [criterium][criterium]
are meant for use at the repl.  We can restrict these to be loaded in
the `:repl` profile.

```clj
{ …
:repl {:dependencies [[alembic "0.3.1" :exclusions [org.clojure/clojure]]
                      [criterium "0.4.3"]
                      [cider/cider-nrepl "0.8.0-SNAPSHOT"]]}
 … }
```

## Other Plugins

Not all plugins are amenable to this.  For example
[lein-inject][lein-inject] will still need to go into the `:user`
profile `:plugins`.  For these you have to rely on the plugin's
authors to minimise the impact on start-up time.

## Plugin writers

If you're the author of a plugin, take some time to check how your
plugin affects leiningen start-up time.  In particular, don't require
task namespaces just to hook them (esp. leiningen.repl), as these can
then get loaded no matter which task is being run.


[clojure]:http://clojure.com/ "Clojure"
[leiningen]:https://github.com/technomancy/leiningen "Leiningen"
[eastwood]:https://github.com/jonase/eastwood "Eastwood linter for clojure"
[lein-plz]:https://github.com/johnwalker/lein-plz "Plz add depenencies"
[alembic]:https://github.com/pallet/alembic "Alembic add dependencies and run Lein at the REPL"
[criterium]:https://github.com/pallet/criterium "Criterium microbenchmarking"
[lein-inject]:https://github.com/palletops/lein-inject "Lein-inject convenience namespaces for the REPL"
[technomancy]:http://technomancy.us/
