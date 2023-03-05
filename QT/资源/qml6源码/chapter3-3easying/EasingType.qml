import QtQuick

Item {
    id:root
    width: 100;height: 100
    property alias title: label.text
    property alias source:image.source
    property var easingType;
    signal clicked
    Image{
        id:image
        anchors.fill:parent
        source: "../images/curves/"+title+".png"

        Text {
            id: label
            text: qsTr("text")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            color:'white'
        }
    }

    MouseArea{
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
