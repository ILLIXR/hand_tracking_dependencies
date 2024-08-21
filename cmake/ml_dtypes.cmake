#
# Copyright 2023 The TensorFlow Authors. All Rights Reserved.
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

# tensorflow-lite uses find_package for this package, so build from
# source if the system version is not enabled.
find_package(ml_dtypes QUIET CONFIG)

if(ml_dtypes_FOUND)
    report_found(ml_dtypes "${ml_dtypes_VERSION}")
else()
    report_build(ml_dtypes)
    set(EPA ml_dtypes)
    ExternalProject_Add(
            ${EPA}
            GIT_REPOSITORY https://github.com/jax-ml/ml_dtypes
            # Sync with tensorflow/third_party/py/ml_dtypes/workspace.bzl
            GIT_TAG 24084d9ed2c3d45bf83b7a9bff833aa185bf9172
            # It's not currently possible to shallow clone with a GIT TAG
            # as cmake attempts to git checkout the commit hash after the clone
            # which doesn't work as it's a shallow clone hence a different commit hash.
            # https://gitlab.kitware.com/cmake/cmake/-/issues/17770
            # GIT_SHALLOW TRUE
            GIT_PROGRESS TRUE
            PREFIX "${CMAKE_BINARY_DIR}/${EPA}"
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            PATCH_COMMAND ${CMAKE_SOURCE_DIR}/do_patch.sh -p ${CMAKE_SOURCE_DIR}/cmake/ml_dtypes/ml_dtypes.patch
            CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS="-fPIC"
    )
    list(APPEND TFL_DEPENDS ${EPA})
endif()