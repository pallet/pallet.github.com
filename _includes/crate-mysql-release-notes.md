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

- Fix mysql crate for yum install

- working node-list compute service

- Refactored to extract compute provider lib

- Add retrieval of files from node. Refactor sending of files to remove
  \*file-transfers\*. Add ssh-key/record-public-key to retrieve a users
  public key from a remote node.

- Updated to use template as a map, and for new Hardware in jclouds nodes

- Refactoring to a more functional implementation

- Added package-manager-non-interactive to package/packages

- Made converge run phase by phase, instead of node by node.  Added
  pre-phase. Removed :reload-all from tests to avoid deftype problems.

- Added error checking to mysql-script. Fixed password quoting in
  create-user.

- Fixed mysql install password bug. Added create-database, create-user and
  grant.  Improved tests

- Various crate changes. Added Changelog

- Added target/\*all-nodes\* and target/\*target-nodes\*.  Made target vars
  uninitialised. Tidied mock.

- unification of defresource & defcomponent, elimination of atom usage in
  general, formalized sub-phase / execution type

- Added defnode, lift and configuration phases. Adds declaritive
  configuration definiton.

- added crates for sphinx, tomcat and hudson. added a service resource.
  tomact and hudson not yet fully functional.  Fixed escaping in
  mysql-script.

- minor improvements, and doc fixes

- fixed bug from jclouds api change. added resources and crates

