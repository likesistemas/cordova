#!/bin/sh

WWW_ORIGINAL="../www/";
WWW="./www/";
APK_DEBUG="./platforms/android/app/build/outputs/apk/debug/";
APK_RELEASE="./platforms/android/app/build/outputs/apk/release/";
APK_FOLDER="${ROOT}apk/";

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

compile-webpack.sh ${WWW_ORIGINAL} "${PWD}/.env-app" ${ID_APP}

if [ ! -d "${WWW_ORIGINAL}public/" ]; then
	echo "Ocorreu algum problema ao compilar o projeto.";
	exit 1;
fi;

echo "Copiando pasta www...";
cp -r "${WWW_ORIGINAL}public/" ${WWW}
ls -la ${WWW}

if [ -n "$ID_APP" ]; then
   	APK_NAME="${APP_NAME}-proprio-${ID_APP}";
fi;

echo "Alterando Versão...";
change-version.sh

if [ -d "${APK_DEBUG}" ]; then
	rm -Rfv ${APK_DEBUG};
fi;

if [ -d "${APK_RELEASE}" ]; then
	rm -Rfv ${APK_RELEASE};
fi;

cordova build android ${2}

if [ -d "${APK_DEBUG}" ]; then
	echo "Copiando APK Debug...";
	SRC_APK_DEBUG=$(find ${APK_DEBUG} -regex ".*\.\(apk\)")
	mv ${SRC_APK_DEBUG} ${APK_FOLDER}${APK_NAME}-debug.apk;
fi;

if [ -d "${APK_RELEASE}" ]; then
	echo "Copiando APK Release...";
	SRC_APK_RELEASE=$(find ${APK_RELEASE} -regex ".*\.\(apk\)")
	mv ${SRC_APK_RELEASE} ${APK_FOLDER}${APK_NAME}-release.apk;
fi;

if [ "${2}" = "--release" ]; then
	bundle.sh ${APK_NAME} ${APK_FOLDER}
fi;