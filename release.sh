#!/usr/bin/env bash
#
# Script to release to the web site

if [[ $# -lt 1 ]]; then
  echo "usage: $(basename $0) version" >&2
  exit 1
fi

version=$1

git flow release start $version \
&& git flow release finish $version
