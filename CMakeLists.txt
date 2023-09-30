cmake_minimum_required(VERSION 3.22)

project(main C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED TRUE)

add_executable(${PROJECT_NAME})

target_sources(${PROJECT_NAME}  PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}/src/main.c
)

target_include_directories(${PROJECT_NAME} PUBLIC
        ${CMAKE_CURRENT_LIST_DIR}
        ${CMAKE_CURRENT_LIST_DIR}/src
)
