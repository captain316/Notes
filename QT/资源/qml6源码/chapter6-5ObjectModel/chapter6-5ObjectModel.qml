import QtQuick

Rectangle {
    width: 320
    height: 320

    gradient: Gradient {
        GradientStop { position: 0.0; color: "#f6f6f6" }
        GradientStop { position: 1.0; color: "#d7d7d7" }
    }

    ListView{
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5

        model: itemModel
    }

    ObjectModel{
        id:itemModel

        Rectangle{height:60;width:80;color:'blue'}
        Rectangle{height:20;width:300;color:'lightgreen'
            Text {
                anchors.centerIn: parent
                text: qsTr("text")
            }
        }
        Rectangle{height:40;width:80;radius:10;color:'gray'}
    }
}
