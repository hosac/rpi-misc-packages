#!/bin/bash -e
#
# https://github.com/hosac | hosac@gmx.net
#

# ### MJPG-Streamer
# Source: # https://github.com/jacksonliam/mjpg-streamer
#
# Notes:
# 1. A camera must be connected and enabled, e.g. Raspberry Pi Camera!

if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

echo "Installing MJPG-Streamer"

# Install dependencies
sudo apt-get -y install cmake libjpeg8-dev gcc g++

# Clone and build
git clone https://github.com/jacksonliam/mjpg-streamer.git
cd mjpg-streamer/mjpg-streamer-experimental
make
sudo make install


# Create init file
cat <<'EOF' > /etc/init.d/mjpg-streamer
#!/bin/sh
# /etc/init.d/mjpg_streamer.sh
### BEGIN INIT INFO
# Provides:          mjpg_streamer.sh
# Required-Start:    $network
# Required-Stop:     $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: mjpg_streamer for webcam
### END INIT INFO

# Notes:
# Example for uvc plugin
#	/usr/local/bin/mjpg_streamer -i "input_uvc.so -r 1280x720 -d /dev/video0 -f 10 -rot 180" -o "output_http.so -p 8080 -w /usr/local/share/mjpg-streamer/www"

# Example for raspicam plugin
#	/usr/local/bin/mjpg_streamer -i "input_raspicam.so -x 1280 -y 720 -fps 10" -o "output_http.so -p 8080 -w /usr/local/share/mjpg-streamer/www"


# Plugin options
UVC="input_uvc.so -r 1280x720 -d /dev/video0 -f 10 -rot 180"
RASPICAM="input_raspicam.so -x 1280 -y 720 -fps 10"

# Definitions
OUTPUT_PLUGIN="output_http.so";
PORT="8080";
WEB_DIR="/usr/local/share/mjpg-streamer/www";
CREDENTIALS="stream:PassworD";


# Active Plugin
INPUT_PLUGIN=$RASPICAM


# Message
infomessage(){
	echo "[+] $1"
}


# Streamer function
start_streamer(){
	/usr/local/bin/mjpg_streamer -b -i "${INPUT_PLUGIN}" -o "${OUTPUT_PLUGIN} -p ${PORT} -w ${WEB_DIR} -c ${CREDENTIALS}"
	sleep 2
}


# Carry out specific functions when asked to by the system
case "$1" in
	start)
		infomessage "Starting mjpg_streamer"
		start_streamer
		infomessage "mjpg_streamer started"
		;;
	stop)
		infomessage "Stopping mjpg_streamer…"
		killall mjpg_streamer
		infomessage "mjpg_streamer stopped"
		;;
	restart)
		infomessage "Restarting daemon: mjpg_streamer"
		killall mjpg_streamer
		start_streamer
		infomessage "Restarted daemon: mjpg_streamer"
		;;
	status)
		pid=`ps -A | grep mjpg_streamer | grep -v "grep" | grep -v mjpg_streamer. | awk ‘{print $1}’ | head -n 1`
		if [ -n "$pid" ];
		then
			infomessage "mjpg_streamer is running with pid ${pid}"
			infomessage "mjpg_streamer was started with the following command line"
			cat /proc/${pid}/cmdline ; echo ""
		else
			infomessage "Could not find mjpg_streamer running"
		fi
		;;
	*)
		infomessage "Usage: $0 {start|stop|status|restart}"
		exit 1
		;;
esac
exit 0

EOF

# Change rights of init file
sudo chmod 755 /etc/init.d/mjpg-streamer 

# Enable and start service
sudo update-rc.d mjpg-streamer defaults
sudo systemctl enable mjpg-streamer
sudo systemctl start mjpg-streamer