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
    fetch_git(NAME tfl-XNNPACK${LIBRARY_POSTFIX}
              REPO https://github.com/ILLIXR/XNNPACK.git
              TAG 1d9c60da32f1d2b5af17470bdab75017cfad9511
    )
    #[[
    report_build(tfl_XNNPACK)
    include(cmake/fp16_headers.cmake)
    FetchContent_Declare(tfl-XNNPACK${LIBRARY_POSTFIX}
                         GIT_REPOSITORY https://github.com/ILLIXR/XNNPACK.git
                         # Sync with tensorflow/workspace2.bzl
                         GIT_TAG cbef25c6d0abe33f299f9a83d8dc5832ae60d1ae
                         GIT_PROGRESS TRUE
                         OVERRIDE_FIND_PACKAGE
    )]]

    set(XNNPACK_BUILD_LIBRARY ON)
    set(XNNPACK_BUILD_TESTS OFF)
    set(XNNPACK_BUILD_BENCHMARKS OFF)
    set(XNNPACK_LIBRARY_TYPE static)
    set(XNNPACK_USE_SYSTEM_LIBS ON)
    set(XNNPACK_ENABLE_AVXVNNI OFF)
    set(XNNPACK_ENABLE_ARM_FP16_SCALAR OFF)
    set(XNNPACK_ENABLE_ARM_FP16_VECTOR OFF)
    set(XNNPACK_ENABLE_JIT OFF)
    set(XNNPACK_ENABLE_SPARSE ON)
    set(XNNPACK_ENABLE_GEMM_M_SPECIALIZATION ON)
    set(XNNPACK_ENABLE_ASSEMBLY ON)
    set(XNNPACK_ENABLE_DWCONV_MULTIPASS ON)
    set(XNNPACK_ENABLE_MEMOPT ON)
    set(XNNPACK_ENABLE_AVX512AMX ON)
    set(XNNPACK_ENABLE_ARM_BF16 OFF)
    set(XNNPACK_ENABLE_ARM_DOTPROD OFF)
    set(XNNPACK_ENABLE_ARM_I8MM OFF)


    configure_target(tfl-XNNPACK${LIBRARY_POSTFIX})
    #FetchContent_MakeAvailable(tfl-XNNPACK${LIBRARY_POSTFIX})
    unset(XNNPACK_BUILD_LIBRARY)
    unset(XNNPACK_BUILD_TESTS)
    unset(XNNPACK_BUILD_BENCHMARKS)
    unset(XNNPACK_LIBRARY_TYPE)
    unset(XNNPACK_USE_SYSTEM_LIBS)
    unset(XNNPACK_ENABLE_AVXVNNI)
    unset(XNNPACK_ENABLE_ARM_FP16_SCALAR)
    unset(XNNPACK_ENABLE_ARM_FP16_VECTOR)
    unset(XNNPACK_ENABLE_JIT)
    unset(XNNPACK_ENABLE_SPARSE)
    unset(XNNPACK_ENABLE_GEMM_M_SPECIALIZATION)
    unset(XNNPACK_ENABLE_ASSEMBLY)
    unset(XNNPACK_ENABLE_DWCONV_MULTIPASS)
    unset(XNNPACK_ENABLE_MEMOPT)
    unset(XNNPACK_ENABLE_AVX512AMX)
    unset(XNNPACK_ENABLE_ARM_BF16)
    unset(XNNPACK_ENABLE_ARM_DOTPROD)
    unset(XNNPACK_ENABLE_ARM_I8MM)

    if (TARGET ruy_ext)
        add_dependencies(tfl-XNNPACK${LIBRARY_POSTFIX} ruy_ext)
    endif()
    if (TARGET pthreadpool)
        add_dependencies(tfl-XNNPACK${LIBRARY_POSTFIX} pthreadpool)
    endif()

endif()
