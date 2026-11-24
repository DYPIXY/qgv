# Graphviz dependencies for qmake builds.
DEFINES += WITH_CGRAPH
INCLUDEPATH += private

unix {
 CONFIG += link_pkgconfig
 PKGCONFIG += libcdt libgvc libcgraph
 GRAPHVIZ_VERSION = $$system(pkg-config --modversion libcgraph)
 GRAPHVIZ_MAJOR_VERSION = $$section(GRAPHVIZ_VERSION, ., 0, 0)
 !isEmpty(GRAPHVIZ_MAJOR_VERSION) {
  DEFINES += GRAPHVIZ_VERSION=$$GRAPHVIZ_MAJOR_VERSION
 }
}
win32 {
 #Configure Windows GraphViz path here :
 GRAPHVIZ_PATH = "D:/Program Files (x86)/Graphviz/"
 DEFINES += WIN32_DLL
 DEFINES += GVDLL
 DEFINES += GRAPHVIZ_VERSION=2
 INCLUDEPATH += $$GRAPHVIZ_PATH/include/graphviz
 LIBS += -L$$GRAPHVIZ_PATH/lib/release/lib -lgvc -lcgraph -lcdt
}
macx {
 # Enable pkg-config (pkg-config is disabled by default in the Qt package for mac)
 QT_CONFIG -= no-pkg-config
 # pkg-config location if your brew installation is standard
 PKG_CONFIG = /usr/local/bin/pkg-config
}
