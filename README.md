livestream.sh
=============

Bash-helper for gstreamer live video streaming, currently only working with Raspberry PI Camera.


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


Usage
=============
as server:
  ./livestream.sh [start|stop|help]

as client:
  ./livestream.sh client hostip:hostport
