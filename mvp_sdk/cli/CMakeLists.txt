add_executable(mvp_cli mvp_cli.cc)
find_package(fmt REQUIRED)
target_link_libraries(mvp_cli ${MVP_LIBS} fmt::fmt)