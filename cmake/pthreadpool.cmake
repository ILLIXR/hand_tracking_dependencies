find_package(pthreadpool QUIET CONFIG)
if(pthreadpool_FOUND)
    report_found(pthreadpool "${pthreadpool_VERSION}")
else()
    fetch_url(NAME pthreadpool
              SRC_URL https://github.com/Maratyszcza/pthreadpool/archive/4fe0e1e183925bf8cfa6aae24237e724a96479b8.zip
              HASH SHA256=a4cf06de57bfdf8d7b537c61f1c3071bce74e57524fe053e0bbd2332feca7f95
              PATCH TRUE
    )
    #[[
    report_build(pthreadpool)
    FetchContent_Declare(pthreadpool
                         URL https://github.com/Maratyszcza/pthreadpool/archive/4fe0e1e183925bf8cfa6aae24237e724a96479b8.zip
                         URL_HASH SHA256=a4cf06de57bfdf8d7b537c61f1c3071bce74e57524fe053e0bbd2332feca7f95
                         PATCH_COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/../do_patch.sh -p ${CMAKE_SOURCE_DIR}/cmake/pthreadpool/pthreadpool.patch
                         OVERRIDE_FIND_PACKAGE
    )
]]

    set(PTHREADPOOL_BUILD_TESTS OFF)
    set(PTHREADPOOL_BUILD_BENCHMARKS OFF)
    set(PTHREADPOOL_ALLOW_DEPRECATED_API OFF)
    configure_target(pthreadpool)
    #FetchContent_MakeAvailable(pthreadpool)
    unset(PTHREADPOOL_BUILD_TESTS)
    unset(PTHREADPOOL_BUILD_BENCHMARKS)
    unset(PTHREADPOOL_ALLOW_DEPRECATED_API)
    add_library(pthreadpool::pthreadpool ALIAS pthreadpool)
    add_library(pthreadpool::fxdiv ALIAS fxdiv)
endif()
