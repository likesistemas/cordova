#!/bin/sh

cd ${1}

ENV_PRD="./.env.prd";
ENV_APP=${2};
ID_APP=${3};
SRC_BUILD_FOLDER="${PWD}/${BUILD_FOLDER}/"

echo "Arquivo config: ${ENV_APP}"

echo "Compilando...";
if [ -f ${ENV_APP} ]; then
	cp ${ENV_APP} ${ENV_PRD};
else
	touch ${ENV_PRD};
fi

if [ -n "$URL_SITE" ]; then
	echo "Alterando URL...";
	echo "\nURL=${URL_SITE}" >> ${ENV_PRD};
fi;

if [ -n "$ID_APP" ]; then
	echo "Alterando ID do App..."
    echo "\nID_APP_PROPRIO=${ID_APP}" >> ${ENV_PRD};
fi;

echo "\n---"
cat ${ENV_PRD}
echo "\n---\n"

echo "Install..."
npm i

echo "Build..."

ls -la

if [ -d "${SRC_BUILD_FOLDER}" ]; then
	echo "Deleting destination folder..."
	rm -Rf ${SRC_BUILD_FOLDER}
fi;

npm run ${WEBPACK_BUILD_COMMAND}

if [ ! -d "${SRC_BUILD_FOLDER}" ]; then
	echo "Error compiling the project because the destination folder does not exist.\nCommand: ${WEBPACK_BUILD_COMMAND}.\nCurrent folder: ${PWD}.\nDestination Folder: '${PWD}/${BUILD_FOLDER}'.";
	exit 1;
fi;

rm ${ENV_PRD}