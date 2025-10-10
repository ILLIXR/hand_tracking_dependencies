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
              PATCH TRUE
    )
    #[[
    report_build(fft2d)
    FetchContent_Declare(fft2d
                         URL https://storage.googleapis.com/mirror.tensorflow.org/github.com/petewarden/OouraFFT/archive/v1.0.tar.gz
                         # Sync with tensorflow/workspace2.bzl
                         URL_HASH SHA256=5f4dabc2ae21e1f537425d58a49cdca1c49ea11db0d6271e2a4b27e9697548eb
                         PATCH_COMMAND ${CMAKE_CURRENT_LIST_DIR}/../do_patch.sh -p ${CMAKE_CURRENT_LIST_DIR}/fft2d/fft2d.patch
                         OVERRIDE_FIND_PACKAGE
    )
    FetchContent_MakeAvailable(fft2d)]]
    configure_target(fft2d)

    add_custom_target(fft2d_ext ALL
                      COMMAND ${CMAKE_COMMAND} -E echo ""
    )
    set(fft2d_LIBS alloc fft4f2d fftsg2d fftsg3d fftsg shrtdct)
    foreach(ITEM IN LISTS fft2d_LIBS)
        add_dependencies(fft2d_ext fft2d_${ITEM})
        add_library(fft2d::fft2d_${ITEM} ALIAS fft2d_${ITEM})
    endforeach()
endif()
