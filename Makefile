all:
	$(MAKE) clean
	cd ubootenv && $(MAKE)
	cd ubootimg && $(MAKE)
	cd ap6212-firmware-di && $(MAKE) deb
	cd kernel-di && $(MAKE) deb
	cd nanopi-bootable && $(MAKE) deb
	cd nanopi-bluetooth && $(MAKE) deb
	cd installer && $(MAKE) scratch
	cd image && $(MAKE)

clean:
	cd ubootenv && $(MAKE) clean
	cd ubootimg && $(MAKE) clean
	cd ap6212-firmware-di && $(MAKE) clean
	cd kernel-di && $(MAKE) clean
	cd nanopi-bootable && $(MAKE) clean
	cd nanopi-bluetooth && $(MAKE) clean
	cd installer && $(MAKE) clean
	cd image && $(MAKE) clean
	rm -f *.udeb
