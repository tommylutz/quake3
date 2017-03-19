#!/bin/bash
SCRIPTDIR=$(cd $(dirname $(command -v $0)) && pwd)

SERVER_BIN=$SCRIPTDIR/build/release-linux-arm/ioq3ded.arm

if [[ ! -x $SERVER_BIN ]]; then
    echo "$SERVER_BIN file doesn't exist / isn't executable. Did you run ./build_rpi_raspbian.sh ?"
    exit 1
fi

if [[ ! -e $SCRIPTDIR/build/release-linux-arm/baseq3/pak0.pk3 ]]; then
    echo "ERROR: You need to find the pak0.pk3, pak1.pk3 files, etc and place them in $SCRIPTDIR/build/release-linux-arm/baseq3/"
    echo "You can find these in your official Quake3 installation, or Google it."
    exit 1
fi

if [[ ! -e $SCRIPTDIR/build/release-linux-arm/baseq3/server.cfg ]]; then
    echo "Symlinking $SCRIPTDIR/server-config-files/*.cfg to $SCRIPTDIR/build/release/linux-arm/baseq3"
    ln -s $SCRIPTDIR/server-config-files/*.cfg $SCRIPTDIR/build/release-linux-arm/baseq3
fi

if [[ -z "$1" ]]; then
    SERVERCONF=server.cfg
else
    SERVERCONF=$(basename $1)
fi

echo "NOTE: To start the server persistently on boot, add the following line to /etc/rc.local:"
echo "\""su - pi -c "cd $SCRIPTDIR && nohup $SCRIPTDIR/start_server.sh &\""
echo "Starting dedicated (local) quake3 server with config $SERVERCONF..."
sleep 1
$SCRIPTDIR/build/release-linux-arm/ioq3ded.arm +set dedicated 1 +exec $SERVERCONF

