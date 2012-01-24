---
title: cruise-control-rb
layout: doc
permalink: /doc/reference/cruise-control-rb
section: documentation
subsection: crates
summary: Install and configure cruise-control-rb
---
Install and configure cruise-control-rb

- [Source repository](https://github.com/pallet/cruise-control-rb-crate "GitHub Repository for crate")
- [Issues](https://github.com/pallet/cruise-control-rb-crate/issues "GitHub Issues for crate")

## Release notes

- Update crates for pallet 0.6.3


### pallet-crates-0.5.0


### pallet-crates-0.4.4


### pallet-crates-0.4.3

- Update for 0.5.0-SNAPSHOT
  Change pallet.resource.\* to pallet.action.\*. Change stevedore calls to
  script functions to use unquote and the pallet.script.lib namespace. 
  Change request to session.  Change build-resources to build-actions.


### pallet-crates-0.4.2


### pallet-crates-0.4.1


### pallet-crates-0.4.0


### pallet-crates-0.4.0-beta-1

- Remove superfluous space from test

- working node-list compute service

- Add retrieval of files from node. Refactor sending of files to remove
  \*file-transfers\*. Add ssh-key/record-public-key to retrieve a users
  public key from a remote node.

- Updated to use template as a map, and for new Hardware in jclouds nodes

- Refactoring to a more functional implementation

- Made converge run phase by phase, instead of node by node.  Added
  pre-phase. Removed :reload-all from tests to avoid deftype problems.

- Added target/\*all-nodes\* and target/\*target-nodes\*.  Made target vars
  uninitialised. Tidied mock.

- Added error handling

- Removed deprecation warnings.  Various fixes.

- clean up of crates for new target bindings

- change pallet.target's \*target-template\* and \*target-tag\* to \*target-node\*
  and \*target-node-type\*

- Added crontab, cruise-control-rb, and nginx crates.  Added a
  tomcat/undeploy. Added a service/init.

