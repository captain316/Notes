import QtQuick

Item{
    id:it
    anchors.fill:parent
    property color color
    Rectangle{
        id:rect
        border.color: it.color
        color:Qt.rgba(0,0,0,0)
        anchors.fill:parent
    }
}

