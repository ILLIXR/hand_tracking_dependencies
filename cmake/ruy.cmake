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
#get_cmake_property(_variableNames VARIABLES)
#foreach (_variableName ${_variableNames})
#    message(STATUS "${_variableName}=${${_variableName}}")
#endforeach()
set(ruy_DEP "")
if(ruy_FOUND)
    report_found(ruy "${ruy_VERSION}")
else()
    fetch_git(NAME ruy
              REPO https://github.com/ILLIXR/ruy.git
              TAG dadeec28688d203bba1ea10ec9d331204dc6c28c
    )
    #[[
    report_build(ruy)
    FetchContent_Declare(ruy
                         GIT_REPOSITORY https://github.com/ILLIXR/ruy.git
                         # Sync with tensorflow/third_party/ruy/workspace.bzl
                         GIT_TAG b7f1add8a9a65e4eb375e56313ef7d7a97f768c4
                         GIT_PROGRESS TRUE
                         OVERRIDE_FIND_PACKAGE
    )

    FetchContent_MakeAvailable(ruy)]]
    configure_target(ruy)
    add_custom_target(ruy_ext ALL
               COMMAND ${CMAKE_COMMAND} -E echo ""
    )
    add_dependencies(ruy_ext ruy_allocator ruy_apply_multiplier ruy_blocking_counter ruy_block_map ruy_context ruy_context_get_ctx
                     ruy_cpuinfo ruy_ctx ruy_denormal ruy_frontend ruy_have_built_path_for_avx2_fma ruy_have_built_path_for_avx512
                     ruy_have_built_path_for_avx ruy_kernel_arm ruy_kernel_avx2_fma ruy_kernel_avx512 ruy_kernel_avx
                     ruy_pack_arm ruy_pack_avx2_fma ruy_pack_avx512 ruy_pack_avx ruy_prepacked_cache ruy_prepare_packed_matrices
                     ruy_profiler_instrumentation ruy_profiler_profiler ruy_system_aligned_alloc ruy_thread_pool ruy_trmul
                     ruy_tune ruy_wait
    )

    # Create imported target ruy::ruy
    add_library(ruy::ruy INTERFACE IMPORTED)

    set_target_properties(ruy::ruy PROPERTIES
                          INTERFACE_INCLUDE_DIRECTORIES "${ruy_SOURCE_DIR}"
                          INTERFACE_LINK_LIBRARIES "ruy_check_macros;ruy_context;ruy_context_get_ctx;ruy_frontend;ruy_mat;ruy_matrix;ruy_mul_params;ruy_path;ruy_platform;ruy_size_util;ruy_trace"
    )

endif()
