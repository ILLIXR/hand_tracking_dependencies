find_package(pthreadpool QUIET CONFIG)
if(pthreadpool_FOUND)
    report_found(pthreadpool "${pthreadpool_VERSION}")
else()
    report_build(pthreadpool)
    set(EPA pthreadpool)
    ExternalProject_Add(
            ${EPA}
            URL https://github.com/Maratyszcza/pthreadpool/archive/4fe0e1e183925bf8cfa6aae24237e724a96479b8.zip
            URL_HASH SHA256=a4cf06de57bfdf8d7b537c61f1c3071bce74e57524fe053e0bbd2332feca7f95
            PREFIX "${CMAKE_BINARY_DIR}/${EPA}"
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            PATCH_COMMAND ${CMAKE_SOURCE_DIR}/do_patch.sh -p ${CMAKE_SOURCE_DIR}/cmake/pthreadpool/pthreadpool.patch
            CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DPTHREADPOOL_BUILD_TESTS=OFF -DPTHREADPOOL_BUILD_BENCHMARKS=OFF -DPTHREADPOOL_ALLOW_DEPRECATED_API=OFF
    )
    list(APPEND TFL_DEPENDS ${EPA})
endif()