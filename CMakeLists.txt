cmake_minimum_required(VERSION 3.22)

cmake_policy(SET CMP0114 NEW)
if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.24)
    cmake_policy(SET CMP0135 NEW)
endif()

# Double colon in target name means ALIAS or IMPORTED target.
cmake_policy(SET CMP0028 NEW)
if(NOT CMAKE_BUILD_TYPE)
    message(STATUS "No build type specified, setting to Release")
    set(CMAKE_BUILD_TYPE Release)
endif()

option(ENABLE_GPU "Whether to compile tensorflow for gpu use" OFF)
option(LIBRARY_POSTFIX "Used as additional postfix for delineating between similar but not identical library versions" "")
set(TFL_DEPENDS "")
if(LIBRARY_POSTFIX)
    if(NOT ((LIBRARY_POSTFIX MATCHES "^-") OR (LIBRARY_POSTFIX MATCHES "^_")))
        set(LIBRARY_POSTFIX "-${LIBRARY_POSTFIX}")
    endif()
else()
    set(LIBRARY_POSTFIX "")
endif()

project(hand_tracking_dependencies C CXX)
set(CMAKE_CXX_STANFDARD 17)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_MODULE_PATH
    ${CMAKE_SOURCE_DIR}/cmake
    ${CMAKE_MODULE_PATH}
    ${CMAKE_INSTALL_PREFIX}/lib/cmake
)
include(cmake/reports.cmake)
include(ExternalProject)
find_package(PkgConfig REQUIRED)
include(cmake/absl.cmake)

find_package(Eigen3 REQUIRED CONFIG)
add_compile_definitions(EIGEN_MPL2_ONLY)
include(cmake/farmhash.cmake)
include(cmake/fft2d.cmake)
include(cmake/flatbuffers.cmake)
include(cmake/gemmlowp.cmake)
if (NOT CMAKE_SYSTEM_PROCESSOR OR CMAKE_SYSTEM_PROCESSOR MATCHES "x86")
    include(cmake/NEON_2_SSE.cmake)
endif()
include(cmake/ruy.cmake)
include(cmake/pthreadpool.cmake)
include(cmake/tfl-XNNPACK.cmake)
include(cmake/tensorflow-lite.cmake)
include(cmake/protobuf.cmake)
