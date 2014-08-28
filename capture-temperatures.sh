#! /bin/sh
#-------------------------------------------------------------------------
# capture-temperatures.c
# (c) 2014 Christophe BLAESS - www.blaess.fr/christophe
# Licensed under GPLv2.
#
# Exemples de mon article "Communications en i2c entre un Raspberry Pi et
# un capteur de temperature DS1621"
# Gnu/Linux Magazine France hors serie special "Raspberry Pi avance".
# ------------------------------------------------------------------------

PROG=./lecture-temperature.py

uptime
d0=$(date +%s)

while true
do
	d=$(date +%s)
	printf "%d\t" $((d-d0))	
	${PROG}
	sleep 1
done

