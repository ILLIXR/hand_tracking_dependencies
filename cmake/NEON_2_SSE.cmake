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

find_package(NEON_2_SSE QUIET CONFIG)
if(NEON_2_SSE_FOUND)
    report_found(neon2_sse "${NEON_2_SSE_VERSION}")
else()
    fetch_url(NAME neon_2_sse
              SRC_URL https://storage.googleapis.com/mirror.tensorflow.org/github.com/intel/ARM_NEON_2_x86_SSE/archive/a15b489e1222b2087007546b4912e21293ea86ff.tar.gz
              HASH SHA256=019fbc7ec25860070a1d90e12686fc160cfb33e22aa063c80f52b363f1361e9d
    )
    #[[
    report_build(neon_2_sse)
    FetchContent_Declare(neon_2_sse
                         URL https://storage.googleapis.com/mirror.tensorflow.org/github.com/intel/ARM_NEON_2_x86_SSE/archive/a15b489e1222b2087007546b4912e21293ea86ff.tar.gz
                         # Sync with tensorflow/workspace2.bzl
                         URL_HASH SHA256=019fbc7ec25860070a1d90e12686fc160cfb33e22aa063c80f52b363f1361e9d
                         OVERRIDE_FIND_PACKAGE
    )
    FetchContent_MakeAvailable(neon_2_sse)]]
    configure_target(neon_2_sse)
    add_library(NEON_2_SSE::NEON_2_SSE INTERFACE IMPORTED)
    set_target_properties(NEON_2_SSE::NEON_2_SSE PROPERTIES
                          INTERFACE_INCLUDE_DIRECTORIES ${neon_2_sse_SOURCE_DIR}
    )
endif()
