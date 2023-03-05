import QtQuick
import "../common"
Column{
    height: 160
    spacing:2
    //    Repeater{
    ////        model:1000
    //        model: ["Enterprise", "Columbia", "Challenger",
    //            "Discovery", "Endeavour", "Atlantis"]

    //        /*delegate:*/BlueBox{
    //            //required property int index
    //            width: 160;height: 30
    //            text: modelData+'('+index+')'
    //        }
    //        //onItemAdded: console.log("item"+index+"added")
    //    }

    Repeater{
        model: ListModel {
            ListElement { name: "Mercury"; surfaceColor: "gray" }
            ListElement { name: "Venus"; surfaceColor: "yellow" }
            ListElement { name: "Earth"; surfaceColor: "green" }
            ListElement { name: "Mars"; surfaceColor: "orange" }
            ListElement { name: "Jupiter"; surfaceColor: "orange" }
            ListElement { name: "Saturn"; surfaceColor: "yellow" }
            ListElement { name: "Uranus"; surfaceColor: "lightBlue" }
            ListElement { name: "Neptune"; surfaceColor: "darkBlue" }
        }
        delegate: BlueBox{
            required property string name
            required property color surfaceColor

            width:160;height:30
            text:name
            radius: 3

            Rectangle{
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 4
                width: 16;height:16;radius: 8
                color:parent.surfaceColor
            }
        }
    }
}
