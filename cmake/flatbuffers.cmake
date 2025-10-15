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

# tensorflow-lite uses find_package for this package, so override the system
# installation and build from source instead.
find_package(flatbuffers QUIET CONFIG)
if(flatbuffers_FOUND)
    report_found(flatbuffers "${flatbuffers_VERSION}")
else()
    if(WIN32 OR MSVC)
        message(FATAL_ERROR "Please install flatbuffers and flatcc with vcpkg")
    else()
        report_build(flatbuffers)
        ExternalProject_Add(
                flatbuffers
                GIT_REPOSITORY https://github.com/google/flatbuffers
                # Sync with tensorflow/third_party/flatbuffers/workspace.bzl
                GIT_TAG e6463926479bd6b330cbcf673f7e917803fd5831
                # NOTE: b/340264458 - `GIT_SHALLOW TRUE` works for tag name only.
                GIT_SHALLOW FALSE
                GIT_PROGRESS TRUE
                PREFIX "${CMAKE_BINARY_DIR}/flatbuffers"
                CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DFLATBUFFERS_BUILD_TESTS=OFF -DCMAKE_CXX_FLAGS="-fPIC"
        )
        # For native flatc build purposes the flatc needs to be included in 'all' target
        if(NOT DEFINED FLATC_EXCLUDE_FROM_ALL)
            set(FLATC_EXCLUDE_FROM_ALL TRUE)
        endif()

        add_custom_target(flatbuffers-flatc
                          COMMAND ${CMAKE_COMMAND} -B ${CMAKE_BINARY_DIR}/flatbuffers-flatc -S ${CMAKE_BINARY_DIR}/${EPA}/src/${EPA} -DCMAKE_CXX_FLAGS="-fPIC" -DFLATBUFFERS_BUILD_TESTS=OFF -DFLATBUFFERS_BUILD_FLATLIB=OFF -DFLATBUFFERS_STATIC_FLATC=ON -DFLATBUFFERS_BUILD_FLATHASH=OFF -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
                          COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR}/flatbuffers-flatc
                          COMMAND ${CMAKE_COMMAND} --install ${CMAKE_BINARY_DIR}/flatbuffers-flatc
        )
        add_dependencies(flatbuffers-flatc flatbuffers)
        list(APPEND TFL_DEPENDS flatbuffers-flatc)

    endif()
endif()
