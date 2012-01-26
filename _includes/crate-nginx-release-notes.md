## Release notes


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

- Added rubygems crate dependency to nginx crate

- working node-list compute service

- remove defresource usage from crate/nginx

- Updated to use template as a map, and for new Hardware in jclouds nodes

- Refactoring to a more functional implementation

- Added config for nginx mime.types, and nginx parameters for user and group

- Made converge run phase by phase, instead of node by node.  Added
  pre-phase. Removed :reload-all from tests to avoid deftype problems.

- Fix nginx init script install, and make ssh key authorisation more robust

- Updated docs

- Various crate changes. Added Changelog

- split nginx site template into site and location templates

- fixed remove of appropriate site

- Harmonised do-script, cmd-join, et al.  Added defvar, defn, and println to
  stevedore. minor documentation fixes.

- Added error handling

- Removed deprecation warnings.  Various fixes.

- Pushed map-with-keys-as-symbols into interpolate-template

- clean up of crates for new target bindings

- change pallet.target's \*target-template\* and \*target-tag\* to \*target-node\*
  and \*target-node-type\*

- Added crontab, cruise-control-rb, and nginx crates.  Added a
  tomcat/undeploy. Added a service/init.

