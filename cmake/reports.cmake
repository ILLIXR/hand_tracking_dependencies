macro (report_found NAME VERSION)
    set(msg "Found ${NAME}")
    if(NOT "${VERSION}" STREQUAL "")
        set(msg "${msg}: ${VERSION}")
    endif()
    message(STATUS ${msg})
endmacro()

macro (report_build NAME)
    message(STATUS "${NAME} could not be found, it will be built from source")
endmacro()