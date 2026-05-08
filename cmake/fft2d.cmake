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
find_package(fft2d QUIET CONFIG)
if(fft2d_FOUND)
    report_found(fft2d "${fft2d_VERSION}")
else()
    fetch_url(NAME fft2d
              SRC_URL https://storage.googleapis.com/mirror.tensorflow.org/github.com/petewarden/OouraFFT/archive/v1.0.tar.gz
              HASH SHA256=5f4dabc2ae21e1f537425d58a49cdca1c49ea11db0d6271e2a4b27e9697548eb
              PATCH
              NO_OVERRIDE
    )
    configure_target(NAME fft2d
                     NO_FIND
    )
    set(ff2d_DIR "${CMAKE_BINARY_DIR}" CACHE PATH "" FORCE)
endif()
