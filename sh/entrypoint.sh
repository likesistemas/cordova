#!/bin/sh

set -e

if [ "$1" = 'all' ]; then
	./cordova-build.sh app;
	./cordova-build.sh app "--release";
	exit 0;
fi;

if [ "$1" = 'dev' ]; then
	./cordova-build.sh app;
	./cordova-build.sh app "" "" "2";
	exit 0;
fi;

if [ "$1" = 'release' ]; then
	./cordova-build.sh app "--release" "bundle";
	exit 0;
fi;

echo "Use 'all' para compilar debug e release.";
echo "Use 'dev' para compilar debug.";
echo "Use 'release' para compilar para produção (release).";

exec "$@"