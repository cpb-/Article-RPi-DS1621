#! /usr/bin/python
#-------------------------------------------------------------------------
# lecture-temperature.py
# (c) 2014 Christophe BLAESS - www.blaess.fr/christophe
# Licensed under GPLv2.
#
# Exemples de mon article "Communications en i2c entre un Raspberry Pi et
# un capteur de temperature DS1621"
# Gnu/Linux Magazine France hors serie special "Raspberry Pi avance".
# ------------------------------------------------------------------------

import smbus

bus = smbus.SMBus(1)
addr= 0x4F

START_CONVERT=0xEE
ACCESS_CONFIG=0xAC
READ_TEMPERATURE=0xAA

bus.write_byte_data(addr, ACCESS_CONFIG, bus.read_byte_data(addr, ACCESS_CONFIG)| 0x01)


# Demarrer l'acquisition
bus.write_byte(addr, START_CONVERT)
while (bus.read_byte_data(addr, ACCESS_CONFIG) & 0x80) == 0:
    pass

v=bus.read_byte_data(addr, READ_TEMPERATURE)
if v > 127:
    v -= 256
print v

