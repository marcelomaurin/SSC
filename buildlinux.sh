#!/bin/bash

VERSAO="2.4.1"

ARQUITETURA=$(uname -m)
case $(uname -m) in
	i386) 	ARQUITETURA="i386";;
	i686) 	ARQUITETURA="i386";;
	x86_64)	ARQUITETURA="amd64";;
	arm) 	ARQUITETURA="arm";;
esac

echo $ARQUITETURA

if [ $ARQUITETURA = 'amd64' ]; 
then
	EXTENSION="_${ARQUITETURA}"
	echo "AMD64 Script"
	echo "Preparando binarios"
	cp ./src/ssc2 ./instalador/ssc2/usr/bin/ssc2
	chmod 777 ./instalador/ssc2/usr/bin/ssc2
	cp ./src/ssc2.png ./instalador/ssc2/usr/share/icons/hicolor/ssc2.png
	cp ./instalador/ssc2.desktop ./instalador/ssc2/usr/share/applications/ssc2.desktop
	#ln -s /usr/bin/ssc2 ./instalador/ssc2/usr/share/applications/ssc2
	echo "Empacotando"
	dpkg-deb --build ./instalador/ssc2
	echo "Copiando para pasta do repositorio"
	FILE="./ssc2_${VERSAO}${EXTENSION}.deb"
	cp ./instalador/ssc2.deb $FILE
	cp $FILE ./lin_bin/
	exit 1;
fi

if [ $ARQUITETURA = 'i686' ];
then
	echo "i686 Script"
	echo "Preparando binarios"
	cp ./src/ssc2 ./instalador/ssc2/usr/bin/ssc2
	chmod 777 ./instalador/ssc2/usr/bin/ssc2
	cp ./src/ssc2.png ./instalador/ssc2/usr/share/icons/hicolor/ssc2.png
	cp ./ssc2.desktop_arm ./instalador/ssc2/usr/share/applications/ssc2.desktop
	#ln -s /usr/bin/ssc2 ./instalador/ssc2/usr/share/applications/ssc2
	echo "Empacotando"
	dpkg-deb --build ssc2
	echo "Movendo para pasta repositorio"
	mv ssc2.deb ssc2-2.9_i686.deb
	cp ./ssc2-2.9_i686.deb ./bin/
	exit 1;
fi

if [ $ARQUITETURA = 'i386' ];
then
	echo "i386 Script"
	echo "Preparando binarios"
	cp ./src/ssc2 ./instalador/ssc2/usr/bin/ssc2
	chmod 777 ./instalador/ssc2/usr/bin/ssc2
	cp ./src/ssc2.png ./instalador/ssc2/usr/share/icons/hicolor/ssc2.png
	cp ./ssc2.desktop_arm ./instalador/ssc2/usr/share/applications/ssc2.desktop
	#ln -s /usr/bin/ssc2 ./instalador/ssc2/usr/share/applications/ssc2
	echo "Empacotando"
	dpkg-deb --build ssc2
	echo "Movendo para pasta repositorio"
	mv ssc2.deb ssc2-2.9_i386.deb
	cp ./ssc2-2.9_i386.deb ./bin/
	exit 1;
fi

if [ $ARQUITETURA =  'armv7l' ]; then
	echo "ARM Script"
	echo "Preparando binarios"
	cp ./src/ssc2 ./instalador/ssc2/usr/bin/ssc2
	chmod 777 ./instalador/ssc2/usr/bin/ssc2
	#ln -s /usr/bin/ssc2 ./instalador/ssc2/usr/bin/ssc2
	cp ./src/ssc2.png ./instalador/ssc2/usr/share/icons/hicolor/ssc2.png
	cp ./ssc2.desktop_arm ./instalador/ssc2/usr/share/applications/ssc2.desktop
	echo "Empacotando"
	dpkg-deb --build ssc2
	echo "Movendo para pasta repositorio"
	mv ssc2.deb ssc2-2.9_arm.deb
	cp ./ssc2-2.9_arm.deb ./bin/	
	exit 1;
fi
