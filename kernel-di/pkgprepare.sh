#!/bin/sh
kernelver=$(cd ../base; echo linux-image-*.deb | sed -e 's/linux-image-\([0-9]\.[0-9]\+\.[0-9]\++\?\)_.*\.deb/\1/')

echo "$kernelver"
echo "boot" >debian/kernel-image-$kernelver-di.install
cat >debian/nic-modules-$kernelver-di.install <<End
lib/modules/$kernelver/kernel/net
lib/modules/$kernelver/kernel/drivers/net
End

sed -e "s/KVER/$kernelver/g" <debian/control.in >debian/control
