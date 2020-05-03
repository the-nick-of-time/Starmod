sb_bin_dir = ~/games/starbound/linux
sb_assets_dir = ~/games/starbound/assets
sb_mods_dir = ~/games/starbound/mods

build/Fixes.pak: MOD
	mkdir -p build
	$(sb_bin_dir)/asset_packer $< $@

build/FU_ImmortalCritters.pak: FU_ImmortalCritters
	mkdir -p build
	$(sb_bin_dir)/asset_packer $< $@


unpacked/: $(sb_assets_dir)/packed.pak $(sb_bin_dir)/asset_unpacker
	$(sb_bin_dir)/asset_unpacker $(sb_assets_dir)/packed.pak ./unpacked/


.PHONY: clean clean-assets

clean:
	rm -rf build/

clean-assets:
	rm -rf unpacked/
