#!/bin/sh

set -e

errcho() {
    echo "$@" >&2
}

if [ "$#" -ne 2 ] ; then
    errcho "$0 MOD VERSION"
    exit 1
fi

mod="$1"
version="$2"

if [ ! -d "$mod/src" ] ; then 
    errcho "$mod is not an existing mod"
    exit 11
fi
if echo "$version" | grep -Evq '[0-9]+\.[0-9]+(\.[0-9]+)?' ; then
    errcho "$version must be numbers only"
    exit 12
fi

meta="$mod/src/.metadata"

if [ ! -f "$meta" ] ; then 
    errcho "$meta not found, probably the entered mod name is wrong"
    exit 13
fi

temp=$(mktemp)
<"$meta" jq ".version |= \"$version\"" >"$temp"
mv "$temp" "$meta"

git add "$meta"
git commit
git tag "$version"
