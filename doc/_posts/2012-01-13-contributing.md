---
title: First Steps
layout: doc
permalink: /doc/contributing
section: documentation
subsection: community
summary: Guidelines for contributing to the Pallet project.
---
## Tests

Please make sure tests pass, and test cases are added to cover new code.

To run the pallet tests, you will need to authorise your id_rsa key on localhost.

To run pallet-crates live-test, you can use the `live-test` profile:

    mvn clojure:test -P live-test -Dpallet.test.service-name=ec2

## Source Code Format

Source code should follow the following rules:
- No Tabs
- 80 character maximum line length

## Commit messages

Commit messages are used to generate the changelog (see below).

your messages should start with a single line that's no more than about 50
characters and that describes the changeset concisely, followed by a blank line,
followed by a more detailed explanation.

See http://progit.org/book/ch5-2.html#commit_guidelines for a more complete
explaination of commit messages.

## Changelog
The [changelog](/doc/changelog) is maintained in the wiki, and is built using commit messages.

The changelog format is produced directly by git, just add the following to your
`.gitconfig` file:

    changelog = format:- %w(76,0,2)%s%n%w(76,2,2)%b

To generate the raw input for the changelog, then run the following, replacing
`pallet-0.4.0` with a commit or tag that you want to start from:

    git log --pretty=changelog  pallet-0.4.0..
