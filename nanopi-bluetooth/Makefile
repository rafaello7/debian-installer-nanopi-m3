bdir = var/lib/nanopi-bluetooth

all:
	$(MAKE) clean
	mkdir -p $(bdir)
	cp ../base/nanopi-bluetooth_*arm64.deb $(bdir)

deb:
	dpkg-buildpackage -b -uc
	rm -f ../nanopi-bluetooth_*_arm64.buildinfo
	rm -f ../nanopi-bluetooth_*_arm64.changes

clean:
	rm -rf var
