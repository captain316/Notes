cmake_minimum_required(VERSION 3.16)

project(chapter4-3shared VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)
find_package(Qt6 REQUIRED COMPONENTS QuickControls2)

qt_add_executable(appchapter4-3shared 
    main.cpp
    icon.rc
)

qt_add_qml_module(appchapter4-3shared 
    URI chapter4-3shared 
    VERSION 1.0

    QML_FILES main.qml ImageViewerWindow.qml +android/main.qml
    RESOURCES images
)

set_target_properties(appchapter4-3shared PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_compile_definitions(appchapter4-3shared 
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(appchapter4-3shared 
    PRIVATE Qt6::Quick)
target_link_libraries(appchapter4-3shared PRIVATE Qt6::QuickControls2)
