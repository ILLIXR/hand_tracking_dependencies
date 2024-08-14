#
# Copyright 2020 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
cmake_minimum_required(VERSION 3.16)
# modified by ILLIXR
project(fft2d C)


# fft2d doesn't have a CMake project so define it here transcribed from
# sample2d/Makefile.

# A developer should link this library if they haven't provided their own
# implementation of these allocation methods.
add_library(fft2d_alloc
            alloc.c
            alloc.h
)

# Requires implementation of fft2d_alloc.
add_library(fft2d_fft4f2d fft4f2d.c)

add_library(fft2d_fftsg fftsg.c)
if(NOT CMAKE_SYSTEM_NAME STREQUAL Windows)
    target_link_libraries(fft2d_fftsg m)
endif()
set_target_properties(fft2d_fftsg PROPERTIES PUBLIC_HEADER fft.h)
# Requires implementation of fft2d_alloc.
add_library(fft2d_fftsg2d fftsg2d.c)
target_link_libraries(fft2d_fftsg2d fft2d_fftsg)

# Requires implementation of fft2d_alloc.
add_library(fft2d_fftsg3d fftsg3d.c)
target_link_libraries(fft2d_fftsg3d fft2d_fftsg)

add_library(fft2d_shrtdct shrtdct.c)

add_library(fft2d ALIAS fft2d_fftsg2d)

set_target_properties(fft2d_fftsg2d PROPERTIES PUBLIC_HEADER fft2d.h)

include(GNUInstallDirs)
install(
        TARGETS fft2d_fftsg2d fft2d_alloc fft2d_fftsg fft2d_fft4f2d fft2d_fftsg3d fft2d_shrtdct
        EXPORT fft2dTargets
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

install(
        EXPORT fft2dTargets
        FILE fft2dTargets.cmake
        DESTINATION lib/cmake/fft2d
        NAMESPACE fft2d::
)
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
        "${CMAKE_BINARY_DIR}/fft2dConfigVersion.cmake"
        VERSION 2.0.0
        COMPATIBILITY AnyNewerVersion
)
configure_package_config_file(
        "${CMAKE_SOURCE_DIR}/fft2dConfig.cmake.in"
        "${CMAKE_BINARY_DIR}/fft2dConfig.cmake"
        INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/fft2d"
)

install(
        FILES "${CMAKE_BINARY_DIR}/fft2dConfig.cmake" "${CMAKE_BINARY_DIR}/fft2dConfigVersion.cmake"
        DESTINATION lib/cmake/fft2d
)
