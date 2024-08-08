find_package(pthreadpool QUIET CONFIG)
if(pthreadpool_FOUND)
    report_found(pthreadpool ${pthreadpool_VERSION})
else()
    report_build(pthreadpool)
    set(EPA pthreadpool)
    ExternalProject_Add(
            ${EPA}
            URL https://github.com/Maratyszcza/pthreadpool/archive/4fe0e1e183925bf8cfa6aae24237e724a96479b8.zip
            URL_HASH SHA256=a4cf06de57bfdf8d7b537c61f1c3071bce74e57524fe053e0bbd2332feca7f95
            PREFIX "${CMAKE_BINARY_DIR}/${EPA}"
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DPTHREADPOOL_BUILD_TESTS=OFF -DPTHREADPOOL_BUILD_BENCHMARKS=OFF -DPTHREADPOOL_ALLOW_DEPRECATED_API=OFF
    )
    include(CMakePackageConfigHelpers)
    write_basic_package_version_file(
            "${CMAKE_BINARY_DIR}/${EPA}/src/${EPA}-build/pthreadpoolConfigVersion.cmake"
            VERSION 1.0.0
            COMPATIBILITY AnyNewerVersion
    )

    configure_file(
            cmake/pthreadpool/pthreadpoolConfig.cmake.in
            "${CMAKE_BINARY_DIR}/${EPA}/src/${EPA}-build/pthreadpoolConfig.cmake"
            @ONLY
    )
    install(
            FILES "${CMAKE_BINARY_DIR}/${EPA}/src/${EPA}-build/pthreadpoolConfigVersion.cmake" "${CMAKE_BINARY_DIR}/${EPA}/src/${EPA}-build/pthreadpoolConfig.cmake"
            DESTINATION lib/cmake/pthreadpool
    )
endif()