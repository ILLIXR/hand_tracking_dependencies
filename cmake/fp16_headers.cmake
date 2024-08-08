#
# Copyright 2021 The TensorFlow Authors. All Rights Reserved.
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
find_path(fp16 fp16.h)
if(fp16)
    report_found(fp16 "")
    set(fp16_headers_FOUND TRUE CACHE BOOL "")
else()
    report_build(fp16)
    set(EPA fp16_headers)
    ExternalProject_Add(
            ${EPA}
            GIT_REPOSITORY https://github.com/Maratyszcza/FP16
            # Sync with https://github.com/google/XNNPACK/blob/master/cmake/DownloadFP16.cmake
            GIT_TAG 0a92994d729ff76a58f692d3028ca1b64b145d91
            GIT_PROGRESS TRUE
            PREFIX "${CMAKE_BINARY_DIR}/${EPA}"
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    )

endif()
