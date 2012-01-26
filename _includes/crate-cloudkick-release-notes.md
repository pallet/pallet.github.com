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

- working node-list compute service

- fix cloudkick crate test for packages being non-aggregated

- Add retrieval of files from node. Refactor sending of files to remove
  \*file-transfers\*. Add ssh-key/record-public-key to retrieve a users
  public key from a remote node.

- Updated to use template as a map, and for new Hardware in jclouds nodes

- Refactoring to a more functional implementation

- Added package-manager-non-interactive to package/packages

- Made converge run phase by phase, instead of node by node.  Added
  pre-phase. Removed :reload-all from tests to avoid deftype problems.

- removed 1.1 compat.  fixed compile errors from id/providerId changes

- Added recognition of ppa: urls for apt source :url

- Harmonised do-script, cmd-join, et al.  Added defvar, defn, and println to
  stevedore. minor documentation fixes.

- Added error handling

- Removed deprecation warnings.  Various fixes.

- Added cloudkick agent crate, added packager source management to package

