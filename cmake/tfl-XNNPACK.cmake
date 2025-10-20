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

find_package(tfl-XNNPACK${LIBRARY_POSTFIX} QUIET CONFIG)
if(tfl-XNNPACK${LIBRARY_POSTFIX}_FOUND)
    report_found(tfl_XNNPACK "${tfl-XNNPACK${LIBRARY_POSTFIX}_VERSION}")
else()
    report_build(tfl_XNNPACK)
    set(EPA tfl-XNNPACK)
    include(cmake/fp16_headers.cmake)
    ExternalProject_Add(
            ${EPA}
            GIT_REPOSITORY https://github.com/ILLIXR/XNNPACK.git
            # Sync with tensorflow/workspace2.bzl
            GIT_TAG cbef25c6d0abe33f299f9a83d8dc5832ae60d1ae
            GIT_PROGRESS TRUE
            PREFIX "${CMAKE_BINARY_DIR}/${EPA}"
            CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}  -DXNNPACK_BUILD_LIBRARY=ON -DXNNPACK_BUILD_TESTS=OFF -DXNNPACK_BUILD_BENCHMARKS=OFF -DXNNPACK_LIBRARY_TYPE=static -DXNNPACK_USE_SYSTEM_LIBS=ON -DXNNPACK_ENABLE_AVXVNNI=OFF -DXNNPACK_ENABLE_ARM_FP16_SCALAR=OFF -DXNNPACK_ENABLE_ARM_FP16_VECTOR=OFF -DXNNPACK_ENABLE_JIT=OFF -DXNNPACK_ENABLE_SPARSE=ON -DXNNPACK_ENABLE_GEMM_M_SPECIALIZATION=ON -DXNNPACK_ENABLE_ASSEMBLY=ON -DXNNPACK_ENABLE_DWCONV_MULTIPASS=ON -DXNNPACK_ENABLE_MEMOPT=ON -DXNNPACK_ENABLE_AVX512AMX=ON -DXNNPACK_ENABLE_ARM_BF16=OFF -DXNNPACK_ENABLE_ARM_DOTPROD=OFF -DXNNPACK_ENABLE_ARM_I8MM=OFF -DLIBRARY_POSTFIX=${LIBRARY_POSTFIX}  -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_POLICY_VERSION_MINIMUM=3.5
            DEPENDS ${ruy_DEP}
    )
    list(APPEND TFL_DEPENDS ${EPA})
endif()
