<h1>Raspberry Pi Miscellaneous Packages</h1>

<h2>Features</h2>

A collection of different useful installation scripts.

<h2>Prerequisites</h2>

Make sure you have an updated system

	sudo apt-get update
	sudo apt-get upgrade -y

<h2>Installation</h2>

Each script has to be executed manually.

	wget -q https://github.com/hosac/rpi-misc-packages/archive/master.zip
	unzip master.zip
	rm master.zip
	cd rpi-misc-packages-master

	# execute the dedicated script, e.g.
	# sudo ./install-mjpg-streamer.sh

<h2>Packages</h2>

<h3>MJPG-Streamer</h3>

It can be used to stream JPEG files over an IP-based network from a webcam to various types of viewers. Raspberry Pi camera and USB-cameras with the UVC standard are supported.<br>
When using raspi-cam, the module must be activated first with raspi-config! In case of USB-cam the /etc/init.d/mjpg-streamer must be adapted.<br>
With the installed webserver it's easy to access the pictures or stream on:

	http://<hostname.local>:8080     or     http://<ip>:8080

Credentials are used for security reasons:

	username: stream
	password: PassworD

<h2>References</h2>

- [MJPG-Streamer - Stream your video from a webcam](https://github.com/jacksonliam/mjpg-streamer)