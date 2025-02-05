
add_library(Qt5::QWaylandXCompositeGlxClientBufferIntegrationPlugin MODULE IMPORTED)


_populate_WaylandCompositor_plugin_properties(QWaylandXCompositeGlxClientBufferIntegrationPlugin RELEASE "wayland-graphics-integration-server/libqt-wayland-compositor-xcomposite-glx.so" FALSE)

list(APPEND Qt5WaylandCompositor_PLUGINS Qt5::QWaylandXCompositeGlxClientBufferIntegrationPlugin)
set_property(TARGET Qt5::WaylandCompositor APPEND PROPERTY QT_ALL_PLUGINS_wayland_graphics_integration_server Qt5::QWaylandXCompositeGlxClientBufferIntegrationPlugin)
set_property(TARGET Qt5::QWaylandXCompositeGlxClientBufferIntegrationPlugin PROPERTY QT_PLUGIN_TYPE "wayland-graphics-integration-server")
set_property(TARGET Qt5::QWaylandXCompositeGlxClientBufferIntegrationPlugin PROPERTY QT_PLUGIN_EXTENDS "")
set_property(TARGET Qt5::QWaylandXCompositeGlxClientBufferIntegrationPlugin PROPERTY QT_PLUGIN_CLASS_NAME "QWaylandXCompositeGlxClientBufferIntegrationPlugin")
