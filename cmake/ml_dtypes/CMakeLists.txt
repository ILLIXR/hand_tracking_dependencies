#
# Copyright 2023 The TensorFlow Authors. All Rights Reserved.
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
cmake_minimum_required(VERSION 3.16)
project(ml_dtypes CXX)

add_library(ml_dtypes INTERFACE)
file(GLOB ML_DTYPES_PUBLIC_HEADERS
     ${CMAKE_SOURCE_DIR}/ml_dtypes/include/*.h)
set_target_properties(ml_dtypes PROPERTIES
                      PUBLIC_HEADER "${ML_DTYPES_PUBLIC_HEADERS}")
target_include_directories(ml_dtypes INTERFACE
                           $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/ml_dtypes>
                           $<INSTALL_INTERFACE:include/ml_dtypes>
)
include(GNUInstallDirs)

install(
    TARGETS ml_dtypes
    EXPORT ml_dtypesTargets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

install(
    DIRECTORY ${CMAKE_SOURCE_DIR}/ml_dtypes
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

install(
        EXPORT ml_dtypesTargets
        FILE ml_dtypesTargets.cmake
        DESTINATION lib/cmake/ml_dtypes
        NAMESPACE ml_dtypes::
)
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
        "${CMAKE_BINARY_DIR}/ml_dtypesConfigVersion.cmake"
        VERSION 1.1.0
        COMPATIBILITY AnyNewerVersion
)
configure_package_config_file(
        "${CMAKE_SOURCE_DIR}/ml_dtypesConfig.cmake.in"
        "${CMAKE_BINARY_DIR}/ml_dtypesConfig.cmake"
        INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/ml_dtypes"
)
install(
        FILES "${CMAKE_BINARY_DIR}/ml_dtypesConfig.cmake" "${CMAKE_BINARY_DIR}/ml_dtypesConfigVersion.cmake"
        DESTINATION lib/cmake/ml_dtypes
)
