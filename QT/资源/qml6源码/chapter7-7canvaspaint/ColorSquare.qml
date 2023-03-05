import QtQuick
import QtQuick.Controls

Button {
    width: 100;height: 100
    property alias color:bg.color
    Rectangle{
        id:bg

        width: 80;height: 80
        opacity: 0.7

        anchors.centerIn: parent
    }
}
