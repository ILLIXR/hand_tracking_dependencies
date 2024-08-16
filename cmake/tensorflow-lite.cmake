find_package(tensorflow-lite QUIET CONFIG)
if(tensorflow-lite_FOUND)
    report_found(tensorflow-lite "")
else()
    set(EPA tensorflow-lite)
    report_build("${EPA}")
    ExternalProject_Add(
            ${EPA}
            GIT_REPOSITORY https://github.com/ILLIXR/tensorflow-lite
            GIT_TAG d56a7403bf0af11873c379e9540fd5585b439c91
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            PREFIX "${CMAKE_BINARY_DIR}/${EPA}"
            CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DTFLITE_ENABLE_INSTALL=ON -DBUILD_SHARED_LIBS=OFF -DTFLITE_ENABLE_GPU=OFF -DTFLITE_ENABLE_RUY=ON
            DEPENDS ${TFL_DEPENDS}
    )
endif()