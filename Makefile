sb_bin_dir = ~/games/starbound/linux
sb_assets_dir = ~/games/starbound/assets
sb_mods_dir = ~/games/starbound/mods

build/Fixes.pak: $(shell find ./MOD/ -type f)
	mkdir -p build
	$(sb_bin_dir)/asset_packer ./MOD/ $@

build/FU_ImmortalCritters.pak: $(shell find ./FU_ImmortalCritters/ -type f)
	mkdir -p build
	$(sb_bin_dir)/asset_packer ./FU_ImmortalCritters/ $@


unpacked/: $(sb_assets_dir)/packed.pak $(sb_bin_dir)/asset_unpacker
	$(sb_bin_dir)/asset_unpacker $(sb_assets_dir)/packed.pak ./unpacked/


.PHONY: clean clean-assets build install

clean:
	rm -rf build/

clean-assets:
	rm -rf unpacked/

build: build/Fixes.pak build/FU_ImmortalCritters.pak

install: build
	cp build/* $(sb_mods_dir)/
	cp dependencies/improved_containers.pak $(sb_mods_dir)/
