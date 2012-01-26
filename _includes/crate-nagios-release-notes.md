## Release notes

- Update crates for pallet 0.6.3


### pallet-crates-0.5.0


### pallet-crates-0.4.4


### pallet-crates-0.4.3

- Update versions, and add pallet-crates-test dependencies

- Update for 0.5.0-SNAPSHOT
  Change pallet.resource.\* to pallet.action.\*. Change stevedore calls to
  script functions to use unquote and the pallet.script.lib namespace. 
  Change request to session.  Change build-resources to build-actions.


### pallet-crates-0.4.2


### pallet-crates-0.4.1


### pallet-crates-0.4.0


### pallet-crates-0.4.0-beta-1

- Add and improve nagios crate doc strings

- removed nagios-config dependency from nagios-test

- rationalise nagios and haproxy host naming

- Fixed outstanding .getTag calls

- Move node creation for tests in test-utils. Fix direct java style access to
  nodes from crates

- working node-list compute service

- Refactored to extract compute provider lib

- Add retrieval of files from node. Refactor sending of files to remove
  \*file-transfers\*. Add ssh-key/record-public-key to retrieve a users
  public key from a remote node.

- Updated to use template as a map, and for new Hardware in jclouds nodes

- Fixes for functional style.  Added :no-packages target for testing. Added
  brew as default packager on mac.

- Refactoring to a more functional implementation

- Changed nagios to use tag and id for host name

- Fix nagios/contact to work on first install

- and nagios configuration of non pallet-managed hosts and services

- update key destructuring to match used keys

- changed nagios-config/command arguments to match nagios names

- added nagios servicegroups, contacts, and improved service definitions

- Factored out produce-phase from produce-phases. Fixed testing of deflocal
  phases

- Added nagios and postfix crates

