#!/bin/bash

VERSAO="2.4.2"

ARQUITETURA=$(uname -m)
case $(uname -m) in
	i386) 	ARQUITETURA="i386";;
	i686) 	ARQUITETURA="i386";;
	x86_64)	ARQUITETURA="amd64";;
	arm) 	ARQUITETURA="arm";;
	armv7l) ARQUITETURA="arm";;
esac

echo $ARQUITETURA

if [ $ARQUITETURA = 'amd64' ]; 
then
	EXTENSION="_${ARQUITETURA}"
	echo "AMD64 Script"
	echo "Preparando binarios"
	chmod 777 ./src/ssc
	cp  ./src/ssc ./instalador/ssc2/usr/bin/ssc2
	chmod 777 ./instalador/ssc2/usr/bin/ssc2
	cp ./src/ssc2.png ./instalador/ssc2/usr/share/icons/hicolor/ssc2.png
	cp ./instalador/ssc2.desktop ./instalador/ssc2/usr/share/applications/ssc2.desktop
	ln -sf /usr/bin/ssc2 ./instalador/ssc2/usr/share/applications/ssc2
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
	EXTENSION="_${ARQUITETURA}"
	echo "AMD64 Script"
	echo "Preparando binarios"
	chmod 777 ./src/ssc
	cp  ./src/ssc ./instalador/ssc2/usr/bin/ssc2
	chmod 777 ./instalador/ssc2/usr/bin/ssc2
	cp ./src/ssc2.png ./instalador/ssc2/usr/share/icons/hicolor/ssc2.png
	cp ./instalador/ssc2.desktop ./instalador/ssc2/usr/share/applications/ssc2.desktop
	ln -sf /usr/bin/ssc2 ./instalador/ssc2/usr/share/applications/ssc2
	echo "Empacotando"
	dpkg-deb --build ./instalador/ssc2
	echo "Copiando para pasta do repositorio"
	FILE="./ssc2_${VERSAO}${EXTENSION}.deb"
	cp ./instalador/ssc2.deb $FILE
	cp $FILE ./lin_bin/
	exit 1;
fi

if [ $ARQUITETURA = 'i386' ];
then
	EXTENSION="_${ARQUITETURA}"
	echo "AMD64 Script"
	echo "Preparando binarios"
	chmod 777 ./src/ssc
	cp  ./src/ssc ./instalador/ssc2/usr/bin/ssc2
	chmod 777 ./instalador/ssc2/usr/bin/ssc2
	cp ./src/ssc2.png ./instalador/ssc2/usr/share/icons/hicolor/ssc2.png
	cp ./instalador/ssc2.desktop ./instalador/ssc2/usr/share/applications/ssc2.desktop
	ln -sf /usr/bin/ssc2 ./instalador/ssc2/usr/share/applications/ssc2
	echo "Empacotando"
	dpkg-deb --build ./instalador/ssc2
	echo "Copiando para pasta do repositorio"
	FILE="./ssc2_${VERSAO}${EXTENSION}.deb"
	cp ./instalador/ssc2.deb $FILE
	cp $FILE ./lin_bin/
	exit 1;
fi

if [ $ARQUITETURA =  'arm' ]; then
	EXTENSION="_${ARQUITETURA}"
	echo "AMD64 Script"
	echo "Preparando binarios"
	chmod 777 ./src/ssc
	cp  ./src/ssc ./instalador/ssc2/usr/bin/ssc2
	chmod 777 ./instalador/ssc2/usr/bin/ssc2
	cp ./src/ssc2.png ./instalador/ssc2/usr/share/icons/hicolor/ssc2.png
	cp ./instalador/ssc2.desktop ./instalador/ssc2/usr/share/applications/ssc2.desktop
	ln -sf /usr/bin/ssc2 ./instalador/ssc2/usr/share/applications/ssc2
	echo "Empacotando"
	dpkg-deb --build ./instalador/ssc2
	echo "Copiando para pasta do repositorio"
	FILE="./ssc2_${VERSAO}${EXTENSION}.deb"
	cp ./instalador/ssc2.deb $FILE
	cp $FILE ./lin_bin/
	exit 1;
fi
