import QtQuick

Rectangle{
    width: 50; height: 50
    color:'blue'
    border.color: Qt.lighter(color)

    property alias text: label.text
    Text {
        id: label
        text: qsTr("text")
        color:'white'
        anchors.centerIn: parent
    }
}
