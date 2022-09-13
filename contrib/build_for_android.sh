RED='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
NC='\033[0m'

cd ../
if [ ! -d "build" ]; then
    mkdir build
fi
rm -rf build/*
cd build

# config cmake
echo -e "${Blue}--> config cmake${NC}"
ANDROID_NDK=${ANDROID_HOME}/ndk/25.1.8937393
ANDROID_CMAKE=${ANDROID_HOME}/cmake/3.22.1
ANDROID_ABI="armeabi-v7a,arm64-v8a,x86_64" # armeabi-v7a,arm64-v8a,x86,x86_64

echo -e "${Green}ANDROID_NDK = ${ANDROID_NDK}${NC}"
echo -e "${Green}ANDROID_CMAKE = ${ANDROID_CMAKE}${NC}"
echo -e "${Green}ANDROID_ABI = ${ANDROID_ABI}${NC}"

ABI_LIST=(${ANDROID_ABI//,/ })
for ABI in ${ABI_LIST[@]}; do
    echo -e "${Blue}--> ${ABI}...${NC}"

    BUILD_DIR=build-android-${ABI}
    mkdir -p ${BUILD_DIR}
    pushd ${BUILD_DIR}

    cmake -G "Ninja" \
        -DCMAKE_INSTALL_PREFIX=install/${ABI} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake \
        -DANDROID_NDK=${ANDROID_NDK} \
        -DANDROID_ABI=${ABI} \
        -DANDROID_PLATFORM=21 \
        -DANDROID_NATIVE_API_LEVEL=android-21 \
        -DANDROID_STL=c++_shared \
        -Dprotobuf_BUILD_EXAMPLES=OFF \
        -Dprotobuf_BUILD_TESTS=OFF \
        -Dprotobuf_BUILD_SHARED_LIBS=ON \
        -Dprotobuf_BUILD_LIBPROTOC=FALSE \
        -Dprotobuf_BUILD_PROTOC_BINARIES=FALSE \
        -Dprotobuf_MSVC_STATIC_RUNTIME=OFF ../cmake

    # compile and install
    ninja clean
    ninja install

    popd
    echo -e "${Green}--> ${ABI} done ${NC}"
done
