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

if(ruy_FOUND)
    report_found(ruy "${ruy_VERSION}")
else()
    ht_fetch_git(NAME ruy
                 REPO https://github.com/ILLIXR/ruy.git
                 TAG 0d83ecee595017667a0328f33ca97a5d25c6430c
                 NO_OVERRIDE
    )

    set(RUY_ENABLE_INSTALL ON CACHE BOOL "" FORCE)
    ht_configure_target(NAME ruy
                        NO_FIND
    )
    set(ruy_DIR ${ruy_BINARY_DIR} CACHE PATH "" FORCE)
endif()
