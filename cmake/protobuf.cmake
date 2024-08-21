find_package(protobuf 3.19 QUIET CONFIG)
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
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS="-fPIC"
            SOURCE_SUBDIR cmake
            GIT_SUBMODULES_RECURSE TRUE
    )
endif()