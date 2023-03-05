import QtQuick
import Qt.labs.qmlmodels

TableView{
    width: 400
    height: 400

    columnSpacing:2
    rowSpacing:2

    model:TableModel{
        TableModelColumn{display:"name"}
        TableModelColumn{display:"color"}
       // TableModelColumn{display:"x"}

        rows: [
            {"color":"black","name":"cat"},
            {"name":"cat","color":"white"},
            {"color":"black","name":"dog"},
            {"color":"black","name":"pig"}
        ]
    }

    delegate: Rectangle{
        implicitHeight: 50
        implicitWidth: 100
        border.width: 1

        Text {
            text:display
            anchors.centerIn: parent
        }
    }
}
