pybind11_add_module(_mvp_py SHARED wrapper.cc)
find_package(fmt REQUIRED)
target_compile_features(_mvp_py PUBLIC cxx_std_17)
target_link_libraries(_mvp_py PUBLIC ${MVP_PRIVATE} ${MVP_PUBLIC} ${SEAL_LIB} ${LIBNDD} fmt::fmt)
