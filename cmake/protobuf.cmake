find_package(protobuf 3.19...3.21 QUIET CONFIG)
if(NOT protobuf_FOUND)
    pkg_check_modules(protobuf QUIET protobuf>=3.19 protobuf<=3.21)
endif()
if(protobuf_FOUND)
    report_found(protobuf "${protobuf_VERSION}")
else()
    set(EPA protobuf)
    report_build(${EPA})
    ExternalProject_Add(
            ${EPA}
            GIT_REPOSITORY https://github.com/protocolbuffers/protobuf.git
            GIT_TAG v3.19.1
            GIT_PROGRESS TRUE
            PREFIX "${CMAKE_BINARY_DIR}/${EPA}"
            CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS="-fPIC"  -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_POLICY_VERSION_MINIMUM=3.5
            SOURCE_SUBDIR cmake
            GIT_SUBMODULES_RECURSE TRUE
    )
endif()
