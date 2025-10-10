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
    #report_build(egl_headers)
    file(MAKE_DIRECTORY "${CMAKE_INSTALL_PREFIX}/include")
    fetch_git(NAME egl_headers
              REPO https://github.com/KhronosGroup/EGL-Registry.git
              TAG 649981109e263b737e7735933c90626c29a306f2
    )
#[[
    FetchContent_Declare(egl_headers
                         GIT_REPOSITORY https://github.com/KhronosGroup/EGL-Registry.git
                         # No reference in TensorFlow Bazel rule since it's used for GPU Delegate
                         # build without using Android NDK.
                         GIT_TAG 649981109e263b737e7735933c90626c29a306f2
                         GIT_PROGRESS TRUE
    )
    FetchContent_MakeAvailable(${egl_headers})]]
    configure_target(egl_headers)
    execute_process(COMMAND "cp -r ${CMAKE_CURRENT_BINARY_DIR}/egl_headers/EGL ${CMAKE_INSTALL_PREFIX}/include/.")
    include(CMakePackageConfigHelpers)
    write_basic_package_version_file(
            "${CMAKE_CURRENT_BINARY_DIR}/egl_headers/src/egl_headers-build/egl_headersConfigVersion.cmake"
            VERSION 1.1.0
            COMPATABILITY AnyNewerVersion
    )
    configure_file(
            cmake/egl_headers/egl_headersConfig.cmake.in
            "${CMAKE_CURRENT_BINARY_DIR}/egl_headers/src/egl_headers-build/egl_headersConfig.cmake"
            @ONLY
    )
    install(
            FILES "${CMAKE_CURRENT_BINARY_DIR}/egl_headers/src/egl_headers-build/egl_headersConfigVersion.cmake" "${CMAKE_CURRENT_BINARY_DIR}/egl_headers/src/egl_headers-build/egl_headersConfig.cmake"
            DESTINATION lib/cmake/egl_headers
            COMPONENT Devel
    )
    include_directories("${CMAKE_INSTALL_PREFIX}/include/")
endif()
