sb_bin_dir = ~/games/starbound/starbound/linux
sb_assets_dir = ~/games/starbound/starbound/assets
sb_mods_dir = ~/games/starbound/starbound/mods

build: build/QOL++.pak build/FU_ImmortalCritters.pak


build/QOL++.pak: $(shell find ./QOL++/src/ -type f)
	mkdir -p build
	$(sb_bin_dir)/asset_packer ./QOL++/src/ $@

build/FU_ImmortalCritters.pak: FU_ImmortalCritters/src/monsters
	mkdir -p build
	$(sb_bin_dir)/asset_packer ./FU_ImmortalCritters/src/ $@

build/FrackinUniverse.pak: ./dependencies/FrackinUniverse/.metadata
	mkdir -p build
	$(sb_bin_dir)/asset_packer ./dependencies/FrackinUniverse $@

unpacked/: $(sb_assets_dir)/packed.pak $(sb_bin_dir)/asset_unpacker
	$(sb_bin_dir)/asset_unpacker $(sb_assets_dir)/packed.pak ./unpacked/


FU_ImmortalCritters/src/monsters: FU_ImmortalCritters/generate_patch.py dependencies/FrackinUniverse/.metadata
	python3.5 $<


.PHONY: clean clean-assets build install-core install-fu download-fu

clean:
	rm -rf build/
	rm -r FU_ImmortalCritters/src/monsters

clean-assets:
	rm -rf unpacked/

install-core: build/QOL++.pak dependencies/improved_containers.pak
	cp $^ "$(sb_mods_dir)/"

install-fu: build/FU_ImmortalCritters.pak build/FrackinUniverse.pak
	cp $^ "$(sb_mods_dir)/"

download-fu:
	./update_fu.sh
