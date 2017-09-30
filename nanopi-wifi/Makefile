bdir = var/lib/nanopi-wifi

all:
	$(MAKE) clean
	mkdir -p $(bdir)
	cp ../ap6212-firmware_*_all.deb $(bdir)

deb:
	dpkg-buildpackage -b -uc
	rm -f ../nanopi-wifi_*_arm64.buildinfo
	rm -f ../nanopi-wifi_*_arm64.changes

clean:
	rm -rf var
