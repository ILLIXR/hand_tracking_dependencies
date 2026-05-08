set(TFLIBRARY_POSTFIX ${LIBRARY_POSTFIX} CACHE STRING "" FORCE)
if(ENABLE_GPU)
    set(TFLIBRARY_POSTFIX "${TFLIBRARY_POSTFIX}-gpu" CACHE STRING "" FORCE)
endif()
find_package(tensorflow-lite${TFLIBRARY_POSTFIX} QUIET CONFIG)
if(tensorflow-lite${TFLIBRARY_POSTFIX}_FOUND)
    report_found(tensorflow-lite "")
else()
    fetch_git(NAME tensorflow-lite${TFLIBRARY_POSTFIX}
              REPO https://github.com/ILLIXR/tensorflow-lite
              TAG cdef8ca128586de113858b81421b0ceea4c72bb0
              NO_OVERRIDE
    )
    set(TFLITE_ENABLE_INSTALL ON CACHE BOOL "" FORCE)
    set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
    set(TFLITE_ENABLE_GPU ${ENABLE_GPU} CACHE BOOL "" FORCE)
    set(TFLITE_ENABLE_RUY ON CACHE BOOL "" FORCE)
    set(TFLITE_ENABLE_NNAPI ON CACHE BOOL "" FORCE)

    configure_target(NAME tensorflow-lite${TFLIBRARY_POSTFIX}
                     NO_FIND
    )
    unset(TFLITE_ENABLE_INSTALL CACHE)
    set(BUILD_SHARED_LIBS ON CACHE BOOL "" FORCE)
    unset(TFLITE_ENABLE_GPU CACHE)
    unset(TFLITE_ENABLE_RUY CACHE)
    unset(TFLITE_ENABLE_NNAPI CACHE)
    set(tensorflow-lite${TFLIBRARY_POSTFIX}_DIR ${tensorflow-lite${TFLIBRARY_POSTFIX}_BINARY_DIR} CACHE PATH "" FORCE)
    set(tensorflow-lite${TFLIBRARY_POSTFIX}_SOURCE_DIR ${tensorflow-lite_SOURCE_DIR} CACHE PATH "" FORCE)
endif()
