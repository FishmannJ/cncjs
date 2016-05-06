#!/bin/bash

PLATFORM=${PLATFORM:-all}
ARCH=${ARCH:-all}
ELECTRON_VERSION=$(./node_modules/.bin/electron --version)

pushd dist/cnc
echo "Cleaning up dist/cnc/node_modules..."
rm -rf node_modules
echo "Installing packages..."
npm install --production
npm dedupe
popd

# https://github.com/electron/electron-rebuild/issues/59
rm -f dist/cnc/node_modules/serialport/build/Release/serialport.node

echo "Rebuilding native modules..."
./node_modules/.bin/electron-rebuild \
    --version=${ELECTRON_VERSION:1} \
    --pre-gyp-fix \
    --module-dir=dist/cnc/node_modules \
    --electron-prebuilt-dir=node_modules/electron-prebuilt/ \
    --which-module=serialport

./node_modules/.bin/electron-packager dist/cnc \
    --out=output \
    --overwrite \
    --platform=${PLATFORM} \
    --arch=${ARCH} \
    --version=${ELECTRON_VERSION:1}
