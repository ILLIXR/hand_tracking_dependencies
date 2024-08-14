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
find_package(ruy QUIET CONFIG)
#get_cmake_property(_variableNames VARIABLES)
#foreach (_variableName ${_variableNames})
#    message(STATUS "${_variableName}=${${_variableName}}")
#endforeach()
set(ruy_DEP "")
if(ruy_FOUND)
    report_found(ruy "${ruy_VERSION}")
else()
    report_build(ruy)
    set(EPA ruy)
    set(ruy_DEP "ruy")
    ExternalProject_Add(
            ${EPA}
            GIT_REPOSITORY https://github.com/ILLIXR/ruy.git
            # Sync with tensorflow/third_party/ruy/workspace.bzl
            GIT_TAG 650d86573bba9702d4c937b8fe7f2ae9f50ec20c
            GIT_PROGRESS TRUE
            PREFIX "${CMAKE_BINARY_DIR}/${EPA}"
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    )
endif()