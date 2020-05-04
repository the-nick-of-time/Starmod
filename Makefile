sb_bin_dir = ~/games/starbound/linux
sb_assets_dir = ~/games/starbound/assets
sb_mods_dir = ~/games/starbound/mods

build: build/QOL++.pak build/FU_ImmortalCritters.pak


build/QOL++.pak: $(shell find ./QOL++/src/ -type f)
	mkdir -p build
	$(sb_bin_dir)/asset_packer ./QOL++/src/ $@

build/FU_ImmortalCritters.pak: $(shell find ./FU_ImmortalCritters/ -type f)
	mkdir -p build
	$(sb_bin_dir)/asset_packer ./FU_ImmortalCritters/ $@

build/FrackinUniverse.pak: ./dependencies/FrackinUniverse/.metadata
	$(sb_bin_dir)/asset_packer ./dependencies/FrackinUniverse $@

unpacked/: $(sb_assets_dir)/packed.pak $(sb_bin_dir)/asset_unpacker
	$(sb_bin_dir)/asset_unpacker $(sb_assets_dir)/packed.pak ./unpacked/


.PHONY: clean clean-assets build install-core install-fu download-fu

clean:
	rm -rf build/

clean-assets:
	rm -rf unpacked/

install-core: build/QOL++.pak dependencies/improved_containers.pak
	cp $^ $(sb_mods_dir)/

install-fu: build/FU_ImmortalCritters.pak build/FrackinUniverse.pak
	cp $^ $(sb_mods_dir)/

download-fu:
	curl https://api.github.com/repos/sayterdarkwynd/FrackinUniverse/releases/latest \
		| jq '.tarball_url' \
		| xargs curl -L \
		| tar -xz -C dependencies --strip-components=1 --one-top-level=FrackinUniverse
