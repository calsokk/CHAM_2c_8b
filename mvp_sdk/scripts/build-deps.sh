. scripts/common.sh

HEXL_en=1
if (("$#"> 0)) ; then
 HEXL_en="$1"
fi

if [ $HEXL_en == 1 ]; then
 SEAL_USE_HEXL=ON
else
 SEAL_USE_HEXL=OFF
fi


target=GSL-3.1.0
if [ ! -d $DEPS_DIR/$target ]
then
git clone --branch v3.1.0 https://github.com/microsoft/GSL.git $DEPS_DIR/$target
fi
cd $DEPS_DIR/$target
cmake $DEPS_DIR/$target -DGSL_TEST=OFF -DCMAKE_INSTALL_PREFIX=$BUILD_DIR
make install -j2

target=zstd-1.5.0
if [ ! -d $DEPS_DIR/$target ]
then
git clone --branch v1.5.1 https://github.com/facebook/zstd.git $DEPS_DIR/$target
fi
cd $DEPS_DIR/$target
cmake $DEPS_DIR/$target/build/cmake -DCMAKE_INSTALL_PREFIX=$BUILD_DIR -DZSTD_BUILD_PROGRAMS=OFF -DZSTD_BUILD_SHARED=OFF\
                                    -DZLIB_BUILD_STATIC=ON -DZSTD_BUILD_TESTS=OFF -DZSTD_MULTITHREAD_SUPPORT=OFF
make install -j2

target=cpu_features-0.6.0
if [ ! -d $DEPS_DIR/$target ]
then
git clone --branch v0.6.0 https://github.com/google/cpu_features.git $DEPS_DIR/$target
fi
cd $DEPS_DIR/$target
cmake $DEPS_DIR/$target -DCMAKE_INSTALL_PREFIX=$BUILD_DIR  -DBUILD_TESTING=OFF -DBUILD_PIC=ON
make install -j2

if [ $HEXL_en == 1 ]; then
target=hexl-1.2.3
if [ ! -d $DEPS_DIR/$target ]
then
git clone --branch v1.2.3 https://github.com/intel/hexl.git $DEPS_DIR/$target
fi
cd $DEPS_DIR/$target
cmake $DEPS_DIR/$target -DCMAKE_INSTALL_PREFIX=$BUILD_DIR -DHEXL_BENCHMARK=OFF -DHEXL_COVERAGE=OFF -DHEXL_TESTING=OFF
make install -j2
fi

target=SEAL-3.7.2
if [ ! -d $DEPS_DIR/$target ]
then
git clone --branch v3.7.2 https://github.com/microsoft/SEAL.git $DEPS_DIR/$target
fi
cd $DEPS_DIR/$target
cmake $DEPS_DIR/$target -DCMAKE_INSTALL_PREFIX=$BUILD_DIR -DCMAKE_PREFIX_PATH=$BUILD_DIR\
                        -DSEAL_USE_ZLIB=OFF -DSEAL_BUILD_DEPS=OFF\
                        -DSEAL_USE_MSGSL=ON -DSEAL_USE_ZSTD=ON\
                        -DSEAL_USE_INTEL_HEXL=$SEAL_USE_HEXL -DBUILD_SHARED_LIBS=ON\
                        -DSEAL_THROW_ON_TRANSPARENT_CIPHERTEXT=OFF\
			-DCMAKE_BUILD_TYPE=Release
make install -j4

target=googletest-release-1.11.0
if [ ! -d $DEPS_DIR/$target ]
then
git clone --branch release-1.11.0 https://github.com/google/googletest.git $DEPS_DIR/$target
fi
cd $DEPS_DIR/$target
cmake $DEPS_DIR/$target -DCMAKE_INSTALL_PREFIX=$BUILD_DIR -DCMAKE_PREFIX_PATH=$BUILD_DIR
make install -j4

target=pybind11-2.9.2
if [ ! -d $DEPS_DIR/$target ]
then
git clone --branch v2.9.2 https://github.com/pybind/pybind11.git $DEPS_DIR/$target
fi
cd $DEPS_DIR/$target
python_exe=`which python3`
cmake $DEPS_DIR/$target -DCMAKE_INSTALL_PREFIX=$BUILD_DIR -DPYTHON_EXECUTABLE=$python_exe -DPYBIND11_TEST=OFF
make install -j2

target=fmt-8.0.0
if [ ! -d $DEPS_DIR/$target ]
then
git clone --branch 8.0.0 https://github.com/fmtlib/fmt.git $DEPS_DIR/$target
fi
cd $DEPS_DIR/$target
cmake $DEPS_DIR/$target -DCMAKE_INSTALL_PREFIX=$BUILD_DIR -DFMT_TEST=OFF -DFMT_FUZZ=OFF -DFMT_OS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON
make install -j2

target=spdlog-1.10.0
if [ ! -d $DEPS_DIR/$target ]
then
git clone --branch v1.10.0 https://github.com/gabime/spdlog.git $DEPS_DIR/$target
fi
cd $DEPS_DIR/$target
cmake $DEPS_DIR/$target -DCMAKE_INSTALL_PREFIX=$BUILD_DIR
make install -j2
