#!/bin/sh

set -e

if [ "$1" = 'all' ]; then
	fbuild.sh ${APP_NAME};
	fbuild.sh ${APP_NAME} "--release";
	exit 0;
fi;

if [ "$1" = 'dev' ]; then
	fbuild.sh ${APP_NAME};
	fbuild.sh ${APP_NAME} "" "2";
	exit 0;
fi;

if [ "$1" = 'release' ]; then
	fbuild.sh ${APP_NAME} "--release";
	exit 0;
fi;

echo "Use 'all' para compilar debug e release.";
echo "Use 'dev' para compilar debug.";
echo "Use 'release' para compilar para produção (release).";

exec "$@"