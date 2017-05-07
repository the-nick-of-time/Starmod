@echo off
set root="C:\Program Files (x86)\Steam\SteamApps\common\Starbound"

echo Packing
%root%\win32\asset_packer.exe .\MOD %root%\mods\Fixes.pak
echo Finished packing, you're good to go!
pause
