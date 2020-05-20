#!/bin/sh

cd ${1}

WWW="./www/";
WWW_VAZIA=false;

if [ ! -d "${WWW}" ]; then
	mkdir -p ${WWW};
	WWW_VAZIA=true;
fi;

cordova prepare
cordova build android
cordova build android --release

if [ ${WWW_VAZIA} = true ]; then
	rm -Rfv ${WWW}
fi;

cd ..