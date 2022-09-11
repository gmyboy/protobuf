cd ../
if [ ! -d "build" ]; then
    mkdir build
fi
rm -rf build/*
cd build
# config cmake for x64
cmake -A x64 -DCMAKE_INSTALL_PREFIX=$(pwd)/install \
    -DCMAKE_BUILD_TYPE=Release \
    -Dprotobuf_BUILD_TESTS=OFF \
    -Dprotobuf_MSVC_STATIC_RUNTIME=OFF ../cmake
# compile
cmake --build . --config Release -j 2
# install
cmake --build . --config Release --target $(pwd)/install