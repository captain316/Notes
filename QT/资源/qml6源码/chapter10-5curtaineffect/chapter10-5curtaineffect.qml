import QtQuick

Item {
    id: root
    width: background.width; height: background.height


    Image {
        id: background
        anchors.centerIn: parent
        source: '../images/background.png'
    }

    CurtainEffect {
        id: curtain
        anchors.fill: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: curtain.open = !curtain.open
    }
}
