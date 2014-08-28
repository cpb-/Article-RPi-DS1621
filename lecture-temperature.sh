#! /bin/sh
#-------------------------------------------------------------------------
# lecture-temperature.sh
# (c) 2014 Christophe BLAESS - www.blaess.fr/christophe
# Licensed under GPLv2.
#
# Exemples de mon article "Communications en i2c entre un Raspberry Pi et
# un capteur de temperature DS1621"
# Gnu/Linux Magazine France hors serie special "Raspberry Pi avance".
# ------------------------------------------------------------------------

# Adresse du DS 1621.
I2C_BUS=1
I2C_ADDR=0x4F

# Commandes.
START_CONVERT=0xEE
ACCESS_CONFIG=0xAC
READ_TEMPERATURE=0xAA

# Lire la configuration.
status=$(i2cget -y ${I2C_BUS} ${I2C_ADDR} ${ACCESS_CONFIG})
	if [ $? -ne 0 ]; then exit 1; fi

# Ajouter le bit "One shot".
status=$((status | 0x01))

# Ecrire la configuration.
i2cset -y ${I2C_BUS} ${I2C_ADDR} ${ACCESS_CONFIG} $status
	if [ $? -ne 0 ]; then exit 1; fi

# Demarrer l'acquisition
i2cset -y ${I2C_BUS} ${I2C_ADDR} ${START_CONVERT}
	if [ $? -ne 0 ]; then exit 1; fi

while true
do
	# Lire l'etat.
	status=$(i2cget -y ${I2C_BUS} ${I2C_ADDR} ${ACCESS_CONFIG})
		if [ $? -ne 0 ]; then exit 1; fi

	# Si l'acquision est terminee, sortir de la boucle.
	if [ $(( $status & 0x80 )) -eq $((0x80)) ]; then break; fi
done

# Lire la temperature.
temp=$(i2cget -y ${I2C_BUS} ${I2C_ADDR} ${READ_TEMPERATURE}) 
	if [ $? -ne 0 ]; then exit 1; fi

# Gerer les valeurs negativeS
if [ $(($temp)) -gt 127 ]; then temp=$((temp - 256)); fi

# L'ecrire sur la sortie standard.
echo $(($temp))

