find_package(protobuf 3.19 QUIET CONFIG)
if (NOT protobuf_FOUND)
    pkg_check_modules(protobuf protobuf>=3.19)
endif()
if(protobuf_FOUND)
    report_found(protobuf "${protobuf_VERSION}")
else()
    fetch_git(NAME protobuf
              REPO https://github.com/protocolbuffers/protobuf.git
              TAG v3.19.1
              RECURSE TRUE
    )
    #[[
    report_build(protobuf)
    FetchContent_Declare(protobuf
                         GIT_REPOSITORY https://github.com/protocolbuffers/protobuf.git
                         GIT_TAG v3.19.1
                         SOURCE_SUBDIR cmake
                         GIT_SUBMODULES_RECURSE TRUE
                         GIT_PROGRESS TRUE
                         OVERRIDE_FIND_PACKAGE
    )
    FetchContent_MakeAvailable(protobuf)]]
    configure_target(protobuf)
endif()
