all:
	rm -rf upstream/build/stamps upstream/build/tmp upstream/build/dest
	cp ../ap6212-firmware-di_1_all.udeb upstream/build/localudebs
	cp ../kernel-image-4.11.6+-di_4.11.6+-1_arm64.udeb upstream/build/localudebs
	cp ../nanopi-bootable_1_arm64.udeb upstream/build/localudebs
	cp ../nic-modules-4.11.6+-di_4.11.6+-1_arm64.udeb upstream/build/localudebs
	cp ../nanopi-bluetooth_1_arm64.udeb upstream/build/localudebs
	cd upstream/build && make SUBARCH=nanopim3 USE_UDEBS_FROM=stretch KERNELVERSION=4.11.6+ build_nanopim3_netboot-gtk
	@echo
	@ls -l upstream/build/dest/nanopim3/netboot/gtk/initrd.gz
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
