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

# tensorflow-lite uses find_package for this package, so build from
# source if the system version is not enabled.

find_package(farmhash QUIET CONFIG)

if(farmhash_FOUND)
    report_found(farmhash "${farmhash_VERSION}")
else()
    fetch_git(NAME farmhash
              REPO https://github.com/google/farmhash
              TAG 0d859a811870d10f53a594927d0d0b97573ad06d
              PATCH
              NO_OVERRIDE
    )

    configure_target(NAME farmhash
                     NO_FIND
    )
    set(farmhash_DIR "${CMAKE_BINARY_DIR}" CACHE PATH "" FORCE)
endif()
