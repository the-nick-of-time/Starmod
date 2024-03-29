sb_bin_dir = ~/games/starbound/linux
sb_assets_dir = ~/games/starbound/assets
sb_mods_dir = ~/games/starbound/mods

build: build/QOL++.pak build/FU_ImmortalCritters.pak build/ImmortalBugs.pak


build/QOL++/QOL++.pak: $(shell find ./QOL++/src/ -type f) | build/QOL++/
	$(sb_bin_dir)/asset_packer ./QOL++/src/ $@

build/FU_ImmortalCritters/FU_ImmortalCritters.pak: ./FU_ImmortalCritters/src/monsters ./FU_ImmortalCritters/src/.metadata | build/FU_ImmortalCritters/
	$(sb_bin_dir)/asset_packer ./FU_ImmortalCritters/src/ $@

build/FrackinUniverse/FrackinUniverse.pak: ./dependencies/FrackinUniverse/.metadata | build/FrackinUniverse/
	$(sb_bin_dir)/asset_packer ./dependencies/FrackinUniverse $@

build/ImmortalBugs/ImmortalBugs.pak: ImmortalBugs/src/monsters | build/ImmortalBugs/
	$(sb_bin_dir)/asset_packer ./ImmortalBugs/src $@

unpacked/: $(sb_assets_dir)/packed.pak $(sb_bin_dir)/asset_unpacker
	$(sb_bin_dir)/asset_unpacker $(sb_assets_dir)/packed.pak ./unpacked/

build/%/:
	mkdir -p build/$*/

FU_ImmortalCritters/src/monsters FU_ImmortalCritters/src/.metadata: FU_ImmortalCritters/generate_patch.py dependencies/FrackinUniverse/.metadata
	python3 $<

ImmortalBugs/src/monsters: ImmortalBugs/generate_patch.py unpacked/
	python3 $<

$(sb_mods_dir)/%.pak: build/%.pak
	cp "$<" "$@"

# special case
$(sb_mods_dir)/improved_containers.pak: dependencies/improved_containers.pak
	cp "$<" "$@"


.PHONY: clean clean-assets build install-core install-fu download-fu upload

clean:
	rm -rf build/
	rm -rf FU_ImmortalCritters/src/monsters
	rm -f FU_ImmortalCritters/src/.metadata
	rm -rf ImmortalBugs/src/monsters

clean-assets:
	rm -rf unpacked/

install-core: $(sb_mods_dir)/QOL++.pak $(sb_mods_dir)/ImmortalBugs.pak $(sb_mods_dir)/improved_containers.pak

install-fu: $(sb_mods_dir)/FU_ImmortalCritters.pak $(sb_mods_dir)/FrackinUniverse.pak

download-fu:
	./update_fu.sh

build/intermediate/steam_upload.vdf: QOL++/src/.metadata QOL++/json_to_vdf.py QOL++/steam_icon.png | build/intermediate/
	python3 QOL++/json_to_vdf.py build/QOL++/ QOL++/steam_icon.png <QOL++/src/.metadata >$@

upload: build/QOL++/QOL++.pak build/intermediate/steam_upload.vdf
	~/bin/steamcmd.sh +login adenn1420 +workshop_build_item $(shell pwd)/QOL++/steam_upload.vdf +quit
