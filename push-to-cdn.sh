#!/bin/bash
## Pushes assets to cdn
## usage:
##   push-to-cdn version-code
ver=$1

push-cdn ()
{
    swift upload com.palletops $1 --object-name "$ver/$1";
}

push-cdn css
push-cdn images

