cmake_minimum_required(VERSION 3.24)
project(main C)

set(IS_STATIC TRUE)

# Find GLib2. This is the recommended approach
find_package(PkgConfig REQUIRED)
# pkg-config --libs glib-2.0
pkg_check_modules(GLIB2 REQUIRED glib-2.0)

if(GLIB2_FOUND)
    message(STATUS "GLib2 found. Includes: ${GLIB2_INCLUDE_DIRS}, Libraries: ${GLIB2_LIBRARIES}")

    # Create an object library target for main.c
    add_library(main_objects OBJECT src/main.c)

    # Compile with GLib2 includes
    target_include_directories(main_objects PRIVATE ${GLIB2_INCLUDE_DIRS})


    # Optional: If you want to create the executable as well
    add_executable(${PROJECT_NAME} $<TARGET_OBJECTS:main_objects>)
    target_link_libraries(${PROJECT_NAME} ${GLIB2_LIBRARIES}) # Link when creating the executable

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
    message(FATAL_ERROR "GLib2 not found. Please install the development package.")
endif()