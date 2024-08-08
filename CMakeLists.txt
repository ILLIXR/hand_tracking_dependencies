cmake_minimum_required(VERSION 3.16)

if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.19)
    cmake_policy(SET CMP0114 NEW)
endif()
if(NOT CMAKE_BUILD_TYPE)
    message(STATUS "No build type specified, setting to Release")
    set(CMAKE_BUILD_TYPE Release)
endif()

option(BUILD_STATIC "Build static libraries" ON)
option(BUILD_SHARED "Build shared libraries" OFF)
option(SYSTEM_FARMHASH "Use system farmhas if possible" ON)

if(BUILD_STATIC AND BUILD_SHARED)
    message(FATAL_ERROR "The syswtem cannot build both static and shared libraries currently, set only one of BUILD_STATIC or BUILD_SHARED to ON")
elseif(NOT BUILD_STATIC)
    set(BUILD_SHARED ON)
endif()

# Double colon in target name means ALIAS or IMPORTED target.
cmake_policy(SET CMP0028 NEW)

project(hand_tracking_dependencies C CXX)
set(CMAKE_CXX_STANFDARD 17)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_MODULE_PATH
    ${CMAKE_SOURCE_DIR}/cmake
    ${CMAKE_MODULE_PATH}
    ${CMAKE_INSTALL_PREFIX}/lib/cmake
)
include(reports)
include(ExternalProject)

include(cmake/absl.cmake)

find_package(Eigen3 REQUIRED CONFIG)
add_compile_definitions(EIGEN_MPL2_ONLY)
include(cmake/farmhash.cmake)
include(cmake/fft2d.cmake)
include(cmake/FlatBuffers.cmake)
include(cmake/gemmlowp.cmake)
if (NOT CMAKE_SYSTEM_PROCESSOR OR CMAKE_SYSTEM_PROCESSOR MATCHES "x86")
    include(cmake/NEON_2_SSE.cmake)
endif()
include(cmake/ml_dtypes.cmake)
include(cmake/ruy.cmake)
include(cmake/pthreadpool.cmake)
include(cmake/tfl-XNNPACK.cmake)
