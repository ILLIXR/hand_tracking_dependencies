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
find_package(flatbuffers QUIET CONFIG)
if(flatbuffers_FOUND)
    report_found(flatbuffers "${flatbuffers_VERSION}")
else()
    fetch_git(NAME flatbuffers
              REPO https://github.com/google/flatbuffers
              TAG e6463926479bd6b330cbcf673f7e917803fd5831
              NO_SHALLOW
              NO_OVERRIDE
    )

    set(FLATBUFFERS_BUILD_TESTS OFF CACHE BOOL "" FORCE)

    configure_target(NAME flatbuffers
                     NO_FIND
    )

    unset(FLATBUFFERS_BUILD_TESTS CACHE)

    # Build and install flatc at configure time so it is available both:
    #   (a) as a binary before any build step runs, and
    #   (b) as a CMake IMPORTED target for add_custom_command(COMMAND flatbuffers::flatc ...)
    message(STATUS "Building flatc (flatbuffers schema compiler)...")

    # Build and install flatc at configure time via execute_process.
    # FetchContent_MakeAvailable() above already populated flatbuffers_SOURCE_DIR
    # synchronously, so the source is available right now.
    message(STATUS "Building flatc (flatbuffers schema compiler)...")
    cmake_host_system_information(RESULT _num_cores QUERY NUMBER_OF_LOGICAL_CORES)
    execute_process(
            COMMAND ${CMAKE_COMMAND}
                    -B ${CMAKE_BINARY_DIR}/flatbuffers-flatc
                    -S ${flatbuffers_SOURCE_DIR}
                    -DCMAKE_CXX_FLAGS=-fPIC
                    -DFLATBUFFERS_BUILD_TESTS=OFF
                    -DFLATBUFFERS_BUILD_FLATLIB=OFF
                    -DFLATBUFFERS_STATIC_FLATC=ON
                    -DFLATBUFFERS_BUILD_FLATHASH=OFF
                    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
                    -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
                    -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
                    -DCMAKE_POLICY_VERSION_MINIMUM=3.5
            RESULT_VARIABLE _flatc_configure_result
            COMMAND_ECHO STDOUT
    )
    if(NOT _flatc_configure_result EQUAL 0)
        message(FATAL_ERROR "flatc configure step failed (exit ${_flatc_configure_result})")
    endif()

    execute_process(
            COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR}/flatbuffers-flatc --parallel ${_num_cores}
            RESULT_VARIABLE _flatc_build_result
            COMMAND_ECHO STDOUT
    )
    if(NOT _flatc_build_result EQUAL 0)
        message(FATAL_ERROR "flatc build step failed (exit ${_flatc_build_result})")
    endif()

    execute_process(
            COMMAND ${CMAKE_COMMAND} --install ${CMAKE_BINARY_DIR}/flatbuffers-flatc
            RESULT_VARIABLE _flatc_install_result
            COMMAND_ECHO STDOUT
    )
    if(NOT _flatc_install_result EQUAL 0)
        message(FATAL_ERROR "flatc install step failed (exit ${_flatc_install_result})")
    endif()

    message(STATUS "flatc build complete")

    # The upstream flatbuffers-config.cmake uses OPTIONAL includes and silently
    # does nothing when FlatBuffersTargets.cmake isn't in the install tree
    # (that file is a build-tree export buried in a cryptic directory).
    # Replace it with our own that handles both FetchContent and installed modes.
    set(_fb_config_dir "${CMAKE_INSTALL_PREFIX}/lib/cmake/flatbuffers")
    file(MAKE_DIRECTORY "${_fb_config_dir}")
    file(WRITE "${_fb_config_dir}/flatbuffers-config.cmake" [[
# flatbuffers CMake configuration — FetchContent compatible

# ---------------------------------------------------------------
# FetchContent / add_subdirectory mode
# ---------------------------------------------------------------
if(TARGET flatbuffers)
    if(NOT TARGET flatbuffers::flatbuffers)
        add_library(flatbuffers::flatbuffers INTERFACE IMPORTED GLOBAL)
        get_target_property(_fb_inc flatbuffers INTERFACE_INCLUDE_DIRECTORIES)
        set_target_properties(flatbuffers::flatbuffers PROPERTIES
            INTERFACE_LINK_LIBRARIES  "flatbuffers"
            INTERFACE_INCLUDE_DIRECTORIES "${_fb_inc}"
        )
        unset(_fb_inc)
    endif()
    if(NOT TARGET flatbuffers::flatc)
        # flatc was built and installed at configure time via execute_process
        cmake_path(GET CMAKE_CURRENT_LIST_DIR PARENT_PATH _fb_prefix)
        cmake_path(GET _fb_prefix PARENT_PATH _fb_prefix)
        cmake_path(GET _fb_prefix PARENT_PATH _fb_prefix)
        add_executable(flatbuffers::flatc IMPORTED GLOBAL)
        set_target_properties(flatbuffers::flatc PROPERTIES
            IMPORTED_LOCATION "${_fb_prefix}/bin/flatc"
        )
        unset(_fb_prefix)
    endif()
    set(flatbuffers_FOUND TRUE)
    return()
endif()

# ---------------------------------------------------------------
# Installed-package mode
# ---------------------------------------------------------------
foreach(_fb_targets IN ITEMS FlatBuffersTargets FlatcTargets FlatBuffersSharedTargets)
    set(_fb_file "${CMAKE_CURRENT_LIST_DIR}/${_fb_targets}.cmake")
    if(EXISTS "${_fb_file}")
        include("${_fb_file}")
    endif()
endforeach()
unset(_fb_targets)
unset(_fb_file)
]])

    # Point find_package at our config directory for all subsequent calls,
    # including those from within tensorflow-lite's scope.
    set(flatbuffers_DIR "${_fb_config_dir}" CACHE PATH "" FORCE)
    unset(_fb_config_dir)

    # Create the targets directly so they are available in this project scope
    # without needing a find_package call.
    if(NOT TARGET flatbuffers::flatbuffers)
        add_library(flatbuffers::flatbuffers INTERFACE IMPORTED GLOBAL)
        get_target_property(_fb_inc flatbuffers INTERFACE_INCLUDE_DIRECTORIES)
        set_target_properties(flatbuffers::flatbuffers PROPERTIES
                              INTERFACE_LINK_LIBRARIES  "flatbuffers"
                              INTERFACE_INCLUDE_DIRECTORIES "${_fb_inc}"
        )
        unset(_fb_inc)
    endif()

    if(NOT TARGET flatbuffers::flatc)
        add_executable(flatbuffers::flatc IMPORTED GLOBAL)
        set_target_properties(flatbuffers::flatc PROPERTIES
                              IMPORTED_LOCATION "${CMAKE_INSTALL_PREFIX}/bin/flatc"
        )
    endif()
endif()
