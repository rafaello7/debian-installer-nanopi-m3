## Debian installer for NanoPi M3 from FriendlyARM

### How to install

Download installation image from [releases](releases) page. Get an empty micro SD card. At least 8 GB card capacity is recommended. Write the installation image directly to the SD card. For example, on Linux system it may be done by run the following command as root:

	cat debian-installer-nanopi.img >/dev/sdX

Where the sdX is the SD card device. Next, insert the SD card into NanoPi device SD card slot. Plug monitor, keyboard and mouse. Power on the device. Wait until installer boots (this may take some time). Follow installation instructions.

Note that Debian installer is robust and allows to install Debian not only on SD card. But for NanoPi there are some limitations concerning _/boot_ directory, namely:

 * it must be located on SD card; it does not matter whether it is mounted or not mounted as a separate partition, but in all cases it must be located on SD card
 * it cannot be on LVM
 * filesystem type may be only ext2/ext3/ext4

These limitations are caused by _u-boot_ restrictions.

Debian installer also warns at some point about missing kernel modules for MD Raid. The warning may be simply ignored ;)


### Debian installer build

The package may be built only on target Debian system, i.e. on arm64 device running Debian. To properly build the image, some base images must be collected in _base_ subdirectory, namely:

 * debian-installer package source. It may be obtained by invoke:

	    apt-get source debian-installer

 * bl1 image, _bl1-drone.bin_
 * u-boot binary image, _u-boot.bin_
 * Debian package with kernel - it may be taken from [NanoPi kernel](https://github.com/rafaello7/linux-nanopi-m3) release files or built from sources as _bindeb-pkg_ target.

The directory contents may look like below:

	$ ll debian-installer-nanopi-m3/base
	total 6080
	-rw-r--r-- 1 rafal rafal   28140 Jul 28 17:47 bl1-drone.bin
	drwxr-xr-x 5 rafal rafal    4096 Jul 18 07:21 debian-installer-20170615+deb9u1
	-rw-r--r-- 1 rafal rafal 5854766 Jul 27 21:24 linux-image-4.11.6+_4.11.6+-395_arm64.deb
	-rw-r--r-- 1 rafal rafal  335624 Jul 28 17:55 u-boot.bin

It is also necessary to install tools needed to build the installer:

	sudo apt-get build-dep debian-installer

Finally, run _make_ in main directory.

