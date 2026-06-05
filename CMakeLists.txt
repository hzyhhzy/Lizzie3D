cmake_minimum_required(VERSION 3.24)

project(lizzie3d LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Quick3D)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(lizzie3d
    src/main.cpp
    src/fileio.cpp
    src/fileio.h
)

qt_add_qml_module(lizzie3d
    URI Lizzie3D
    VERSION 1.0
    QML_FILES
        qml/Main.qml
)

target_link_libraries(lizzie3d
    PRIVATE
        Qt6::Quick
        Qt6::Quick3D
)
