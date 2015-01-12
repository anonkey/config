#!/bin/sh
while [ : ] ;
do
	lsof -i
	usleep 10000000
	clear
done
