## Debian installer for FriendlyARM NanoPi M3

### How to install Debian using the installer

Download installation image from [releases](https://github.com/rafaello7/debian-installer-nanopi-m3/releases) page. Get micro SD card, on which the Debian system should be installed. At least 8 GB card capacity is recommended. Write the installation image directly to the SD card. For example, on Linux system it may be done by run the following command as root:

	cat debian-installer-nanopi.img >/dev/sdX

Where sdX is the SD card device. Next, insert the SD card into NanoPi device SD card slot. Plug monitor, keyboard and mouse. Power on the device. Wait until installer boots (this may take some time). Follow installation instructions.

Note that Debian installer is robust and allows to install Debian not only on SD card. But for NanoPi there are some limitations concerning _/boot_ directory, namely:

 * the _/boot_ directory must be located on SD card; it does not matter whether it is mounted or not mounted as a separate partition, but in all cases it must be located on SD card
 * it cannot be on LVM
 * filesystem type may be only ext2/ext3/ext4

These limitations are caused by _u-boot_ restrictions. On the other hand, it is possible to locate root partition on e.g. some USB hard drive.

The installer needs of course Internet connection. It downloads plenty of packets from Debian repository. It is possible to connect using either wifi or ethernet. Both methods are working.

Debian installer warns at some point about missing support for software RAID devices. The warning may be simply ignored :)

### Installation hints

Debian installer was developed for use on normal PC. Hence it leads the installation in the way suitable for normal PC, which may be not optimal for NanoPi device. Namely:

 * Partition manager demands some swap space. It is a good idea for the NanoPi, but not on SD card. Swap space on SD card is a bad idea in general, because SD card has limited lifetime. Set up swap space on SD card may significantly decrease life time of the SD.
 
 * The Debian installer proposes installation of various desktop environments, including GNOME and KDE. But the device has limited amount of memory and such heavy environments may not work properly. Lightweight desktop environments like LXDE or Xfce should work fine. But beware also on web browsers like firefox or Google chrome (chromium). They may eat hundreds megabytes of memory.

The installer is not perfect. Sometimes some step may fail. For example, I encountered a problem with software installation step. It failed because the installer pulled software over a hour and the repository has changed in the meantime - some packages were gone. It was enough to repeat the step - the installer has updated their information about repository contents and has finished successfully.

When some installation step fails, please press Ctrl+Alt+F4. This key combination redirects to page with installation logs. They may provide more accurate information about the failure reason. Sometimes a problem may appear because of problems with hardware, for example broken SD card. The installation logs should provide accurate information.


### How to bould own Debian installer from sources

The installation image may be built only on target Debian system, i.e. on arm64 device running Debian. To properly build the image, some base images must be collected in _base_ subdirectory, namely:

 * upstream debian-installer package source. It may be obtained by invoke:

	    apt-get source debian-installer

 * bl1 boot image, _bl1-drone.bin_
 * u-boot binary image, _u-boot.bin_
 * Debian package with kernel - it may be taken from [NanoPi kernel release files](https://github.com/rafaello7/linux-nanopi-m3/releases) or built from the kernel sources as _bindeb-pkg_ target.

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

