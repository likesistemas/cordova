#!/bin/sh

cd ${1}

ENV_PRD="./.env.prd";
ENV_APP=${2};
ID_APP=${3};

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

echo "Build..."
ls -la
npm run ${WEBPACK_BUILD_COMMAND}

rm ${ENV_PRD}