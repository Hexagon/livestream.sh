#!/bin/bash


# - LICENSE -------------------------------------------
# Copyright (c) 2014 Hexagon <Hexagon@GitHub>
# This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
# Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
#   1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
#   2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
#   3. This notice may not be removed or altered from any source distribution.


# - CONFIGURATION -------------------------------------
MULTICAST_GROUP=224.1.1.1
PORT=5000
USE_RPICAMSRC=false	# This is a gstreamer plugin available at https://github.com/thaytan/gst-rpicamsrc
INTERFACE="eth0"
RESX=640
RESY=480
BITRATE=1000000
LOGFILE="/tmp/livestream.log"
PIDFILE="/tmp/livestream.pid"


# - NON-INTERESTING STUFF -----------------------------
echo "livestream.sh, Hexagon <hexagon@GitHub> 2014"
echo ""

# Read pid (if exist)
PID=$(cat $PIDFILE)
if [ "$1" = "start" ]
then
	# Check status of running process
	if ps -p $PID > /dev/null
	then
		echo "Status: already running with pid $PID, refusing to spawning another process."
		exit 1

	else
		# 
		if [ -n "$2" ]
		then
			INTERFACE="$2"
		fi
		# Everything is good, spawn new process
		echo "Launching gstreamer multicast on $INTERFACE"
		echo ""
		echo "Redirecting output to: 	$LOGFILE"
		echo "Pidfile:		$PIDFILE"
		if $USE_RPICAMSRC;
		then
			nohup </dev/null gst-launch-1.0 rpicamsrc bitrate=$BITRATE ! video/x-h264,width=$RESX,height=$RESY,framerate=25/1 !  h264parse ! rtph264pay config-interval=1 pt=96 ! udpsink host=$MULTICAST_GROUP auto-multicast=true multicast-iface=$INTERFACE port=$PORT >$LOGFILE 2>&1 &
		else
			nohup </dev/null raspivid -t 0 -h $RESY -w $RESX -fps 25 -hf -b $BITRATE -o 2>/dev/null - | gst-launch-1.0 -v fdsrc ! h264parse ! rtph264pay config-interval=1 pt=96 ! udpsink host=$MULTICAST_GROUP auto-multicast=true multicast-iface=$INTERFACE port=$PORT >$LOGFILE 2>&1 &
		fi
		PID=$!
		echo $PID > $PIDFILE
		echo ""
		echo "Process ($PID) spawned in background, it's safe to close this session..."
		exit 0

	fi
elif [ "$1" = "stop" ]
then
	# Check status of running process
	if ps -p $PID > /dev/null
	then
		echo "Stopping livestream.sh..."
		while true
		do
			if ps -p $PID > /dev/null
			then
				kill $PID
				wait $PID > /dev/null 2>&1
				sleep 1
			else
				exit 0
			fi
		done
		exit 0
	else
		echo "Status: livestream.sh does not seem to be running, you might want to start it first."
		exit 1

	fi
elif [ "$1" = "client" ]
then
	echo "Starting client"
	echo ""
	gst-launch-1.0 udpsrc multicast-group=$MULTICAST_GROUP port=$PORT caps="application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264, payload=(int)96" ! rtph264depay !  decodebin ! autovideosink
else
	echo "Bash-helper for gstreamer 1.0 live video streaming"
	echo ""
        echo "Usage as server:"
        echo "  ./livestream.sh [start|stop|help] <interface>"
        echo ""
        echo "Usage as client:"
        echo "  ./livestream.sh client"
        echo ""
	echo "To report a bug, request a feature etc., visit <http://github.com/Hexagon/livestream.sh>"
fi

# Assume success
exit 0
