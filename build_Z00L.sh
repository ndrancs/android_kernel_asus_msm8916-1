#
# Copyright � 2016,  Sultan Qasim Khan <sultanqasim@gmail.com> 	
# Copyright � 2016,  Zeeshan Hussain <zeeshanhussain12@gmail.com> 	      
# Copyright � 2016,  Varun Chitre  <varun.chitre15@gmail.com>	
# Copyright � 2016,  Aman Kumar  <firelord.xda@gmail.com>

# Custom build script
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# Please maintain this if you use this script or any part of it
#

#!/bin/bash
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'
export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE=/home/Impulse/kernel/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export KBUILD_BUILD_USER="Impulse"
export KBUILD_BUILD_HOST="TheImpulson"
echo -e "$cyan***********************************************"
echo "          Compiling FireKernel kernel          "
echo -e "***********************************************$nocol"
rm -f arch/arm64/boot/dts/qcom/*.dtb
rm -f arch/arm64/boot/dt.img
rm -f flash_zip/boot.img
echo -e " Initializing defconfig"
make Z00L_defconfig
echo -e " Building kernel"
make -j8
make -j8 dtbs

/home/Impulse/kernel/msm8916/tools/dtbToolCM -2 -o /home/Impulse/kernel/msm8916/arch/arm64/boot/dt.img -s 2048 -p /home/Impulse/kernel/msm8916/scripts/dtc/ /home/Impulse/kernel/msm8916/arch/arm64/boot/dts/

echo -e " Converting the output into a flashable zip"
mkdir -p flash_zip/system/lib/modules/
cp arch/arm64/boot/Image flash_zip/tools/
cp arch/arm64/boot/dt.img flash_zip/tools/
rm -f /home/Impulse/kernel/fire_kernel.zip
cd flash_zip
zip -r ../arch/arm64/boot/fire_kernel.zip ./
mv /home/Impulse/kernel/msm8916/arch/arm64/boot/fire_kernel.zip /home/Impulse/kernel/fire_kernel.zip
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
