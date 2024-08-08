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
find_package(gemmlowp QUIET CONFIG)
if (gemmlowp_FOUND)
    report_found(gemmlowp "")
else()
    report_build(gemmlowp)
    set(EPA gemmlowp)
    ExternalProject_Add(
            gemmlowp
            GIT_REPOSITORY https://github.com/google/gemmlowp
            # Sync with tensorflow/third_party/gemmlowp/workspace.bzl
            GIT_TAG 16e8662c34917be0065110bfcd9cc27d30f52fdf
            # It's not currently (cmake 3.17) possible to shallow clone with a GIT TAG
            # as cmake attempts to git checkout the commit hash after the clone
            # which doesn't work as it's a shallow clone hence a different commit hash.
            # https://gitlab.kitware.com/cmake/cmake/-/issues/17770
            # GIT_SHALLOW TRUE
            GIT_PROGRESS TRUE
            PREFIX "${CMAKE_BINARY_DIR}/${EPA}"
            SOURCE_SUBDIR contrib
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DBUILD_TESTING=OFF
    )

endif()

