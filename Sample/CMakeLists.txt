set(sample_sources
    main.cpp
    MainWindow.cpp
    MainWindow.h
    MainWindow.ui
    QGraphicsViewEc.cpp
    QGraphicsViewEc.h
    ress.qrc
)

if(APPLE)
    qt_add_executable(sample MACOSX_BUNDLE ${sample_sources})
elseif(WIN32)
    qt_add_executable(sample WIN32 ${sample_sources})
else()
    qt_add_executable(sample ${sample_sources})
endif()

set_target_properties(sample PROPERTIES OUTPUT_NAME "Sample")
target_include_directories(sample PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(sample PRIVATE QGVCore Qt6::Widgets)

install(TARGETS sample
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
