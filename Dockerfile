FROM likesistemas/cordova:stable

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    vim

ENV TZ="America/Fortaleza"

WORKDIR /

RUN cordova telemetry on \
	&& cordova create app

WORKDIR /app/

RUN cordova platform add android \
 && cordova plugin add cordova-plugin-geolocation \
 && cordova plugin add cordova-plugin-whitelist \
 && cordova plugin add cordova-android-support-gradle-release

RUN cordova build android