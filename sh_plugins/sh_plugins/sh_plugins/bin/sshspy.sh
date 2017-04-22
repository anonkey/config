#!/bin/sh
while [ : ] ;
do
	clear
	ps aux | grep "ssh" | grep -v "grep ssh" | grep -v "sshspy.sh"
	usleep 100000
done