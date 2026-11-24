# Find Graphviz's cgraph and gvc development libraries.
#
# Result variables:
#   Graphviz_FOUND
#   Graphviz_VERSION
#   Graphviz_VERSION_MAJOR
#   Graphviz_INCLUDE_DIRS
#   Graphviz_LIBRARIES
#
# Imported target:
#   Graphviz::Graphviz

include(FindPackageHandleStandardArgs)

set(GRAPHVIZ_INCLUDE_DIRS "")
set(GRAPHVIZ_LIBRARIES "")
set(GRAPHVIZ_VERSION "")

if(UNIX)
    find_package(PkgConfig QUIET)
    if(PkgConfig_FOUND)
        pkg_check_modules(PC_GRAPHVIZ QUIET IMPORTED_TARGET libcgraph)
        pkg_check_modules(PC_GVC QUIET IMPORTED_TARGET libgvc)
    endif()

    if(PC_GRAPHVIZ_FOUND AND PC_GVC_FOUND)
        set(GRAPHVIZ_INCLUDE_DIRS
            ${PC_GRAPHVIZ_INCLUDE_DIRS}
            ${PC_GVC_INCLUDE_DIRS}
        )
        list(REMOVE_DUPLICATES GRAPHVIZ_INCLUDE_DIRS)
        set(GRAPHVIZ_LIBRARIES
            PkgConfig::PC_GRAPHVIZ
            PkgConfig::PC_GVC
        )
        set(GRAPHVIZ_VERSION "${PC_GRAPHVIZ_VERSION}")
    endif()
elseif(WIN32)
    if(NOT DEFINED GRAPHVIZ_ROOT)
        set(GRAPHVIZ_ROOT "" CACHE PATH "Root directory of the Graphviz installation")
    endif()
    if(NOT GRAPHVIZ_ROOT AND DEFINED ENV{GRAPHVIZ_ROOT})
        set(GRAPHVIZ_ROOT "$ENV{GRAPHVIZ_ROOT}")
    endif()
    if(NOT GRAPHVIZ_ROOT)
        set(GRAPHVIZ_ROOT "C:/Program Files/Graphviz")
    endif()

    find_path(GRAPHVIZ_INCLUDE_DIR
        NAMES gvc.h
        HINTS
            "${GRAPHVIZ_ROOT}/include/graphviz"
            "${GRAPHVIZ_ROOT}/include"
    )
    find_library(GRAPHVIZ_GVC_LIBRARY
        NAMES gvc libgvc
        HINTS
            "${GRAPHVIZ_ROOT}/lib/release"
            "${GRAPHVIZ_ROOT}/lib/release/lib"
            "${GRAPHVIZ_ROOT}/lib"
    )
    find_library(GRAPHVIZ_CGRAPH_LIBRARY
        NAMES cgraph libcgraph
        HINTS
            "${GRAPHVIZ_ROOT}/lib/release"
            "${GRAPHVIZ_ROOT}/lib/release/lib"
            "${GRAPHVIZ_ROOT}/lib"
    )
    find_library(GRAPHVIZ_CDT_LIBRARY
        NAMES cdt libcdt
        HINTS
            "${GRAPHVIZ_ROOT}/lib/release"
            "${GRAPHVIZ_ROOT}/lib/release/lib"
            "${GRAPHVIZ_ROOT}/lib"
    )
    find_file(GRAPHVIZ_VERSION_HEADER
        NAMES graphviz_version.h
        HINTS
            "${GRAPHVIZ_INCLUDE_DIR}"
            "${GRAPHVIZ_INCLUDE_DIR}/graphviz"
            "${GRAPHVIZ_ROOT}/include/graphviz"
            "${GRAPHVIZ_ROOT}/include"
    )

    if(GRAPHVIZ_VERSION_HEADER)
        file(STRINGS "${GRAPHVIZ_VERSION_HEADER}" _GRAPHVIZ_VERSION_DEFINITION
            REGEX "PACKAGE_VERSION")
        string(REGEX MATCH [=[PACKAGE_VERSION[ \t]+"([^"]+)"]=]
            _GRAPHVIZ_VERSION_MATCH "${_GRAPHVIZ_VERSION_DEFINITION}")
        if(_GRAPHVIZ_VERSION_MATCH)
            set(GRAPHVIZ_VERSION "${CMAKE_MATCH_1}")
        endif()
    endif()

    if(GRAPHVIZ_INCLUDE_DIR AND EXISTS "${GRAPHVIZ_INCLUDE_DIR}/cgraph.h")
        set(GRAPHVIZ_INCLUDE_DIRS "${GRAPHVIZ_INCLUDE_DIR}")
    endif()
    if(GRAPHVIZ_GVC_LIBRARY AND GRAPHVIZ_CGRAPH_LIBRARY AND GRAPHVIZ_CDT_LIBRARY)
        set(GRAPHVIZ_LIBRARIES
            "${GRAPHVIZ_GVC_LIBRARY}"
            "${GRAPHVIZ_CGRAPH_LIBRARY}"
            "${GRAPHVIZ_CDT_LIBRARY}"
        )
    endif()
endif()

if(GRAPHVIZ_VERSION)
    string(REGEX MATCH "^[0-9]+" GRAPHVIZ_VERSION_MAJOR "${GRAPHVIZ_VERSION}")
endif()

find_package_handle_standard_args(Graphviz
    REQUIRED_VARS
        GRAPHVIZ_INCLUDE_DIRS
        GRAPHVIZ_LIBRARIES
        GRAPHVIZ_VERSION
        GRAPHVIZ_VERSION_MAJOR
    VERSION_VAR GRAPHVIZ_VERSION
    REASON_FAILURE_MESSAGE
        "Graphviz 2.38 or newer, including its development headers and libraries, is required."
)

set(Graphviz_INCLUDE_DIRS "${GRAPHVIZ_INCLUDE_DIRS}")
set(Graphviz_LIBRARIES "${GRAPHVIZ_LIBRARIES}")
set(Graphviz_VERSION "${GRAPHVIZ_VERSION}")
set(Graphviz_VERSION_MAJOR "${GRAPHVIZ_VERSION_MAJOR}")

if(Graphviz_FOUND AND NOT TARGET Graphviz::Graphviz)
    add_library(Graphviz::Graphviz INTERFACE IMPORTED)
    if(UNIX)
        target_link_libraries(Graphviz::Graphviz INTERFACE ${GRAPHVIZ_LIBRARIES})
    else()
        target_include_directories(Graphviz::Graphviz
            INTERFACE "${GRAPHVIZ_INCLUDE_DIR}"
        )
        target_link_libraries(Graphviz::Graphviz
            INTERFACE ${GRAPHVIZ_LIBRARIES}
        )
    endif()
endif()

mark_as_advanced(
    GRAPHVIZ_INCLUDE_DIR
    GRAPHVIZ_GVC_LIBRARY
    GRAPHVIZ_CGRAPH_LIBRARY
    GRAPHVIZ_CDT_LIBRARY
    GRAPHVIZ_VERSION_HEADER
)
