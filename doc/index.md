---
layout: doc
title: Documentation
section: documentation
---

Pallet is a node provisioning, configuration and administration tool.  It is
designed to make small to midsize deployments simple.

- [Overview](/doc/overview)
- [First Steps](/doc/first-steps)
- [Reference Documentation](/doc/reference)
- [API Documentation](http://pallet.github.com/pallet/autodoc/index.html)
- [Annotated Source](http://pallet.github.com/pallet/marginalia/uberdoc.html)

## [Latest Documentation Changes](/doc/changes) <small><a href="/doc/changes/atom.xml">RSS</a></small>
{% for post in site.categories.changes limit:5 %}
- [{{post.date | date_to_string }} &raquo; {{post.title}}]({{post.url}})
{% endfor %}

