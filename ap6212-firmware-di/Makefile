#!/bin/sh -e
all:

deb:
	dpkg-buildpackage -b -uc
	rm -f ../ap6212-firmware-di_1_arm64.buildinfo
	rm -f ../ap6212-firmware-di_1_arm64.changes

clean:

