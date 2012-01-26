## Release notes


### zookeeper-0.5.1

- Add scm declaration in zookeeper pom, to allow module release

- Set the zookeeper user's goup explicitly

- Wait for zookeeper response in live-test

- Fix download URL for zookeeper and bump version to one that can be
  downloaded


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

- Add explicit clientPort default, and add live-test

- Fix init script for rhel. Switch to internal ip addresses, and use ip
  rather than name for myid

- Move node creation for tests in test-utils. Fix direct java style access to
  nodes from crates

- working node-list compute service

- Refactored to extract compute provider lib

- Updated to use template as a map, and for new Hardware in jclouds nodes

- Refactoring to a more functional implementation

- zookeeper crate now writes correct configuration.

- Fix server definition in zookeeper config

- added zookeeper crate

