cmake_minimum_required(VERSION 3.24)
project(main C)

set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)

set(IS_STATIC TRUE)

# Find GLib2. This is the recommended approach
find_package(PkgConfig REQUIRED)
# pkg-config --libs glib-2.0
pkg_check_modules(GLIB2 REQUIRED glib-2.0)
pkg_check_modules(GMODULE2 REQUIRED gmodule-2.0)
pkg_check_modules(GOBJECT2 REQUIRED gobject-2.0)
pkg_check_modules(GIO2 REQUIRED gio-2.0)

if(GLIB2_FOUND)
    message(STATUS "GLib-2 found. Includes: ${GLIB2_INCLUDE_DIRS}, Libraries: ${GLIB2_LIBRARIES}")
    message(STATUS "GModule-2 Libraries: ${GMODULE2_LIBRARIES}")
    message(STATUS "GObject-2 Libraries: ${GOBJECT2_LIBRARIES}")
    message(STATUS "GIO-2 Libraries: ${GIO2_LIBRARIES}")

    # Create an object library target for main.c
    add_library(main_objects OBJECT src/main.c)

    # Compile with GLib2 includes
    # Compile with GLib2 includes
    target_include_directories(main_objects PRIVATE
        ${GLIB2_INCLUDE_DIRS}
        ${GMODULE2_INCLUDE_DIRS}
        ${GOBJECT2_INCLUDE_DIRS}
        ${GIO2_INCLUDE_DIRS}
    )


    # Optional: If you want to create the executable as well
    add_executable(${PROJECT_NAME} $<TARGET_OBJECTS:main_objects>)
    
    # Link when creating the executable
    target_link_libraries(${PROJECT_NAME}
        ${GLIB2_LIBRARIES}
        ${GMODULE2_LIBRARIES}
        ${GOBJECT2_LIBRARIES}
        ${GIO2_LIBRARIES}
    )

    if (IS_STATIC)
        # Set static linking flags
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static")
        set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "-static")

        # Static linking of libgcc and libstdc++ (important for fully static binaries on Linux/GCC)
        if(CMAKE_COMPILER_IS_GNUCC)
            set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static-libgcc -static-libstdc++")
            set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "-static-libgcc -static-libstdc++")
        endif()

        # Static linking for clang
        if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
            set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static")
            set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "-static")
        endif()
    endif()

    # Create custom target to copy object files
    add_custom_target(copy_main_objects
        COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_OBJECTS:main_objects> ${CMAKE_CURRENT_BINARY_DIR}
        DEPENDS main_objects
    )
else()
    message(FATAL_ERROR "GLib2 not found. Please install the development package: libglib2.0-dev or glib2-devel")
endif()