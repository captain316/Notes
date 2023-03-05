import QtQuick

Item {
    id:root
    width: container.childrenRect.width
    height: container.childrenRect.height
    property alias source: image.source
    property alias text: label.text
    signal clicked

    Column{
        id:container
        Image{
            id:image
        }

        Text {
            id: label
            width: image.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            color:'white'
        }
    }


    MouseArea{
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
