import QtQuick 2.9
import QtQuick.Window 2.2

Rectangle {
    id:root
    width: 220
    height: 260
    color: "#4A4A4A"

    Image {
        id: image
        source: "../images/pinwheel.png"
        horizontalAlignment: Image.AlignHCenter; width: root.width
        y:40
    }

    Text {
        id: text1
        text: qsTr("pinwheel")
        color: "white"
        horizontalAlignment: Text.AlignHCenter; width:root.width
        y:image.y+image.height
    }

}
