cmake_minimum_required(VERSION 3.10)

project(mvp_pubilc)
include(CMakeFindDependencyMacro)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -g -fPIC")

option(MVP_ENABLE_TESTS "enable gtest" ON)
option(MVP_ENABLE_PYTHON_WRAPPER "enable python wrapper build" ON)

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fprofile-arcs -ftest-coverage")
endif()

## SEAL
find_package(SEAL REQUIRED PACKAGE_FIND_VERSION_MAJOR 3)
if (SEAL_STATIC_FOUND)
  set(SEAL_LIB SEAL::seal)
elseif (SEAL_SHARED_FOUND)
  set(SEAL_LIB SEAL::seal_shared)
endif()
## MS-GSL
find_package(Microsoft.GSL REQUIRED)
## Threads
find_package(Threads REQUIRED)
## SPDLOG
find_package(spdlog REQUIRED)
## Pybind11
if (MVP_ENABLE_PYTHON_WRAPPER)
  find_package(pybind11)
endif()

include_directories(${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/include)

set(MVP_PUBLIC mvp_public)
add_library(${MVP_PUBLIC})
add_library(MVP::public ALIAS ${MVP_PUBLIC})
add_subdirectory(include/mvp_public)
target_link_libraries(${MVP_PUBLIC} SEAL::seal_shared Microsoft.GSL::GSL spdlog::spdlog_header_only Threads::Threads)

set(MVP_LIBS ${MVP_PUBLIC})


if (MVP_ENABLE_TESTS)
  enable_testing()
  find_package(GTest REQUIRED)
  add_executable(mvp_pub_tests)
  add_subdirectory(tests/)
  target_link_libraries(mvp_pub_tests GTest::gtest_main GTest::gtest ${MVP_LIBS})
endif()

if (MVP_ENABLE_PYTHON_WRAPPER)
  add_subdirectory(python)
endif()

## build CLI
add_subdirectory(cli)

macro(add_exe FILE)
   add_executable(${FILE}_cc api_examples/${FILE}.cc)
   target_link_libraries(${FILE}_cc ${MVP_LIBS})
   target_compile_definitions(${FILE}_cc PUBLIC)
endmacro()

if (MVP_ENABLE_DEMO)
  add_exe(demo_standalone)
  add_exe(demo_end_to_end)
  add_exe(demo_user_key)
endif()


