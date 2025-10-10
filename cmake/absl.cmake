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

# grpc uses find_package in CONFIG mode for this package, so override the
# system installation and build from source instead.
find_package(absl QUIET CONFIG)
if(absl_FOUND)
    report_found(abseil "${absl_VERSION}")
else()
    fetch_git(NAME absl
              REPO https://github.com/abseil/abseil-cpp.git
              TAG 9687a8ea750bfcddf790372093245a1d041b21a3
    )
#[[
    report_build(abseil)
    FetchContent_Declare(absl
                         GIT_REPOSITORY https://github.com/abseil/abseil-cpp
                         # Sync with tensorflow/third_party/absl/workspace.bzl
                         GIT_TAG 9687a8ea750bfcddf790372093245a1d041b21a3
                         GIT_PROGRESS TRUE
                         OVERRIDE_FIND_PACKAGE
    )
    ]]
    set(ABSL_ENABLE_INSTALL ON)
    set(ABSL_USE_GOOGLETEST_HEAD OFF)
    set(ABSL_PROPAGATE_CXX_STD ON)
    configure_target(absl)
    #FetchContent_MakeAvailable(absl)
    unset(ABSL_ENABLE_INSTALL)
    unset(ABSL_USE_GOOGLETEST_HEAD)
    unset(ABSL_PROPAGATE_CXX_STD)

    add_custom_target(absl_ext ALL
                      COMMAND ${CMAKE_COMMAND} -E echo ""
    )
    add_dependencies(absl_ext bad_any_cast_impl bad_optional_access bad_variant_access base city civil_time cord cord_internal cordz_functions cordz_handle cordz_info cordz_sample_token crc32c crc_cord_state crc_cpu_detect crc_internal debugging_internal demangle_internal die_if_null examine_stack exponential_biased failure_signal_handler flags flags_commandlineflag flags_commandlineflag_internal flags_config flags_internal flags_marshalling flags_parse flags_private_handle_accessor flags_program_name flags_reflection flags_usage flags_usage_internal graphcycles_internal hash hashtablez_sampler int128 kernel_timeout_internal leak_check log_entry log_flags log_globals log_initialize log_internal_check_op log_internal_conditions log_internal_fnmatch log_internal_format log_internal_globals log_internal_log_sink_set log_internal_message log_internal_nullguard log_internal_proto log_severity log_sink low_level_hash malloc_internal periodic_sampler random_distributions random_internal_distribution_test_util random_internal_platform random_internal_pool_urbg random_internal_randen random_internal_randen_hwaes random_internal_randen_hwaes_impl random_internal_randen_slow random_internal_seed_material random_seed_gen_exception random_seed_sequences raw_hash_set raw_logging_internal scoped_set_env spinlock_wait stacktrace status statusor strerror str_format_internal strings strings_internal string_view symbolize synchronization throw_delegate time time_zone)

endif()
