@echo off
setlocal

:: Cleanup & Setup directories
cd "%~dp0"
if exist godot_headers\ rmdir /s /q godot_headers\
if exist sercomm\ rmdir /s /q sercomm\
if exist bin\ rmdir /s /q bin\
if exist lib\ rmdir /s /q lib\
if exist package\ rmdir /s /q package\
mkdir lib\

:: Download libsercomm
curl -L https://github.com/ingeniamc/sercomm/archive/refs/tags/1.3.2.zip --output sercomm.zip
tar -xf sercomm.zip
rename sercomm-1.3.2 sercomm
del sercomm.zip

:: Download godot headers
curl -L https://github.com/godotengine/godot-headers/archive/refs/tags/godot-3.5.2-stable.zip --output godot_headers.zip
tar -xf godot_headers.zip
rename godot-headers-godot-3.5.2-stable godot_headers
del godot_headers.zip

:: Build libsercomm
cd sercomm
cmake -H. -Bbuild -DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded$<$<CONFIG:Debug>:Debug>"
cmake --build build --config Release
copy build\Release\sercomm.dll ..\lib\
copy build\Release\sercomm.lib ..\lib\
copy build\config.h include\public\
cd ..

:: Build GDSercomm
scons p=windows

:: Construct release package
mkdir package
copy bin\GDSercomm.dll package\
copy lib\sercomm.dll package\
cd package
tar -a -cf win64.zip *.dll