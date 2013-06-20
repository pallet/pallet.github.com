---
layout: news
title: Facebook's Chef Usage Mirrors Pallet's Approach to Config Files
permalink: facebook-config-files
published: false
summary: Facebook uses chef to write full configuration files.
author: Hugo Duncan
section: blog
---

I recently watched
[Phil Dibowitz's talk](http://www.youtube.com/watch?v=SYZ2GzYAw_Q) at
[2013 ChefConf](http://chefconf.opscode.com/), and was intrigued to hear him
talk about how configuration files are managed.

He
[says](http://www.youtube.com/watch?feature=player_detailpage&v=SYZ2GzYAw_Q#t=929s)

> "This is where this talk will diverge from probably every other configuration
> management talk you have ever seen, and where our internal setup of chef
> differs from everyone else."

What he goes on to talk about really reflects something that is pretty much the
default in Pallet.

Using the example of `sysctl`, his basic point is that we should be managing the
whole of a system service (like sysctl or crontab), rather than managing
individual records within it.

One benefit of this is that when an entry is removed in the configuration
management system, then the entry in the managed machine is cleaned up, which
doesn't happen automatically otherwise.

Phil carries on to argue that writing the whole of a configuration file based on
a data structure also gives composability.  A base configuration can be
specified, and then individual cookbooks can just specify the configuration that
is important to them.  For Facebook, this led to reduced demands on the core
infrastructure team, and made it easy to delegate configuration choices to
individual teams.

I think another benefit, not mentioned by Phil, is making the system
configuration queryable without having to ask the system (eg. using `ohai`).

The writing of complete configuration files is very much part of the default way
of using pallet.  To see how this works with `limits`, see the
[`limits-conf` crate](https://github.com/pallet/pallet/blob/develop/src/pallet/crate/limits_conf.clj).
