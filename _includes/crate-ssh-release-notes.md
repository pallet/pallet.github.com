## Release notes


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

- Add pacman packages for ssh

- Move node creation for tests in test-utils. Fix direct java style access to
  nodes from crates

- working node-list compute service

- Refactored to extract compute provider lib

- Fix file transfers for paths that need shell expansion

- Add retrieval of files from node. Refactor sending of files to remove
  \*file-transfers\*. Add ssh-key/record-public-key to retrieve a users
  public key from a remote node.

- Update pallets server/ci.  Add some use of hudson-cli to allow triggering
  of builds through pallet.

- removed defresource usage from crate/ssh-key

- Updated to use template as a map, and for new Hardware in jclouds nodes

- Refactoring to a more functional implementation

- added nagios servicegroups, contacts, and improved service definitions

- Made converge run phase by phase, instead of node by node.  Added
  pre-phase. Removed :reload-all from tests to avoid deftype problems.

- Fixed service start-stop configuration, added sed resource, added md5-url
  option, switched to curl

- Fix nginx init script install, and make ssh key authorisation more robust

- Various crate changes. Added Changelog

- Fix requires in ssh crate. Add minimal test.

- Added ssh crate

- added options to ssh-keygen

- removed 1.1 compat.  fixed compile errors from id/providerId changes

- Added target/\*all-nodes\* and target/\*target-nodes\*.  Made target vars
  uninitialised. Tidied mock.

- Harmonised do-script, cmd-join, et al.  Added defvar, defn, and println to
  stevedore. minor documentation fixes.

- Added error handling

- unification of defresource & defcomponent, elimination of atom usage in
  general, formalized sub-phase / execution type

- improvements to pallet ci server config

- Added pallet.admin.username property

- hudson crate has basic functionality

- clojure 1.1 / 1.2 compatibility modifications

- clojure 1.1 / 1.2 compatibility modifications

- Added defnode, lift and configuration phases. Adds declaritive
  configuration definiton.

- fixed bug from jclouds api change. added resources and crates

