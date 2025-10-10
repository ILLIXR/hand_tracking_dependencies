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
    fetch_git(NAME flatbuffers
              REPO https://github.com/google/flatbuffers.git
              TAG e6463926479bd6b330cbcf673f7e917803fd5831
    )
#[[
    report_build(flatbuffers)
    FetchContent_Declare(flatbuffers
                         GIT_REPOSITORY https://github.com/google/flatbuffers
                         # Sync with tensorflow/third_party/flatbuffers/workspace.bzl
                         GIT_TAG e6463926479bd6b330cbcf673f7e917803fd5831
                         GIT_PROGRESS TRUE
                         OVERRIDE_FIND_PACKAGE
    )
]]
    set(FLATBUFFERS_BUILD_TESTS OFF)
    #FetchContent_MakeAvailable(flatbuffers)
    configure_target(flatbuffers)
    unset(FLATBUFFERS_BUILD_TESTS)
# For native flatc build purposes the flatc needs to be included in 'all' target
    if(NOT DEFINED FLATC_EXCLUDE_FROM_ALL)
        set(FLATC_EXCLUDE_FROM_ALL TRUE)
    endif()


    add_custom_target(flatbuffers-flatc
                      COMMAND ${CMAKE_COMMAND} -B ${CMAKE_CURRENT_BINARY_DIR}/flatbuffers-flatc -S ${CMAKE_CURRENT_BINARY_DIR}/_deps/flatbuffers-src/src/flatbuffers -DCMAKE_CXX_FLAGS="-fPIC" -DFLATBUFFERS_BUILD_TESTS=OFF -DFLATBUFFERS_BUILD_FLATLIB=OFF -DFLATBUFFERS_STATIC_FLATC=ON -DFLATBUFFERS_BUILD_FLATHASH=OFF -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
                      COMMAND ${CMAKE_COMMAND} --build ${CMAKE_CURRENT_BINARY_DIR}/flatbuffers-flatc
                      COMMAND ${CMAKE_COMMAND} --install ${CMAKE_CURRENT_BINARY_DIR}/flatbuffers-flatc
    )
    add_dependencies(flatbuffers-flatc flatbuffers)
    add_library(flatbuffers::flatbuffers ALIAS flatbuffers)
    add_executable(flatbuffers::flatc IMPORTED)
    set_property(TARGET flatbuffers::flatc APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
    set_target_properties(flatbuffers::flatc PROPERTIES
                          IMPORTED_LOCATION_NOCONFIG "${CMAKE_CURRENT_BINARY_DIR}/_deps/flatbuffers-build/flatc"
    )
    message("FLATB ${CMAKE_CURRENT_BINARY_DIR}/flatc")
endif()
