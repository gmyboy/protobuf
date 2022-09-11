RED='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
End='\033[0m'

cd ../
if [ ! -d "build" ]; then
    mkdir build
fi
rm -rf build/*
cd build

# config cmake
echo -e "${Blue}--> config cmake${End}"
ANDROID_NDK=${ANDROID_HOME}/ndk/25.1.8937393
ANDROID_CMAKE=${ANDROID_HOME}/cmake/3.22.1
ANDROID_ABI=arm64-v8a # armeabi-v7a,arm64-v8a,x86,x86_64

echo -e "${Green}ANDROID_NDK = ${ANDROID_NDK}${End}"
echo -e "${Green}ANDROID_CMAKE = ${ANDROID_CMAKE}${End}"
echo -e "${Green}ANDROID_ABI = ${ANDROID_ABI}${End}"

cmake -G "Ninja" \
    -DCMAKE_INSTALL_PREFIX=$(pwd)/install \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake \
    -DANDROID_NDK=${ANDROID_NDK} \
    -DANDROID_ABI=${ANDROID_ABI} \
    -DANDROID_PLATFORM=21 \
    -DANDROID_STL=c++_shared \
    -Dprotobuf_BUILD_TESTS=OFF \
    -Dprotobuf_BUILD_SHARED_LIBS=ON \
    -Dprotobuf_MSVC_STATIC_RUNTIME=OFF ../cmake

# compile and install
echo -e "${Blue}--> ninja compile and install${End}"
ninja clean
ninja install