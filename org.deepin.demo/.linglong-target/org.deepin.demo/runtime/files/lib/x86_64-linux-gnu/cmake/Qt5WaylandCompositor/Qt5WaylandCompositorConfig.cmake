if (CMAKE_VERSION VERSION_LESS 3.1.0)
    message(FATAL_ERROR "Qt 5 WaylandCompositor module requires at least CMake version 3.1.0")
endif()

get_filename_component(_qt5WaylandCompositor_install_prefix "${CMAKE_CURRENT_LIST_DIR}/../../../../" ABSOLUTE)

# For backwards compatibility only. Use Qt5WaylandCompositor_VERSION instead.
set(Qt5WaylandCompositor_VERSION_STRING 5.15.7)

set(Qt5WaylandCompositor_LIBRARIES Qt5::WaylandCompositor)

macro(_qt5_WaylandCompositor_check_file_exists file)
    if(NOT EXISTS "${file}" )
        message(FATAL_ERROR "The imported target \"Qt5::WaylandCompositor\" references the file
   \"${file}\"
but this file does not exist.  Possible reasons include:
* The file was deleted, renamed, or moved to another location.
* An install or uninstall procedure did not complete successfully.
* The installation package was faulty and contained
   \"${CMAKE_CURRENT_LIST_FILE}\"
but not all the files it references.
")
    endif()
endmacro()


macro(_populate_WaylandCompositor_target_properties Configuration LIB_LOCATION IMPLIB_LOCATION
      IsDebugAndRelease)
    set_property(TARGET Qt5::WaylandCompositor APPEND PROPERTY IMPORTED_CONFIGURATIONS ${Configuration})

    set(imported_location "${_qt5WaylandCompositor_install_prefix}/lib/x86_64-linux-gnu/${LIB_LOCATION}")
    _qt5_WaylandCompositor_check_file_exists(${imported_location})
    set(_deps
        ${_Qt5WaylandCompositor_LIB_DEPENDENCIES}
    )
    set(_static_deps
    )

    set_target_properties(Qt5::WaylandCompositor PROPERTIES
        "IMPORTED_LOCATION_${Configuration}" ${imported_location}
        "IMPORTED_SONAME_${Configuration}" "libQt5WaylandCompositor.so.5"
        # For backward compatibility with CMake < 2.8.12
        "IMPORTED_LINK_INTERFACE_LIBRARIES_${Configuration}" "${_deps};${_static_deps}"
    )
    set_property(TARGET Qt5::WaylandCompositor APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 "${_deps}"
    )


endmacro()

if (NOT TARGET Qt5::WaylandCompositor)

    set(_Qt5WaylandCompositor_OWN_INCLUDE_DIRS "${_qt5WaylandCompositor_install_prefix}/include/x86_64-linux-gnu/qt5/" "${_qt5WaylandCompositor_install_prefix}/include/x86_64-linux-gnu/qt5/QtWaylandCompositor")
    set(Qt5WaylandCompositor_PRIVATE_INCLUDE_DIRS
        "${_qt5WaylandCompositor_install_prefix}/include/x86_64-linux-gnu/qt5/QtWaylandCompositor/5.15.7"
        "${_qt5WaylandCompositor_install_prefix}/include/x86_64-linux-gnu/qt5/QtWaylandCompositor/5.15.7/QtWaylandCompositor"
    )

    foreach(_dir ${_Qt5WaylandCompositor_OWN_INCLUDE_DIRS})
        _qt5_WaylandCompositor_check_file_exists(${_dir})
    endforeach()

    # Only check existence of private includes if the Private component is
    # specified.
    list(FIND Qt5WaylandCompositor_FIND_COMPONENTS Private _check_private)
    if (NOT _check_private STREQUAL -1)
        foreach(_dir ${Qt5WaylandCompositor_PRIVATE_INCLUDE_DIRS})
            _qt5_WaylandCompositor_check_file_exists(${_dir})
        endforeach()
    endif()

    set(Qt5WaylandCompositor_INCLUDE_DIRS ${_Qt5WaylandCompositor_OWN_INCLUDE_DIRS})

    set(Qt5WaylandCompositor_DEFINITIONS -DQT_WAYLANDCOMPOSITOR_LIB)
    set(Qt5WaylandCompositor_COMPILE_DEFINITIONS QT_WAYLANDCOMPOSITOR_LIB)
    set(_Qt5WaylandCompositor_MODULE_DEPENDENCIES "Quick;Gui;Qml;Core")


    set(Qt5WaylandCompositor_OWN_PRIVATE_INCLUDE_DIRS ${Qt5WaylandCompositor_PRIVATE_INCLUDE_DIRS})

    set(_Qt5WaylandCompositor_FIND_DEPENDENCIES_REQUIRED)
    if (Qt5WaylandCompositor_FIND_REQUIRED)
        set(_Qt5WaylandCompositor_FIND_DEPENDENCIES_REQUIRED REQUIRED)
    endif()
    set(_Qt5WaylandCompositor_FIND_DEPENDENCIES_QUIET)
    if (Qt5WaylandCompositor_FIND_QUIETLY)
        set(_Qt5WaylandCompositor_DEPENDENCIES_FIND_QUIET QUIET)
    endif()
    set(_Qt5WaylandCompositor_FIND_VERSION_EXACT)
    if (Qt5WaylandCompositor_FIND_VERSION_EXACT)
        set(_Qt5WaylandCompositor_FIND_VERSION_EXACT EXACT)
    endif()

    set(Qt5WaylandCompositor_EXECUTABLE_COMPILE_FLAGS "")

    foreach(_module_dep ${_Qt5WaylandCompositor_MODULE_DEPENDENCIES})
        if (NOT Qt5${_module_dep}_FOUND)
            find_package(Qt5${_module_dep}
                5.15.7 ${_Qt5WaylandCompositor_FIND_VERSION_EXACT}
                ${_Qt5WaylandCompositor_DEPENDENCIES_FIND_QUIET}
                ${_Qt5WaylandCompositor_FIND_DEPENDENCIES_REQUIRED}
                PATHS "${CMAKE_CURRENT_LIST_DIR}/.." NO_DEFAULT_PATH
            )
        endif()

        if (NOT Qt5${_module_dep}_FOUND)
            set(Qt5WaylandCompositor_FOUND False)
            return()
        endif()

        list(APPEND Qt5WaylandCompositor_INCLUDE_DIRS "${Qt5${_module_dep}_INCLUDE_DIRS}")
        list(APPEND Qt5WaylandCompositor_PRIVATE_INCLUDE_DIRS "${Qt5${_module_dep}_PRIVATE_INCLUDE_DIRS}")
        list(APPEND Qt5WaylandCompositor_DEFINITIONS ${Qt5${_module_dep}_DEFINITIONS})
        list(APPEND Qt5WaylandCompositor_COMPILE_DEFINITIONS ${Qt5${_module_dep}_COMPILE_DEFINITIONS})
        list(APPEND Qt5WaylandCompositor_EXECUTABLE_COMPILE_FLAGS ${Qt5${_module_dep}_EXECUTABLE_COMPILE_FLAGS})
    endforeach()
    list(REMOVE_DUPLICATES Qt5WaylandCompositor_INCLUDE_DIRS)
    list(REMOVE_DUPLICATES Qt5WaylandCompositor_PRIVATE_INCLUDE_DIRS)
    list(REMOVE_DUPLICATES Qt5WaylandCompositor_DEFINITIONS)
    list(REMOVE_DUPLICATES Qt5WaylandCompositor_COMPILE_DEFINITIONS)
    list(REMOVE_DUPLICATES Qt5WaylandCompositor_EXECUTABLE_COMPILE_FLAGS)

    # It can happen that the same FooConfig.cmake file is included when calling find_package()
    # on some Qt component. An example of that is when using a Qt static build with auto inclusion
    # of plugins:
    #
    # Qt5WidgetsConfig.cmake -> Qt5GuiConfig.cmake -> Qt5Gui_QSvgIconPlugin.cmake ->
    # Qt5SvgConfig.cmake -> Qt5WidgetsConfig.cmake ->
    # finish processing of second Qt5WidgetsConfig.cmake ->
    # return to first Qt5WidgetsConfig.cmake ->
    # add_library cannot create imported target Qt5::Widgets.
    #
    # Make sure to return early in the original Config inclusion, because the target has already
    # been defined as part of the second inclusion.
    if(TARGET Qt5::WaylandCompositor)
        return()
    endif()

    set(_Qt5WaylandCompositor_LIB_DEPENDENCIES "Qt5::Quick;Qt5::Gui;Qt5::Qml;Qt5::Core")


    add_library(Qt5::WaylandCompositor SHARED IMPORTED)


    set_property(TARGET Qt5::WaylandCompositor PROPERTY
      INTERFACE_INCLUDE_DIRECTORIES ${_Qt5WaylandCompositor_OWN_INCLUDE_DIRS})
    set_property(TARGET Qt5::WaylandCompositor PROPERTY
      INTERFACE_COMPILE_DEFINITIONS QT_WAYLANDCOMPOSITOR_LIB)

    set_property(TARGET Qt5::WaylandCompositor PROPERTY INTERFACE_QT_ENABLED_FEATURES wayland-compositor-quick)
    set_property(TARGET Qt5::WaylandCompositor PROPERTY INTERFACE_QT_DISABLED_FEATURES )

    # Qt 6 forward compatible properties.
    set_property(TARGET Qt5::WaylandCompositor
                 PROPERTY QT_ENABLED_PUBLIC_FEATURES
                 wayland-compositor-quick)
    set_property(TARGET Qt5::WaylandCompositor
                 PROPERTY QT_DISABLED_PUBLIC_FEATURES
                 )
    set_property(TARGET Qt5::WaylandCompositor
                 PROPERTY QT_ENABLED_PRIVATE_FEATURES
                 wayland-server;wayland-datadevice;wayland-dmabuf-client-buffer;wayland-dmabuf-server-buffer;wayland-drm-egl-server-buffer;wayland-egl;wayland-shm-emulation-server-buffer;wayland-vulkan-server-buffer;xcomposite-egl;xcomposite-glx)
    set_property(TARGET Qt5::WaylandCompositor
                 PROPERTY QT_DISABLED_PRIVATE_FEATURES
                 wayland-brcm;wayland-layer-integration-vsp2;wayland-libhybris-egl-server-buffer)

    set_property(TARGET Qt5::WaylandCompositor PROPERTY INTERFACE_QT_PLUGIN_TYPES "wayland-graphics-integration-server;wayland-hardware-layer-integration")

    set(_Qt5WaylandCompositor_PRIVATE_DIRS_EXIST TRUE)
    foreach (_Qt5WaylandCompositor_PRIVATE_DIR ${Qt5WaylandCompositor_OWN_PRIVATE_INCLUDE_DIRS})
        if (NOT EXISTS ${_Qt5WaylandCompositor_PRIVATE_DIR})
            set(_Qt5WaylandCompositor_PRIVATE_DIRS_EXIST FALSE)
        endif()
    endforeach()

    if (_Qt5WaylandCompositor_PRIVATE_DIRS_EXIST)
        add_library(Qt5::WaylandCompositorPrivate INTERFACE IMPORTED)
        set_property(TARGET Qt5::WaylandCompositorPrivate PROPERTY
            INTERFACE_INCLUDE_DIRECTORIES ${Qt5WaylandCompositor_OWN_PRIVATE_INCLUDE_DIRS}
        )
        set(_Qt5WaylandCompositor_PRIVATEDEPS)
        foreach(dep ${_Qt5WaylandCompositor_LIB_DEPENDENCIES})
            if (TARGET ${dep}Private)
                list(APPEND _Qt5WaylandCompositor_PRIVATEDEPS ${dep}Private)
            endif()
        endforeach()
        set_property(TARGET Qt5::WaylandCompositorPrivate PROPERTY
            INTERFACE_LINK_LIBRARIES Qt5::WaylandCompositor ${_Qt5WaylandCompositor_PRIVATEDEPS}
        )

        # Add a versionless target, for compatibility with Qt6.
        if(NOT "${QT_NO_CREATE_VERSIONLESS_TARGETS}" AND NOT TARGET Qt::WaylandCompositorPrivate)
            add_library(Qt::WaylandCompositorPrivate INTERFACE IMPORTED)
            set_target_properties(Qt::WaylandCompositorPrivate PROPERTIES
                INTERFACE_LINK_LIBRARIES "Qt5::WaylandCompositorPrivate"
            )
        endif()
    endif()

    _populate_WaylandCompositor_target_properties(RELEASE "libQt5WaylandCompositor.so.5.15.7" "" FALSE)




    # In Qt 5.15 the glob pattern was relaxed to also catch plugins not literally named Plugin.
    # Define QT5_STRICT_PLUGIN_GLOB or ModuleName_STRICT_PLUGIN_GLOB to revert to old behavior.
    if (QT5_STRICT_PLUGIN_GLOB OR Qt5WaylandCompositor_STRICT_PLUGIN_GLOB)
        file(GLOB pluginTargets "${CMAKE_CURRENT_LIST_DIR}/Qt5WaylandCompositor_*Plugin.cmake")
    else()
        file(GLOB pluginTargets "${CMAKE_CURRENT_LIST_DIR}/Qt5WaylandCompositor_*.cmake")
    endif()

    macro(_populate_WaylandCompositor_plugin_properties Plugin Configuration PLUGIN_LOCATION
          IsDebugAndRelease)
        set_property(TARGET Qt5::${Plugin} APPEND PROPERTY IMPORTED_CONFIGURATIONS ${Configuration})

        set(imported_location "${_qt5WaylandCompositor_install_prefix}/lib/x86_64-linux-gnu/qt5/plugins/${PLUGIN_LOCATION}")
        _qt5_WaylandCompositor_check_file_exists(${imported_location})
        set_target_properties(Qt5::${Plugin} PROPERTIES
            "IMPORTED_LOCATION_${Configuration}" ${imported_location}
        )

    endmacro()

    if (pluginTargets)
        foreach(pluginTarget ${pluginTargets})
            include(${pluginTarget})
        endforeach()
    endif()



    _qt5_WaylandCompositor_check_file_exists("${CMAKE_CURRENT_LIST_DIR}/Qt5WaylandCompositorConfigVersion.cmake")
endif()

# Add a versionless target, for compatibility with Qt6.
if(NOT "${QT_NO_CREATE_VERSIONLESS_TARGETS}" AND TARGET Qt5::WaylandCompositor AND NOT TARGET Qt::WaylandCompositor)
    add_library(Qt::WaylandCompositor INTERFACE IMPORTED)
    set_target_properties(Qt::WaylandCompositor PROPERTIES
        INTERFACE_LINK_LIBRARIES "Qt5::WaylandCompositor"
    )
endif()
