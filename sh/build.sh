#!/bin/sh

WWW_ORIGINAL="../www/";
WWW="./www/";
APK_DEBUG="./platforms/android/app/build/outputs/apk/debug/app-debug.apk";
APK_RELEASE="./platforms/android/app/build/outputs/apk/release/app-release.apk";
AAB_DEBUG="./platforms/android/app/build/outputs/bundle/debug/app.aab";
AAB_RELEASE="./platforms/android/app/build/outputs/bundle/release/app.aab";

if [ -n "${1}" ]; then
	APP_NAME=${1};
fi;

if [ -n "${3}" ]; then
	ID_APP=${3};
fi;

APK_NAME=${APP_NAME}

echo "Iniciando build '${APP_NAME}'...";

if [ ! -d "${WWW_ORIGINAL}" ]; then
	echo "Pasta www não existe.";
	exit 1;
fi;

echo "Copiando pasta www...";
cp -r ${WWW_ORIGINAL} .
ls -la ${WWW}

echo "Copiando config.js...";
cp config.js ${WWW}

if [ -n "$URL_SITE" ]; then
	echo "Alterando URL...";
	sed -i "/^var urlQsp = '/s/=.*/='${URL_SITE}';/" ${WWW}/config.js;
fi;

if [ -n "$ID_APP" ]; then
	echo "Alterando ID do App..."
   	sed -i "/^var qspClienteProprio = /s/=.*/= {id: ${ID_APP}};/" ${WWW}/config.js;
   	APK_NAME="${APP_NAME}-proprio-${ID_APP}";
fi;

cat ${WWW}/config.js;

echo "Alterando Versão...";
change-version.sh ${VERSAO_APP};

if [ -f "${APK_DEBUG}" ]; then
	rm -v ${APK_DEBUG};
fi;

if [ -f "${APK_RELEASE}" ]; then
	rm -v ${APK_RELEASE};
fi;

if [ -f "${AAB_DEBUG}" ]; then
	rm -v ${AAB_DEBUG};
fi;

if [ -f "${AAB_RELEASE}" ]; then
	rm -v ${AAB_RELEASE};
fi;

cordova build android ${2}

if [ -f "${APK_DEBUG}" ]; then
	echo "Copiando APK Debug...";
	mv ${APK_DEBUG} ../apk/${APK_NAME}-debug.apk;
fi;

if [ -f "${APK_RELEASE}" ]; then
	echo "Copiando APK Release...";
	mv ${APK_RELEASE} ../apk/${APK_NAME}-release.apk;
fi;

if [ "${2}" = "--release" ]; then
	cd platforms/android
	./gradlew bundle
	cd ..
	cd ..

	if [ -f "${AAB_DEBUG}" ]; then
		echo "Copiando AAB Debug...";
		mv ${AAB_DEBUG} ../apk/${APK_NAME}-debug.aab
	fi;

	if [ -f "${AAB_RELEASE}" ]; then
		echo "Copiando AAB Release...";
		mv ${AAB_RELEASE} ../apk/${APK_NAME}-release.aab
	fi;	
fi;