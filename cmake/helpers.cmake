function(fetch_git)
    set(options PATCH RECURSE NO_OVERRIDE NO_SHALLOW)
    set(oneValueArgs NAME REPO TAG SUBDIR OVERRIDE_UPDATE OVERRIDE_BUILD)
    cmake_parse_arguments(fetch "${options}" "${oneValueArgs}" "" ${ARGV})

    if(NOT fetch_NAME)
        message(FATAL_ERROR "Name must be specified in calls to fetch_git.")
    elseif(NOT fetch_REPO)
        message(FATAL_ERROR "REPO must be specified in calls to fetch_git.")
    elseif(NOT fetch_TAG)
        message(FATAL_ERROR "TAG must be specified in calls to fetch_git.")
    endif()

    set(FCD_ARGS
        GIT_REPOSITORY ${fetch_REPO}
        GIT_TAG ${fetch_TAG}
        GIT_PROGRESS TRUE
        GIT_SUBMODULES_RECURSE ${fetch_RECURSE}
    )

    if(fetch_SUBDIR)
        list(APPEND FCD_ARGS SOURCE_SUBDIR ${fetch_SUBDIR})
    endif()

    if(NOT fetch_NO_OVERRIDE)
        list(APPEND FCD_ARGS OVERRIDE_FIND_PACKAGE)
    endif()

    if(fetch_PATCH)
        list(APPEND FCD_ARGS PATCH_COMMAND ${CMAKE_CURRENT_LIST_DIR}/../do_patch.sh -p ${CMAKE_CURRENT_LIST_DIR}/${fetch_NAME}/${fetch_NAME}.patch)
    endif()

    if(fetch_OVERRIDE_UPDATE)
        list(APPEND FCD_ARGS UPDATE_COMMAND ${fetch_OVERRIDE_UPDATE})
    endif()

    if(fetch_OVERRIDE_BUILD)
        list(APPEND FCD_ARGS BUILD_COMMAND ${fetch_OVERRIDE_BUILD})
    endif()

    if(fetch_NO_SHALLOW)
        list(APPEND FCD_ARGS GIT_SHALLOW FALSE)
    endif()

    report_build(${fetch_NAME})
    FetchContent_Declare(${fetch_NAME}
                         ${FCD_ARGS}
    )
endfunction()

function(fetch_url)
    set(options PATCH NO_OVERRIDE)
    set(oneValueArgs NAME SRC_URL HASH)
    cmake_parse_arguments(fetch "${options}" "${oneValueArgs}" "" ${ARGV})

    if(NOT fetch_NAME)
        message(FATAL_ERROR "Name must be specified in calls to fetch_git.")
    elseif(NOT fetch_SRC_URL)
        message(FATAL_ERROR "SRC_URL must be specified in calls to fetch_git.")
    elseif(NOT fetch_HASH)
        message(FATAL_ERROR "HASH must be specified in calls to fetch_git.")
    endif()

    set(FCD_ARGS
        URL ${fetch_SRC_URL}
        URL_HASH ${fetch_HASH}
    )

    if(NOT fetch_NO_OVERRIDE)
        list(APPEND FCD_ARGS OVERRIDE_FIND_PACKAGE)
    endif()

    if(fetch_PATCH)
        list(APPEND FCD_ARGS PATCH_COMMAND ${CMAKE_CURRENT_LIST_DIR}/../do_patch.sh -p ${CMAKE_CURRENT_LIST_DIR}/${fetch_NAME}/${fetch_NAME}.patch)
    endif()

    report_build(${fetch_NAME})

    FetchContent_Declare(${fetch_NAME}
                         ${FCD_ARGS}
    )
endfunction()

macro(configure_target)
    set(options MATCH_BUILD_TYPE NO_FIND USE_PKG_CONF)
    set(oneValueArgs NAME VERSION PKG_CONF)
    cmake_parse_arguments(_config "${options}" "${oneValueArgs}" "" ${ARGV})

    if(NOT _config_NAME)
        message(FATAL_ERROR "Name must be specified in calls to fetch_git.")
    endif()

    if(_config_USE_PKG_CONF AND NOT _config_PKG_CONF)
        set(${_config_PKG_CONF} ${_config_NAME})
    endif()

    message(STATUS "Configuring ${_config_NAME}")
    if (NOT _config_MATCH_BUILD_TYPE)
        set(CMAKE_BUILD_TYPE Release)
    endif()

    FetchContent_MakeAvailable(${_config_NAME})

    if (NOT _config_MATCH_BUILD_TYPE)
        set(CMAKE_BUILD_TYPE ${ILLIXR_BUILD_TYPE})
    endif()

    message(STATUS "   ${_config_NAME} Configuration complete")
    if (NOT _config_NO_FIND)
        if (${_config_VERSION})
            if (${_config_USE_PKG_CONF})
                pkg_check_modules(${_config_NAME} REQUIRED ${_config_PKG_CONF}>=$_config_VERSION})
            else()
                find_package(${_config_NAME} ${_config_VERSION} REQUIRED)
            endif()
        else()
            if (${_config_USE_PKG_CONF})
                pkg_check_modules(${_config_NAME} REQUIRED ${_config_PKG_CONF})
            else()
                find_package(${_config_NAME} REQUIRED)
            endif()
        endif()
    endif()
endmacro()
