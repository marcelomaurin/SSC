#!/bin/bash
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
	echo "AMD64 Script"
	echo "Preparando binarios"
	cp ./src/MNote2 ./ssc2/usr/bin/ssc2
	chmod 777 ./ssc2/usr/bin/ssc2
	cp ./src/ssc2.png ./ssc2/usr/share/icons/hicolor/ssc2.png
	cp ./ssc2.desktop_arm ./ssc2/usr/share/applications/ssc2.desktop
	#ln -s /usr/bin/ssc2 ./ssc2/usr/share/applications/ssc2
	echo "Empacotando"
	dpkg-deb --build ssc2
	echo "Movendo para pasta repositorio"
	mv ssc2.deb ssc2-2.9_amd64.deb
	cp ./ssc2-2.9_amd64.deb ./bin/
	exit 1;
fi

if [ $ARQUITETURA = 'i686' ];
then
	echo "i686 Script"
	echo "Preparando binarios"
	cp ./src/ssc2 ./ssc2/usr/bin/ssc2
	chmod 777 ./ssc2/usr/bin/ssc2
	cp ./src/ssc2.png ./ssc2/usr/share/icons/hicolor/ssc2.png
	cp ./ssc2.desktop_arm ./ssc2/usr/share/applications/ssc2.desktop
	#ln -s /usr/bin/ssc2 ./ssc2/usr/share/applications/ssc2
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
	cp ./src/ssc2 ./ssc2/usr/bin/ssc2
	chmod 777 ./ssc2/usr/bin/ssc2
	cp ./src/ssc2.png ./ssc2/usr/share/icons/hicolor/ssc2.png
	cp ./ssc2.desktop_arm ./ssc2/usr/share/applications/ssc2.desktop
	#ln -s /usr/bin/ssc2 ./ssc2/usr/share/applications/ssc2
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
	cp ./src/ssc2 ./ssc2/usr/bin/ssc2
	chmod 777 ./ssc2/usr/bin/ssc2
	#ln -s /usr/bin/ssc2 ./ssc2/usr/bin/ssc2
	cp ./src/ssc2.png ./ssc2/usr/share/icons/hicolor/ssc2.png
	cp ./ssc2.desktop_arm ./ssc2/usr/share/applications/ssc2.desktop
	echo "Empacotando"
	dpkg-deb --build ssc2
	echo "Movendo para pasta repositorio"
	mv ssc2.deb ssc2-2.9_arm.deb
	cp ./ssc2-2.9_arm.deb ./bin/	
	exit 1;
fi
