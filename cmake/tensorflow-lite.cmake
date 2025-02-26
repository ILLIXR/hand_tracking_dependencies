set(TFLIBRARY_POSTFIX ${LIBRARY_POSTFIX})
if(ENABLE_GPU)
    set(TFLIBRARY_POSTFIX "${TFLIBRARY_POSTFIX}-gpu")
endif()
find_package(tensorflow-lite${TFLIBRARY_POSTFIX} QUIET CONFIG)
if(tensorflow-lite${TFLIBRARY_POSTFIX}_FOUND)
    report_found(tensorflow-lite "")
else()
    set(EPA tensorflow-lite)
    report_build("${EPA}")
    ExternalProject_Add(
            ${EPA}
            GIT_REPOSITORY https://github.com/ILLIXR/tensorflow-lite
            GIT_TAG 02367633eedb5a2598d65bee8e9f554b17ddad66
            PREFIX "${CMAKE_BINARY_DIR}/${EPA}"
            CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DTFLITE_ENABLE_INSTALL=ON -DBUILD_SHARED_LIBS=OFF -DTFLITE_ENABLE_GPU=${ENABLE_GPU} -DTFLITE_ENABLE_RUY=ON -DTFLITE_ENABLE_NNAPI=ON -DLIBRARY_POSTFIX=${LIBRARY_POSTFIX}
            DEPENDS ${TFL_DEPENDS}
    )
endif()
