#!/bin/bash

release_info=$(curl https://api.github.com/repos/sayterdarkwynd/FrackinUniverse/releases/latest)
current_version=$(test -f dependencies/FrackinUniverse/.metadata && jq -r '.version' <dependencies/FrackinUniverse/.metadata || echo '0.0.0')
release_version=$(jq -r '.tag_name' <<<"$release_info")
echo $current_version $release_version
if [ "$current_version" = "$release_version" ] ; then
    exit 0
fi
# assume that any difference is an increase

tarball=$(jq -r '.tarball_url' <<<"$release_info")
if [ -d dependencies/FrackinUniverse ] ; then
	rm -r dependencies/FrackinUniverse
fi
curl -L "$tarball" | tar -xz --strip-components=1 --one-top-level=dependencies/FrackinUniverse
