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

# grpc uses find_package in CONFIG mode for this package, so override the
# system installation and build from source instead.
find_package(absl QUIET CONFIG)
if(absl_FOUND)
    report_found(abseil-cpp "${absl_VERSION}")
else()
    report_build(abseil-cpp)
    set(EPA abseil-cpp)
    ExternalProject_Add(
            ${EPA}
            GIT_REPOSITORY https://github.com/abseil/abseil-cpp
            # Sync with tensorflow/third_party/absl/workspace.bzl
            GIT_TAG 9687a8ea750bfcddf790372093245a1d041b21a3
            GIT_SHALLOW FALSE
            GIT_PROGRESS TRUE
            PREFIX "${CMAKE_BINARY_DIR}/${EPA}"
            CMAKE_ARGS -DABSL_ENABLE_INSTALL=ON -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DABSL_USE_GOOGLETEST_HEAD=OFF -DABSL_PROPAGATE_CXX_STD=ON -DCMAKE_CXX_FLAGS="-fPIC"  -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
    )
    list(APPEND TFL_DEPENDS ${EPA})
endif()
