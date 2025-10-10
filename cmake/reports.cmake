macro (report_found NAME VERSION)
    set(msg "Found ${NAME}")
    if(NOT "${VERSION}" STREQUAL "")
        set(msg "${msg}: ${VERSION}")
    endif()
    message(STATUS ${msg})
endmacro()

macro (report_build NAME)
    message(STATUS "${NAME} could not be found, it will be built from source")
    message(STATUS "    downloading...")
endmacro()

function(fetch_git)
    set(options PATCH RECURSE)
    set(oneValueArgs NAME REPO TAG SUBDIR)
    cmake_parse_arguments(fetch "${options}" "${oneValueArgs}" "" ${ARGV})

    report_build(${fetch_NAME})
    if (${fetch_PATCH})
        if (${fetch_SUBDIR})
            FetchContent_Declare(${fetch_NAME}
                                 GIT_REPOSITORY ${fetch_REPO}
                                 GIT_TAG ${fetch_TAG}
                                 GIT_PROGRESS TRUE
                                 GIT_SUBMODULES_RECURSE ${fetch_RECURSE}
                                 SOURCE_SUBDIR ${fetch_SUBDIR}
                                 PATCH_COMMAND ${CMAKE_CURRENT_LIST_DIR}/../do_patch.sh -p ${CMAKE_CURRENT_LIST_DIR}/${fetch_NAME}/${fetch_NAME}.patch
                                 OVERRIDE_FIND_PACKAGE
            )
        else()
            FetchContent_Declare(${fetch_NAME}
                                 GIT_REPOSITORY ${fetch_REPO}
                                 GIT_TAG ${fetch_TAG}
                                 GIT_SUBMODULES_RECURSE ${fetch_RECURSE}
                                 GIT_PROGRESS TRUE
                                 PATCH_COMMAND ${CMAKE_CURRENT_LIST_DIR}/../do_patch.sh -p ${CMAKE_CURRENT_LIST_DIR}/${fetch_NAME}/${fetch_NAME}.patch
                                 OVERRIDE_FIND_PACKAGE
            )
        endif()
    else()
        if (${fetch_SUBDIR})
            FetchContent_Declare(${fetch_NAME}
                                 GIT_REPOSITORY ${fetch_REPO}
                                 GIT_TAG ${fetch_TAG}
                                 GIT_SUBMODULES_RECURSE ${fetch_RECURSE}
                                 GIT_PROGRESS TRUE
                                 SOURCE_SUBDIR ${fetch_SUBDIR}
                                 OVERRIDE_FIND_PACKAGE
            )
        else()
            FetchContent_Declare(${fetch_NAME}
                                 GIT_REPOSITORY ${fetch_REPO}
                                 GIT_TAG ${fetch_TAG}
                                 GIT_SUBMODULES_RECURSE ${fetch_RECURSE}
                                 GIT_PROGRESS TRUE
                                 OVERRIDE_FIND_PACKAGE
            )
        endif()
    endif()
    message(STATUS "        complete.")
endfunction()

function(fetch_url)
    set(options PATCH)
    set(oneValueArgs NAME SRC_URL HASH)
    cmake_parse_arguments(fetch "${options}" "${oneValueArgs}" "" ${ARGV})
    report_build(${fetch_NAME})
    if (${fetch_PATCH})
        FetchContent_Declare(${fetch_NAME}
                             URL ${fetch_SRC_URL}
                             URL_HASH ${fetch_HASH}
                             PATCH_COMMAND ${CMAKE_CURRENT_LIST_DIR}/../do_patch.sh -p ${CMAKE_CURRENT_LIST_DIR}/${fetch_NAME}/${fetch_NAME}.patch
                             OVERRIDE_FIND_PACKAGE
        )
    else()
        FetchContent_Declare(${fetch_NAME}
                             URL ${fetch_SRC_URL}
                             URL_HASH ${fetch_HASH}
                             OVERRIDE_FIND_PACKAGE
        )
    endif()
    message(STATUS "        complete.")
endfunction()

macro(configure_target NAME)
    message(STATUS "Configuring ${NAME}")
    FetchContent_MakeAvailable(${NAME})
    message(STATUS "   ${NAME} Configuration complete")
endmacro()
