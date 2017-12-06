include ../$(shell sed -ne 's/^ID=//p' </etc/os-release).conf

kernelver = $$(cd ../../../base; echo linux-image-*.deb | sed -e 's/linux-image-\([0-9]\.[0-9]\+\.[0-9]\++\?\)_.*\.deb/\1/')

all:
	rm -rf upstream/build/stamps upstream/build/tmp upstream/build/dest
	cp ../base/ap6212-firmware-di_*_all.udeb upstream/build/localudebs
	cp ../kernel-image-*-di_1_arm64.udeb upstream/build/localudebs
	cp ../nanopi-bootable_1_arm64.udeb upstream/build/localudebs
	cp ../nic-modules-*-di_1_arm64.udeb upstream/build/localudebs
	cp ../nanopi-wifi_1_arm64.udeb upstream/build/localudebs
	cp ../nanopi-bluetooth_1_arm64.udeb upstream/build/localudebs
	cd upstream/build && make SUBARCH=nanopim3 USE_UDEBS_FROM=$(RELEASE_CODENAME) KERNELVERSION=$(kernelver) $(INSTALLER_TARGET)
	@echo
	@ls -l upstream/build/dest/nanopim3/$(INITRD_PATH)
	@echo

scratch:
	make clean
	mkdir upstream
	cp -r ../base/debian-installer-*/build upstream
	cp -r ../base/debian-installer-*/debian upstream
	cp -ri adaptation/* upstream/build
	echo "SUBARCH_SUPPORTED = nanopim3" >>upstream/build/config/arm64.cfg
	$(MAKE) all

clean:
	rm -rf upstream
