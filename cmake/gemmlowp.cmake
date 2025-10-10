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
    fetch_git(NAME gemmlowp
              REPO https://github.com/google/gemmlowp.git
              TAG 16e8662c34917be0065110bfcd9cc27d30f52fdf
              SUBDIR contrib
    )
    #[[
    report_build(gemmlowp)
    FetchContent_Declare(gemmlowp
                         GIT_REPOSITORY https://github.com/google/gemmlowp
                         # Sync with tensorflow/third_party/gemmlowp/workspace.bzl
                         GIT_TAG 16e8662c34917be0065110bfcd9cc27d30f52fdf
                         GIT_PROGRESS TRUE
                         SOURCE_SUBDIR contrib
                         OVERRIDE_FIND_PACKAGE
    )
]]
    set(BUILD_TESTING OFF)
    configure_target(gemmlowp)
    #FetchContent_MakeAvailable(gemmlowp)
    unset(BUILD_TESTING)
    add_library(gemmlowp::gemmlowp ALIAS gemmlowp)
endif()
