find_package(protobuf 3.19 QUIET CONFIG)
if (NOT protobuf_FOUND)
    pkg_check_modules(protobuf protobuf>=3.19)
endif()
if(protobuf_FOUND)
    report_found(protobuf "${protobuf_VERSION}")
else()
    if(WIN32 OR MSVC)
        message(FATAL_ERROR "Please install protobuf and protobuf-c with vcpkg")
    else()
        report_build(protobuf)
        ExternalProject_Add(
                protobuf
                GIT_REPOSITORY https://github.com/protocolbuffers/protobuf.git
                GIT_TAG v3.19.1
                GIT_PROGRESS TRUE
                PREFIX "${CMAKE_BINARY_DIR}/protobuf"
                CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS="-fPIC"
                SOURCE_SUBDIR cmake
                GIT_SUBMODULES_RECURSE TRUE
        )

    endif()
endif()
