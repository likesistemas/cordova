#!/bin/sh
FOLDER_APP=${PWD}
cd ..
node ${ROOT}nodejs/change-version.js "${PWD}/www/" "${FOLDER_APP}/";