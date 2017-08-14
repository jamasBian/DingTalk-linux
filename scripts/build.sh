#!/bin/bash

if ! hash electron-packager 2>/dev/null; then
  RED='\033[0;31m'
  NC='\033[0m'
  echo "${RED}Error${NC}: you need to npm install electron-packager. Aborting."
  exit 1
fi

if [ "$#" -ne 2 ]; then
  echo -e "Usage: ./script/build.sh <platform> <arch>"
  echo -e "	platform:	darwin, linux, win32"
  echo -e "	arch:		ia32, x64"
  exit 1
fi

PLATFORM=$1
ARCH=$2

echo "Start packaging for $PLATFORM $ARCH."

if [ $PLATFORM = "linux" ]; then
    APP_NAME="DingTalk-Electron"
else
    APP_NAME="DingTalk-Electron"
fi

if [ $PLATFORM = "darwin" ]; then
    ICON=icon.icns
else
    ICON=icon.png
fi

ignore_list="dist|scripts|\.idea|.*\.md|.*\.yml|node_modules/nodejieba"
cp assets/$ICON node_modules/electron/dist/resources/$ICON
electron-packager . "${APP_NAME}" --platform=$PLATFORM --arch=$ARCH --electronVersion=1.4.15 --app-version=0.0.5 --asar --icon=assets/$ICON --overwrite --out=./dist --ignore=${ignore_list}

if [ $? -eq 0 ]; then
  echo -e "$(tput setaf 2)Packaging for $PLATFORM $ARCH succeeded.$(tput sgr0)\n"
fi

if [ $PLATFORM = "darwin" ]; then
    ditto -rsrcFork ./dist/${APP_NAME}-darwin-x64/${APP_NAME}.app /Applications/${APP_NAME}.app
    echo "$(tput setaf 3)App copied to /Applications. You can open ${APP_NAME} there or from Spotlight.$(tput sgr0)"
fi
