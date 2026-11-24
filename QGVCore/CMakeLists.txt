list(PREPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../cmake/modules")
find_package(Graphviz 2.38 REQUIRED)

qt_add_library(QGVCore SHARED
    QGVEdge.cpp
    QGVEdge.h
    QGVNode.cpp
    QGVNode.h
    QGVScene.cpp
    QGVScene.h
    QGVSubGraph.cpp
    QGVSubGraph.h
    private/QGVCore.cpp
    private/QGVCore.h
    private/QGVEdgePrivate.cpp
    private/QGVEdgePrivate.h
    private/QGVGraphPrivate.cpp
    private/QGVGraphPrivate.h
    private/QGVGvcPrivate.cpp
    private/QGVGvcPrivate.h
    private/QGVNodePrivate.cpp
    private/QGVNodePrivate.h
    qgv.h
)

target_compile_definitions(QGVCore PRIVATE
    QGVCORE_LIB
    GRAPHVIZ_VERSION=${Graphviz_VERSION_MAJOR}
)

target_link_libraries(QGVCore PUBLIC
    Qt6::Core
    Qt6::Gui
    Qt6::Network
    Qt6::Widgets
)
target_link_libraries(QGVCore PRIVATE Graphviz::Graphviz)

if(WIN32)
    target_compile_definitions(QGVCore PRIVATE WIN32_DLL GVDLL)
endif()

target_include_directories(QGVCore
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/private
)

install(TARGETS QGVCore
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    FRAMEWORK DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
