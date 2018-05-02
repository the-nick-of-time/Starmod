#!/usr/bin/env bash

root=~/.steam/steam/steamapps/common/Starbound/linux

echo Packing
$root/asset_packer ./MOD $root/../mods/Fixes.pak
echo Finished packing!
