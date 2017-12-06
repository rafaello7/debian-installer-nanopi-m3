
all:
	$(MAKE) clean
	dpkg-deb -x ../base/linux-image-*.deb tmp
	# kernel image
	mkdir boot
	mv tmp/boot/System.map-* boot/System.map
	mv tmp/boot/vmlinuz-* boot/vmlinuz
	# kernel modules
	mv tmp/lib lib

deb:
	./pkgprepare.sh
	dpkg-buildpackage -b -uc
	rm -f ../linux_1_arm64.buildinfo
	rm -f ../linux_1_arm64.changes

clean:
	rm -rf tmp boot lib
