livestream.sh
=============

Bash-helper for gstreamer live video streaming with minimal latency, currently only working with Raspberry PI Camera. Configuration, client and server is contained withing a single file.


Installation
=============

GStreamer is a prerequisite, and is installed on Raspberry pi (raspbian) with the following commands

Edit sources.list

```sudo nano /etc/apt/sources.list```

Add a line for a repository containg GStreamer 1.0, for example

```deb http://vontaene.de/raspbian-updates/ . main```

Update package database

```sudo apt-get update```

Install the package

```sudo apt-get install gstreamer1.0```

To use the built-in client, you need gstreamer 1.0 there as well, refer to your own distributions user forums (or google).

Download the file, one way is to use wget like below

```wget http://raw.githubusercontent.com/Hexagon/livestream.sh/master/livestream.sh```

Before launching, you have to allow livestream.sh to execute, using

```chmod +x livestream.sh```



Configuration
=============

The configuration is self-contained withing the script, use your favorite text editor to customize.

```nano livestream.sh```

Please note that INTERFACE has to be set to the interface you'll be hosting the camera on. Usually eth0 for cable, or wlan0 for wireless.



Usage
=============
as server:

```   ./livestream.sh [start|stop|help]```

as client:

```   ./livestream.sh client hostip:hostport```
