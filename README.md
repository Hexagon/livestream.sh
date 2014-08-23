livestream.sh
=============

Bash-helper for gstreamer live video streaming with minimal latency, currently only working with Raspberry PI Camera. Configuration, client and server is contained within a single file.

Streaming is done over multicast groups, so there is no need to worry about IP-addresses and stuff. It should just work.


Installation
=============

GStreamer is a prerequisite, and is installed on Raspberry PI (raspbian) with the following commands

Edit sources.list

```sudo nano /etc/apt/sources.list```

Add a line for a repository containg GStreamer 1.0, for example

```deb http://vontaene.de/raspbian-updates/ . main```

Update package database

```sudo apt-get update```

Install the package

```sudo apt-get install gstreamer1.0```

To use the built-in client, you need gstreamer 1.0 on the client machine as well. For instructions on that, refer to the user forums of your distributions (or google).

Download the file, one way is to use wget like below

```wget https://raw.githubusercontent.com/Hexagon/livestream.sh/master/livestream.sh```

Before launching, you have to allow livestream.sh to execute, using

```chmod +x livestream.sh```


Usage
=============
as server:

```   ./livestream.sh [start|stop|help] <interface>```

as client:

```   ./livestream.sh client```
