find_package(tensorflow-lite QUIET CONFIG)
if(tensorflow-lite_FOUND)
    report_found(tensorflow-lite "")
else()
    set(EPA tensorflow-lite)
    report_build("${EPA}")
    ExternalProject_Add(
            ${EPA}
            GIT_REPOSITORY https://github.com/ILLIXR/tensorflow-lite
            GIT_TAG c12f552568b35eb7c4fda93a00e83fce287f5b72
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            PREFIX "${CMAKE_BINARY_DIR}/${EPA}"
            CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DTFLITE_ENABLE_INSTALL=ON -DBUILD_SHARED_LIBS=OFF -DTFLITE_ENABLE_GPU=${ENABLE_GPU} -DTFLITE_ENABLE_RUY=ON -DTFLITE_ENABLE_NNAPI=ON -DLIBRARY_POSTFIX=${LIBRARY_POSTFIX}
            DEPENDS ${TFL_DEPENDS}
    )
endif()