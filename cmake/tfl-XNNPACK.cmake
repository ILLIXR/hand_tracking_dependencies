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
find_package(tfl-XNNPACK QUIET CONFIG)
if(tfl-XNNPACK_FOUND)
    report_found(tfl_XNNPACK "${tfl-XNNPACK_VERSION}")
else()
    report_build(tfl_XNNPACK)
    set(EPA tfl-XNNPACK)
    include(cmake/fp16_headers.cmake)
    ExternalProject_Add(
            ${EPA}
            GIT_REPOSITORY https://github.com/ILLIXR/XNNPACK.git
            # Sync with tensorflow/workspace2.bzl
            GIT_TAG 68c21ddb2e5d6d96adfa4e0afef61248288789e6
            GIT_PROGRESS TRUE
            PREFIX "${CMAKE_BINARY_DIR}/${EPA}"
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DXNNPACK_BUILD_TESTS=OFF -DXNNPACK_BUILD_BENCHMARKS=OFF -DXNNPACK_LIBRARY_TYPE=shared -DXNNPACK_USE_SYSTEM_LIBS=ON -DXNNPACK_ENABLE_AVXVNNI=OFF
            DEPENDS ${ruy_DEP}
    )
    list(APPEND TFL_DEPENDS ${EPA})
endif()
