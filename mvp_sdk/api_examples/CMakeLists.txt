cmake_minimum_required(VERSION 3.10)

project(mvp_pubilc_api_examples)
include(CMakeFindDependencyMacro)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -g")

option(MVP_ENABLE_FPGA "enable fpga" OFF)

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fprofile-arcs -ftest-coverage")
endif()

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../include)
set(mvp_private ${CMAKE_CURRENT_SOURCE_DIR}/../include/mvp_private/lib/mac/libmvp_private.a)
set(mvp_public ${CMAKE_CURRENT_SOURCE_DIR}/../build/lib/libmvp_public.a)

## SEAL
find_package(SEAL REQUIRED PACKAGE_FIND_VERSION_MAJOR 3)
## MS-GSL
find_package(Microsoft.GSL REQUIRED)
## Threads
find_package(Threads REQUIRED)

set(LIBS SEAL::seal_shared Microsoft.GSL::GSL Threads::Threads ${mvp_private} ${mvp_public})
if (MVP_ENABLE_FPGA)
  set(LIBS "${LIBS} ${CMAKE_CURRENT_SOURCE_DIR}/../include/mvp_private/linux/libndd.so")
endif()

macro(add_demo FILE)
   add_executable(${FILE}_cc ${FILE}.cc)
   target_link_libraries(${FILE}_cc ${LIBS})
   target_compile_definitions(${FILE}_cc PUBLIC)
endmacro()

add_demo(demo_standalone)
add_demo(demo_end_to_end)
add_demo(demo_user_key)
