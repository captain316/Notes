cmake_minimum_required(VERSION 3.16)

project(chapter4-4nestedscreens VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)
find_package(Qt6 REQUIRED COMPONENTS QuickControls2)

qt_add_executable(appchapter4-4nestedscreens
    main.cpp
)

qt_add_qml_module(appchapter4-4nestedscreens
    URI chapter4-4nestedscreens
    VERSION 1.0
    QML_FILES main.qml Home.qml Profile.qml About.qml EditProfile.qml
    RESOURCES images/le.ico
)

set_target_properties(appchapter4-4nestedscreens PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_compile_definitions(appchapter4-4nestedscreens
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(appchapter4-4nestedscreens
    PRIVATE Qt6::Quick)
target_link_libraries(appchapter4-4nestedscreens PRIVATE Qt6::QuickControls2)
