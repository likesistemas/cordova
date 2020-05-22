FROM likesistemas/cordova:stable

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    vim

ENV TZ="America/Fortaleza"
ENV ROOT="/root/"
ENV APP_NAME="app"
ENV ROOT_APP_NAME="${ROOT}${APP_NAME}/"

VOLUME ${ROOT}www/
VOLUME ${ROOT}apk/

WORKDIR ${ROOT}

RUN cordova telemetry on \
	&& cordova create ${APP_NAME}

WORKDIR ${ROOT_APP_NAME}

RUN cordova platform add android \
 && cordova plugin add cordova-plugin-geolocation \
 && cordova plugin add cordova-plugin-whitelist \
 && cordova plugin add cordova-android-support-gradle-release

RUN cordova build android

RUN rm -rf www/

WORKDIR ${ROOT}

COPY sh/nodejs/package.* nodejs/
RUN cd nodejs/ && npm install && cd ..

COPY sh/ /usr/local/bin/
COPY sh/nodejs/*.js nodejs/

RUN chmod +x /usr/local/bin/prepare.sh \
 && chmod +x /usr/local/bin/build.sh \
 && chmod +x /usr/local/bin/fbuild.sh \
 && chmod +x /usr/local/bin/entrypoint.sh \
 && chmod +x /usr/local/bin/change-version.sh

RUN rm -rf /var/lib/apt/lists/*

WORKDIR ${ROOT_APP_NAME}

ENTRYPOINT [ "entrypoint.sh" ]