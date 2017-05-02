#This script is intended to run on Linux or OSX. Cygwin might work.

# if this flag is set, build is tagged as release in the version
# echo $IS_RELEASE_BUILD

#Need to set path to EMScripten
export EMSCRIPTEN_ROOT=/home/moritz/code/emsdk_portable/emscripten/master

#Build templates

#remove this stuff, will be created anew
rm -rf templates
mkdir -p templates


# Windows 32 Release and Debug

scons -j 4 p=windows target=release tools=no bits=32
cp bin/godot.windows.opt.32.exe templates/windows_32_release.exe
upx templates/windows_32_release.exe
scons -j 4 p=windows target=release_debug tools=no bits=32
cp bin/godot.windows.opt.debug.32.exe templates/windows_32_debug.exe
upx templates/windows_32_debug.exe

# Windows 64 Release and Debug (UPX does not support it yet)

scons -j 4 p=windows target=release tools=no bits=64
cp bin/godot.windows.opt.64.exe templates/windows_64_release.exe
x86_64-w64-mingw32-strip templates/windows_64_release.exe
scons -j 4 p=windows target=release_debug tools=no bits=64
cp bin/godot.windows.opt.debug.64.exe templates/windows_64_debug.exe
x86_64-w64-mingw32-strip templates/windows_64_debug.exe

# Linux 64 Release and Debug

scons -j 4 p=x11 target=release tools=no bits=64
cp bin/godot.x11.opt.64 templates/linux_x11_64_release
upx templates/linux_x11_64_release
scons -j 4 p=x11 target=release_debug tools=no bits=64
cp bin/godot.x11.opt.debug.64 templates/linux_x11_64_debug
upx templates/linux_x11_64_debug

# Linux 32 Release and Debug

scons -j 4 p=x11 target=release tools=no bits=32
cp bin/godot.x11.opt.32 templates/linux_x11_32_release
upx templates/linux_x11_32_release
scons -j 4 p=x11 target=release_debug tools=no bits=32
cp bin/godot.x11.opt.debug.32 templates/linux_x11_32_debug
upx templates/linux_x11_32_debug

# Server for 32 and 64 bits (always in debug)
scons -j 4 p=server target=release_debug tools=no bits=64
cp bin/godot_server.server.opt.debug.64 templates/linux_server_64
upx templates/linux_server_64
scons -j 4 p=server target=release_debug tools=no bits=32
cp bin/godot_server.server.opt.debug.32 templates/linux_server_32
upx templates/linux_server_32


# Android
**IMPORTANT REPLACE THIS BY ACTUAL VALUES**

export ANDROID_HOME=/home/moritz/Android/Sdk
export ANDROID_NDK_ROOT=/home/moritz/Android/Sdk/ndk-bundle

# git does not allow empty dirs, so create those
mkdir -p platform/android/java/libs/armeabi
mkdir -p platform/android/java/libs/x86

#Android Release

scons -j 4 p=android target=release
cp bin/libgodot.android.opt.so platform/android/java/libs/armeabi/libgodot_android.so
./gradlew build
cp platform/android/java/build/outputs/apk/java-release-unsigned.apk templates/android_release.apk

#Android Debug

scons -j 4 p=android target=release_debug
cp bin/libgodot.android.opt.debug.so platform/android/java/libs/armeabi/libgodot_android.so
./gradlew build
cp platform/android/java/build/outputs/apk/java-release-unsigned.apk templates/android_debug.apk

# EMScripten

scons -j 4 p=javascript target=release
cp bin/godot.javascript.opt.html godot.html
cp bin/godot.javascript.opt.js godot.js
cp tools/html_fs/filesystem.js .
zip javascript_release.zip godot.html godot.js filesystem.js
mv javascript_release.zip templates/

scons -j 4 p=javascript target=release_debug
cp bin/godot.javascript.opt.debug.html godot.html
cp bin/godot.javascript.opt.debug.js godot.js
cp tools/html_fs/filesystem.js .
zip javascript_debug.zip godot.html godot.js filesystem.js
mv javascript_debug.zip templates/
