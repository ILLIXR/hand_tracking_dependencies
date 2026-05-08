set(TFLIBRARY_POSTFIX ${LIBRARY_POSTFIX})
if(ENABLE_GPU)
    set(TFLIBRARY_POSTFIX "${TFLIBRARY_POSTFIX}-gpu")
endif()
find_package(tensorflow-lite${TFLIBRARY_POSTFIX} QUIET CONFIG)
if(tensorflow-lite${TFLIBRARY_POSTFIX}_FOUND)
    report_found(tensorflow-lite "")
else()
    fetch_git(NAME tensorflow-lite
              REPO https://github.com/ILLIXR/tensorflow-lite
              TAG 892dc20d59a894ed72b55bc2be756e0989bdc657
    )
    set(TFLITE_ENABLE_INSTALL ON CACHE BOOL "" FORCE)
    set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
    set(TFLITE_ENABLE_GPU ${ENABLE_GPU} CACHE BOOL "" FORCE)
    set(TFLITE_ENABLE_RUY ON CACHE BOOL "" FORCE)
    set(TFLITE_ENABLE_NNAPI ON CACHE BOOL "" FORCE)

    configure_target(NAME tensorflow-lite)

    unset(TFLITE_ENABLE_INSTALL CACHE)
    set(BUILD_SHARED_LIBS ON CACHE BOOL "" FORCE)
    unset(TFLITE_ENABLE_GPU CACHE)
    unset(TFLITE_ENABLE_RUY CACHE)
    unset(TFLITE_ENABLE_NNAPI CACHE)

endif()
