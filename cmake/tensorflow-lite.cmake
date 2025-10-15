set(TFLIBRARY_POSTFIX ${LIBRARY_POSTFIX})
if(ENABLE_GPU)
    set(TFLIBRARY_POSTFIX "${TFLIBRARY_POSTFIX}-gpu")
endif()
find_package(tensorflow-lite${TFLIBRARY_POSTFIX} QUIET CONFIG)
if(tensorflow-lite${TFLIBRARY_POSTFIX}_FOUND)
    report_found(tensorflow-lite "")
else()
    fetch_git(NAME tensorflow-lite
              REPO https://github.com/ILLIXR/tensorflow-lite.git
              TAG 3b7e49238d61aa903cefa64721cb3a27b1472d72
    )
    #[[
    report_build(tensorflow-lite)
    FetchContent_Declare(tensorflow-lite
                         GIT_REPOSITORY https://github.com/ILLIXR/tensorflow-lite
                         GIT_TAG 02367633eedb5a2598d65bee8e9f554b17ddad66
                         GIT_PROGRESS TRUE
                         OVERRIDE_FIND_PACKAGE
    )]]

    FetchContent_GetProperties(tensorflow-lite)
    if(NOT tensorflow-lite_POPULATED)
        set(TFLITE_ENABLE_INSTALL ON)
        set(BUILD_SHARED_LIBS OFF)
        set(TFLITE_ENABLE_GPU ${ENABLE_GPU})
        set(TFLITE_ENABLE_RUY ON)
        set(TFLITE_ENABLE_NNAPI ON)
        FetchContent_Populate(tensorflow-lite)
        add_dependencies(flatbuffers-flatc flatbuffers)
        #configure_target(tensorflow-lite)
        if (TARGET absl_ext)
            add_dependencies(absl_ext)
            #target_include_directories(?? PUBLIC ${abseil_SOURCE_DIR})
            message("TFL DEP: absl_ext")
        endif()

        if (TARGET fft2d_ext)
            add_dependencies(fft2d_ext)
            message("TFL DEP: fft2d_ext")
        endif()
        if (TARGET eight_bit_int_gemm)
            add_dependencies(eight_bit_int_gemm)
            message("TFL DEP: eight_bit_int_gemm")
        endif()
        if (TARGET NEON_2_SSE)
            add_dependencies(NEON_2_SSE)
            message("TFL DEP: NEON_2_SSE")
        endif()
        if (TARGET farmhash)
            add_dependencies(farmhash)
            message("TFL DEP: farmhash")
        endif()
        if (TARGET tfl-XNNPACK${LIBRARY_POSTFIX})
            add_dependencies(tfl-XNNPACK${LIBRARY_POSTFIX})
            message("TFL DEP: tfl-XNNPACK${LIBRARY_POSTFIX}")
        endif()

        if (TARGET pthreadpool)
            add_dependencies(pthreadpool)
            message("TFL DEP: pthreadpool")
        endif()
message("DDD ${tensorflow-lite_SOURCE_DIR} ${tensorflow-lite_BINARY_DIR}")
        add_subdirectory(${tensorflow-lite_SOURCE_DIR} ${tensorflow-lite_BINARY_DIR})
        #FetchContent_MakeAvailable(tensorflow-lite)
        unset(TFLITE_ENABLE_INSTALL)
        unset(BUILD_SHARED_LIBS)
        unset(TFLITE_ENABLE_GPU)
        unset(TFLITE_ENABLE_RUY)
        unset(TFLITE_ENABLE_NNAPI)
    endif()

endif()

function(print_all_targets DIR)
    get_property(TGTS DIRECTORY "${DIR}" PROPERTY BUILDSYSTEM_TARGETS)
    foreach(TGT IN LISTS TGTS)
        message(STATUS "Target: ${TGT}")
        # TODO: Do something about it
    endforeach()

    get_property(SUBDIRS DIRECTORY "${DIR}" PROPERTY SUBDIRECTORIES)
    foreach(SUBDIR IN LISTS SUBDIRS)
        print_all_targets("${SUBDIR}")
    endforeach()
endfunction()

print_all_targets(.)
