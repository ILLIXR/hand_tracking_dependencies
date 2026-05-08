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
    report_found(absl "${absl_VERSION}")
else()
    fetch_GIT(NAME absl
              REPO https://github.com/abseil/abseil-cpp
              # Sync with tensorflow/third_party/absl/workspace.bzl
              TAG 9687a8ea750bfcddf790372093245a1d041b21a3
              NO_SHALLOW
    )
    set(ABSL_ENABLE_INSTALL ON CACHE BOOL "" FORCE)
    set(ABSL_USE_GOOGLETEST_HEAD OFF CACHE BOOL "" FORCE)
    set(ABSL_PROPAGATE_CXX_STD ON CACHE BOOL "" FORCE)
    set(ABSL_BUILD_TESTING OFF CACHE BOOL "" FORCE)

    configure_target(NAME absl)

    unset(ABSL_ENABLE_INSTALL CACHE)
    unset(ABSL_USE_GOOGLETEST_HEAD CACHE)
    unset(ABSL_PROPAGATE_CXX_STD CACHE)
    unset(ABSL_BUILD_TESTING CACHE)
endif()
