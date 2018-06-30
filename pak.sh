#!/usr/bin/env bash

root=~/.steam/steam/steamapps/common/Starbound/linux

echo Packing Fixes
$root/asset_packer ./MOD $root/../mods/Fixes.pak
echo Finished packing!

echo Packing FU Immortal Critters
$root/asset_packer ./FU_ImmortalCritters $root/../mods/FU_ImmortalCritters.pak
echo Finished packing!
