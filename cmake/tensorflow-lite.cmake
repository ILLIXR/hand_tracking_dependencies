set(TFLIBRARY_POSTFIX ${LIBRARY_POSTFIX} CACHE STRING "" FORCE)
if(ENABLE_GPU)
    set(TFLIBRARY_POSTFIX "${TFLIBRARY_POSTFIX}-gpu" CACHE STRING "" FORCE)
endif()
set(tfl_name tensorflow-lite${TFLIBRARY_POSTFIX})
find_package(${tfl_name} QUIET CONFIG)
if(${tfl_name}_FOUND)
    report_found(tensorflow-lite "")
else()
    ht_fetch_git(NAME ${tfl_name}
                 REPO https://github.com/ILLIXR/tensorflow-lite
                 TAG 5473ac0f929c415450f950c1c01f57cae11c2ca4
                 NO_OVERRIDE
    )
    set(TFLITE_ENABLE_INSTALL ON CACHE BOOL "" FORCE)
    set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
    set(TFLITE_ENABLE_GPU ${ENABLE_GPU} CACHE BOOL "" FORCE)
    set(TFLITE_ENABLE_RUY ON CACHE BOOL "" FORCE)
    set(TFLITE_ENABLE_NNAPI ON CACHE BOOL "" FORCE)

    ht_configure_target(NAME ${tfl_name}
                        NO_FIND
    )
    unset(TFLITE_ENABLE_INSTALL CACHE)
    set(BUILD_SHARED_LIBS ON CACHE BOOL "" FORCE)
    unset(TFLITE_ENABLE_GPU CACHE)
    unset(TFLITE_ENABLE_RUY CACHE)
    unset(TFLITE_ENABLE_NNAPI CACHE)
    set(tensorflow-lite${TFLIBRARY_POSTFIX}_BINARY_DIR ${tensorflow-lite_BINARY_DIR} CACHE PATH "" FORCE)
    set(${tfl_name}_DIR ${tensorflow-lite${TFLIBRARY_POSTFIX}_BINARY_DIR} CACHE PATH "" FORCE)
    set(${tfl_name}_SOURCE_DIR ${tensorflow-lite_SOURCE_DIR} CACHE} CACHE PATH "" FORCE)
    unset(tensorflow-lite_BINARY_DIR CACHE)
    unset(tensorflow-lite_SOURCE_DIR CACHE)
endif()
