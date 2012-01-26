## Release notes

### haproxy-0.6.0

- Make sure the crate is idempotent. Allow options.

- Make Haproxy enable the 'epel' repo when installing.

### pallet-crates-0.5.0

### pallet-crates-0.4.4

- Update for repository management in separate namespaces

### pallet-crates-0.4.3

- Update for 0.5.0-SNAPSHOT
  Change pallet.resource.\* to pallet.action.\*. Change stevedore calls to
  script functions to use unquote and the pallet.script.lib namespace.
  Change request to session.  Change build-resources to build-actions.


### pallet-crates-0.4.2


### pallet-crates-0.4.1


### pallet-crates-0.4.0


### pallet-crates-0.4.0-beta-1

- Use epel for haproxy on CentOS

- fix haproxy for amzn-linux

- rationalise nagios and haproxy host naming

- Move node creation for tests in test-utils. Fix direct java style access to
  nodes from crates

- working node-list compute service

- Refactored to extract compute provider lib

- haproxy crate defaults to using epel 5-4 on centos

- Switch amzn-linux to use epel for haproxy

- Add centos 5.5 repo for haproxy on amzn-linux

- Updated the haproxy crate to use safe ids.

- Fixed issue in haproxy crate where it would break with EC2 since EC2 nodes
  have no name, only id.

- fix haproxy test

- only produce configuration for keys with content

- Updated to use template as a map, and for new Hardware in jclouds nodes

- Make the sequence of sections in haproxy config file deterministic

- enable haproxy in /etc/defaults

- add haproxy crate

