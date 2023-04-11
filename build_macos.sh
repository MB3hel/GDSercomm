#!/usr/bin/env bash

# Cleanup & Setup directories
cd $(realpath $(dirname "$0"))
rm -rf godot_headers/
rm -rf sercomm/
rm -rf bin/
rm -rf lib/
rm -rf package/
mkdir lib/

# Download libsercomm
curl -L https://github.com/ingeniamc/sercomm/archive/refs/tags/1.3.2.zip --output sercomm.zip
unzip sercomm.zip
mv sercomm-1.3.2 sercomm
rm sercomm.zip

# Download godot headers
curl -L https://github.com/godotengine/godot-headers/archive/refs/tags/godot-3.5.2-stable.zip --output godot_headers.zip
unzip godot_headers.zip
mv godot-headers-godot-3.5.2-stable godot_headers
rm godot_headers.zip

# Build libsercomm
cd sercomm
cmake -H. -Bbuild -DCMAKE_BUILD_TYPE=Release
cmake --build build
cp build/libsercomm.dylib ../lib/
cp build/config.h include/public/
cd ..

# Build GDSercomm
scons p=macos
install_name_tool -add_rpath gdsercomm/macos64 bin/libGDSercomm.dylib

# Construct release package
mkdir package
cp bin/libGDSercomm.dylib package/
cp lib/libsercomm.dylib package/
cd package
zip macos64.zip *.dylib