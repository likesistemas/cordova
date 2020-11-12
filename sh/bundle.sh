#!/bin/sh

APK_NAME=${1}
APK_FOLDER=${2}
AAB_DEBUG="./platforms/android/app/build/outputs/bundle/debug/";
AAB_RELEASE="./platforms/android/app/build/outputs/bundle/release/";

if [ -d "${AAB_DEBUG}" ]; then
	rm -Rfv ${AAB_DEBUG};
fi;

if [ -d "${AAB_RELEASE}" ]; then
	rm -Rfv ${AAB_RELEASE};
fi;

cd platforms/android
./gradlew bundle
cd ..
cd ..

if [ -d "${AAB_DEBUG}" ]; then
    echo "Copiando AAB Debug...";
    SRC_AAB_DEBUG=$(find ${AAB_DEBUG} -regex ".*\.\(aab\)")
    mv ${SRC_AAB_DEBUG} ${APK_FOLDER}${APK_NAME}-debug.aab
fi;

if [ -d "${AAB_RELEASE}" ]; then
    echo "Copiando AAB Release...";
    SRC_AAB_RELEASE=$(find ${AAB_RELEASE} -regex ".*\.\(aab\)")
    mv ${SRC_AAB_RELEASE} ${APK_FOLDER}${APK_NAME}-release.aab
fi;