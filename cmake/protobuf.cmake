find_package(protobuf 3.19...3.21 QUIET CONFIG)
if(NOT protobuf_FOUND)
    pkg_check_modules(protobuf QUIET protobuf>=3.19 protobuf<=3.21)
endif()
if(protobuf_FOUND)
    report_found(protobuf "${protobuf_VERSION}")
else()
    ht_fetch_git(NAME protobuf
                 REPO https://github.com/protocolbuffers/protobuf.git
                 TAG v3.19.1
                 RECURSE
                 SUBDIR cmake
    )

    set(protobuf_BUILD_TESTS OFF CACHE BOOL "Build tests" FORCE)
    ht_configure_target(NAME protobuf
                        USE_PKG_CONF
    )
    unset(protobuf_BUILD_TESTS CACHE)
endif()
