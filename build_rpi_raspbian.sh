#!/bin/bash
# this script builds q3 with SDL
# invoke with ./build.sh
# or ./build.sh clean to clean before build

if dpkg --get-selections | grep libsdl1.2-dev; then
    echo "Found libsdl1.2-dev package installed...good"
else
    echo "Warning: you may need to do sudo apt-get install libsdl1.2-dev before building"
    read
fi

# directory containing the ARM shared libraries (rootfs, lib/ of SD card)
# specifically libEGL.so and libGLESv2.so
ARM_LIBS=/opt/vc/lib
SDL_LIB=lib

# directory containing baseq3/ containing .pk3 files - baseq3 on CD
BASEQ3_DIR="/home/${USER}/"

# directory to find khronos linux make files (with include/ containing
# headers! Make needs them.)
#INCLUDES="-I/opt/bcm-rootfs/opt/vc/include -I/opt/bcm-rootfs/opt/vc/include/interface/vcos/pthreads"

## rpi version
INCLUDES="-I/opt/vc/include -I/opt/vc/include/interface/vcos/pthreads"

# prefix of arm cross compiler installed
## commented out for rpi
#CROSS_COMPILE=bcm2708-

# clean
if [ $# -ge 1 ] && [ $1 = clean ]; then
   echo "clean build"
   rm -rf build/*
fi

# 2017-03-19 [tlutz] Removing -lvmcs_rpc_client from link line for Raspberry Pi 3 Model B (untested with other models)

# sdl not disabled
make -j4 -f Makefile COPYDIR="$BASEQ3_DIR" ARCH=arm \
	CC=""$CROSS_COMPILE"gcc" USE_SVN=0 USE_CURL=0 USE_OPENAL=0 \
	CFLAGS="-DVCMODS_MISC -DVCMODS_OPENGLES -DVCMODS_DEPTH -DVCMODS_REPLACETRIG $INCLUDES" \
	LDFLAGS="-L"$ARM_LIBS" -L$SDL_LIB -lSDL -lvchostif -lvcfiled_check -lbcm_host -lkhrn_static -lvchiq_arm -lopenmaxil -lEGL -lGLESv2 -lvcos -lrt"

# copy the required pak3 files over
# cp "$BASEQ3_DIR"/baseq3/*.pk3 "build/release-linux-arm/baseq3/"
# cp -a lib build/release-linux-arm/baseq3/
exit 0

