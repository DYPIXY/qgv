cmake_minimum_required(VERSION 3.21)
project(QGVCore VERSION 1.0 LANGUAGES C CXX)

include(GNUInstallDirs)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Network Widgets)
qt_standard_project_setup()

add_subdirectory(QGVCore)
add_subdirectory(Sample)
