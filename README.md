## Debian/Ubuntu installer for FriendlyARM NanoPi M3

The installer was also tested to work on NanoPC T3. The NanoPC T3 board contains emmc card and the installation may be done also on emmc.

### How to install Debian or Ubuntu using the installer

Download installation image from [releases](https://github.com/rafaello7/debian-installer-nanopi-m3/releases) page. For Debian it should be _debian-installer-nanopi.img_ file, for Ubuntu - _ubuntu-installer-nanopi.img_ one. Get an empty micro SD card. This may be the target card on which the Debian or Ubuntu will be installed, but this is not required. Write the installation image directly to the SD card. For example, on Linux system it may be done by run the following command as root:

	cat debian-installer-nanopi.img >/dev/sdX

Where sdX is the SD card device. Insert the SD card into SD card slot on NanoPi. Plug monitor, keyboard and mouse. Power on the device. Wait until installer boots (this may take some time).

At this time the SD card is unused and may be replaced with the target SD. At least 8 GB card is recommended, but it highly depends on desired desktop environment. For installation without GUI 2 GB is enough.

Follow the installation instructions.

Note that the installer is robust and allows to install Debian or Ubuntu not only on SD card. But for NanoPi there are some limitations concerning _/boot_ directory, namely:

 * the _/boot_ directory must be located on SD card; it does not matter whether it is mounted or not mounted as a separate partition, but in all cases it must be located on SD card (on NanoPC T3 it may be also on emmc).
 * it cannot be on LVM
 * filesystem type may be only ext2/ext3/ext4

These limitations are caused by _u-boot_ restrictions. On the other hand, it is possible to locate root partition on e.g. some USB hard drive.

The installer needs of course Internet connection. It downloads plenty of packets from repository. It is possible to connect using either wifi or ethernet. Both methods are working.

The installer warns at some point about missing support for software RAID devices. The warning may be simply ignored :)

### Installation hints

The installer is a minimal adaptation of generic Debian installer. Upstream installer was developed for use on normal PC. Hence it leads the installation in the way suitable for normal PC, which may be not optimal for NanoPi device. Namely:

 * Partition manager demands some swap space. It is a good idea for the NanoPi, but not on SD card. Swap space on SD card is a bad idea in general, because SD card has limited lifetime. Set up swap space on SD card may significantly decrease life time of the SD.
 
 * The installer proposes installation of various desktop environments, including GNOME and KDE. But the device has limited amount of memory and such heavy environments may not work properly. Lightweight desktop environments like LXDE or Xfce should work fine. But beware also on web browsers like firefox or Google chrome (chromium). They may eat hundreds megabytes of memory.

The installer is not perfect. Sometimes some step may fail. For example, I encountered a problem with software installation step. It failed because the installer pulled software over a hour and the repository has changed in the meantime - some packages were gone. It was enough to repeat the step - the installer has updated their information about repository contents and has finished successfully.

When some installation step fails, please press Ctrl+Alt+F4. This key combination redirects to page with installation logs. They may provide more accurate information about the failure reason. Sometimes a problem may appear because of problems with hardware, for example broken SD card. The installation logs should provide accurate information.

### Nano Video

The s5p6818 SOC contains VPU (Video Processing Unit) hardware dedicated
for encoding/decoding video files. The SOC contains also an overlay graphics
layer (plane) dedicated for render graphics in formats suitable for playing
video files (yuv420, yuv422, yuv444). The hardware allows to play video
with little CPU utilization.

I have created [nano-video](https://github.com/rafaello7/nano-video)
program, a simple video player for NanoPi M3 which uses the hardware.
Please try.

#### VPU in detail

Below are some details regarding the hardware usage.

The video hardware is available in Linux as video4linux devices:

 * VPU encoder as /dev/video14
 * VPU decoder as /dev/video15
 * Overlay video layer as /dev/video1

Unfortunately most of the video sofware does not give any opportunity to
utilize these devices. However GStreamer gives this opportunity. The
_gstreamer1.0-plugins-good_ package contains video4linux plugins whose
allow to play the video using VPU decoder and overlay video layer. It is needed
also _h264parse_ plugin from _gstreamer1.0-plugins-bad_. When pulseaudio
package is installed, also _gstreamer1.0-pulseaudio_ package installation is
recommended.

Below are some usage examples of these devices using _gst-launch-1.0_ utility.
A most simple usage, using _playbin_ plugin:

	gst-launch-1.0 playbin uri=file://$HOME/Videos/01_Blessed.mp4 video-sink=v4l2sink

The above command may be also launched without GUI started. It has one
disadvantage, namely it consumes some CPU because decoded image is copied
between VPU and video sink.

A hand-made pipeline for h264 video stream (avc1) with yuv420p image format:

	gst-launch-1.0 filesrc location=$HOME/Videos/01_Blessed.mp4 ! qtdemux name=demux demux.video_0 ! h264parse ! v4l2video15dec capture-io-mode=dmabuf-import ! v4l2sink device=/dev/video1 overlay-top=300 overlay-left=600 overlay-width=1280 overlay-height=720 io-mode=dmabuf demux.audio_0 ! queue ! avdec_aac ! pulsesink

The _io-mode_ parameters are causing that decoded video is not copied, so
the CPU usage is very little. It is also possible to play video without
_v4l2video15dec_ plugin. In this case video is decoded by software.
CPU usage is much higher, although still much less than when video is
decoded fully by software:

	gst-launch-1.0 filesrc location=$HOME/Videos/01_Blessed.mp4 ! qtdemux name=demux demux.video_0 ! queue ! avdec_h264 ! videoconvert ! v4l2sink device=/dev/video1 overlay-top=180 overlay-left=330 overlay-width=1280 overlay-height=720 demux.audio_0 ! queue ! avdec_aac ! pulsesink


### How to bould own installer from sources

The installation image may be built only on target Debian or Ubuntu system, i.e. on arm64 device running Debian for Debain installer, Ubuntu for Ubuntu one. To properly build the image, some base images must be collected in _base_ subdirectory, namely:

 * upstream debian-installer package source. It may be obtained by invoke:

	    apt-get source debian-installer

 * ap6212-firmware package files: _deb_ and _udeb_
 * bl1 boot image, _bl1-nanopi.bin_
 * u-boot binary image, _u-boot.bin_
 * Debian package with kernel - it may be taken from [NanoPi kernel release files](https://github.com/rafaello7/linux-nanopi-m3/releases) or built from the kernel sources as _bindeb-pkg_ target.
 * nanopi-bluetooth debian package

The directory contents may look like below:

	$ ll debian-installer-nanopi-m3/base
	total 7356
	-rw-r--r-- 1 rafal rafal  227396 Dec  6 23:16 ap6212-firmware_2_all.deb
	-rw-r--r-- 1 rafal rafal  226398 Dec  6 23:16 ap6212-firmware-di_2_all.udeb
	-rwxr-xr-x 1 rafal rafal   28784 Dec  6 23:16 bl1-nanopi.bin
	drwxrwxr-x 5 rafal rafal    4096 Oct 12 21:45 debian-installer-20101020ubuntu523
	-rw-r--r-- 1 rafal rafal 6632158 Dec  6 23:16 linux-image-4.14.4+_4.14.4+-1_arm64.deb
	-rw-r--r-- 1 rafal rafal   33858 Dec  6 23:16 nanopi-bluetooth_3_arm64.deb
	-rwxr-xr-x 1 rafal rafal  361744 Dec  6 23:16 u-boot.bin


It is also necessary to install tools needed to build the installer:

	sudo apt-get build-dep debian-installer

Finally, run _make_ in main directory.

