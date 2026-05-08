find_package(pthreadpool QUIET CONFIG)
if(pthreadpool_FOUND)
    report_found(pthreadpool "${pthreadpool_VERSION}")
else()
    fetch_url(NAME pthreadpool
              SRC_URL https://github.com/Maratyszcza/pthreadpool/archive/4fe0e1e183925bf8cfa6aae24237e724a96479b8.zip
              HASH SHA256=a4cf06de57bfdf8d7b537c61f1c3071bce74e57524fe053e0bbd2332feca7f95
              PATCH
              NO_OVERRIDE
    )
    set(PTHREADPOOL_BUILD_TESTS OFF CACHE BOOL "" FORCE)
    set(PTHREADPOOL_BUILD_BENCHMARKS OFF CACHE BOOL "" FORCE)
    set(PTHREADPOOL_ALLOW_DEPRECATED_API OFF CACHE BOOL "" FORCE)

    configure_target(NAME pthreadpool
                     NO_FIND
    )
    set(pthreadpool_DIR "${CMAKE_BINARY_DIR}" CACHE PATH "" FORCE)

    unset(PTHREADPOOL_BUILD_TESTS CACHE)
    unset(PTHREADPOOL_BUILD_BENCHMARKS CACHE)
    unset(PTHREADPOOL_ALLOW_DEPRECATED_API CACHE)
endif()
