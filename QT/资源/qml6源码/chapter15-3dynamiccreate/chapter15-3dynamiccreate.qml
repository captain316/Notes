import QtQuick
import "create-component.js" as ImageCreator

Item {
    id:root
    width: 640
    height: 480

    function createItem() {
        Qt.createQmlObject(
                    "import QtQuick 2.5; Rectangle { x: 100; y: 100; width: 100; height: 100; color: \"blue\" }",
                    root,
                    "dynamicItem"
                    )
    }

    Component.onCompleted: createItem()
    //  Component.onCompleted: ImageCreator.createImageObject();

}
