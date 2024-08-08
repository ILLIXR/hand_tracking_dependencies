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
find_package(egl_headers QUIET CONFIG)

if(egl_headers_FOUND)
    report_found(egl_headers ${egl_headers_VERSION})
else()
    report_build(egl_headers)
    include(FetchContent)
    set(EPA egl_headers)
    file(MAKE_DIRECTORY "${CMAKE_INSTALL_PREFIX}/include")
    FetchContent_Declare(
            ${EPA}
            GIT_REPOSITORY https://github.com/KhronosGroup/EGL-Registry.git
            # No reference in TensorFlow Bazel rule since it's used for GPU Delegate
            # build without using Android NDK.
            GIT_TAG 649981109e263b737e7735933c90626c29a306f2
            GIT_PROGRESS TRUE
            PREFIX "${CMAKE_BINARY_DIR}/${EPA}"
            CONFIGURE_COMMAND "cp -r ${CMAKE_BINARY_DIR}/${EPA}/EGL ${CMAKE_INSTALL_PREFIX}/include/."
            BUILD_COMMAND ""
            INSTALL_COMMAND ""
            # Per https://www.khronos.org/legal/Khronos_Apache_2.0_CLA
            LICENSE_URL "https://www.apache.org/licenses/LICENSE-2.0.txt"
    )
    FetchContent_MakeAvailable(${EPA})
    include(CMakePackageConfigHelpers)
    write_basic_package_version_file(
            "${CMAKE_BINARY_DIR}/${EPA}/src/${EPA}-build/egl_headersConfigVersion.cmake"
            VERSION 1.1.0
            COMPATABILITY AnyNewerVersion
    )
    configure_file(
            cmake/egl_headers/egl_headersConfig.cmake.in
            "${CMAKE_BINARY_DIR}/${EPA}/src/${EPA}-build/egl_headersConfig.cmake"
            @ONLY
    )
    install(
            FILES "${CMAKE_BINARY_DIR}/${EPA}/src/${EPA}-build/egl_headersConfigVersion.cmake" "${CMAKE_BINARY_DIR}/${EPA}/src/${EPA}-build/egl_headersConfig.cmake"
            DESTINATION lib/cmake/egl_headers
            COMPONENT Devel
    )
    include_directories("${CMAKE_INSTALL_PREFIX}/include/")
endif()

