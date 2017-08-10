bdir = var/lib/nanopi-bootable

all: ../ubootimg/boot.img ../ubootenv/ubootenv
	$(MAKE) clean
	mkdir -p $(bdir)
	cp ../base/linux-image-*.deb $(bdir)
	cp ../ubootimg/boot.img $(bdir)
	cp ../ubootenv/ubootenv $(bdir)

deb:
	dpkg-buildpackage -b -uc
	rm -f ../nanopi-bootable_*_arm64.buildinfo
	rm -f ../nanopi-bootable_*_arm64.changes

clean:
	rm -rf var
