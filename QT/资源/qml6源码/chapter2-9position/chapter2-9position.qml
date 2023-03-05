import QtQuick

//DarkSquare{
//    id:root
//    width: 120;height: 240

//    Column{
//        anchors.centerIn: parent
//        spacing: 10

//        RedSquare{}
//        GreenSquare{width: 96}
//        BlueSquare{}
//    }
//}

//BrightSquare{
//    id:root
//    width: 400;height: 120

//    Row{
//        anchors.centerIn: parent
//        spacing: 10

//        RedSquare{}
//        GreenSquare{width: 96}
//        BlueSquare{}
//    }
//}

//BrightSquare{
//    id:root
//    width: 400;height: 160

//    Grid{
//        anchors.centerIn: parent
//        spacing: 20
//        rows:2
//        columns:3
//        RedSquare{}
//        GreenSquare{}
//        BlueSquare{}
//        RedSquare{}
//        GreenSquare{}
//        BlueSquare{}
//    }
//}

//BrightSquare{
//    id:root
//    width: 400;height: 160

//    Flow{
//        anchors.fill: parent
//        anchors.margins: 20
//        spacing: 20
//        RedSquare{}
//        GreenSquare{}
//        BlueSquare{}
//        RedSquare{}
//        GreenSquare{}
//        BlueSquare{}
//    }
//}

DarkSquare{
    id:root
    width: 252;height: 252
    property var colorArray:["#00bde3", "#67c111", "#ea7025"]

    Grid{//columns默认值为4
        anchors.centerIn:  parent
        anchors.margins: 8
        spacing: 4

        //columns: 5
        Repeater{
            model:16
            Rectangle{
                id:rect
                //required property int index
                property int colorIndex: Math.floor(Math.random()*3)
                color:root.colorArray[colorIndex]
                width: 56;height:56

                Text {
                    anchors.centerIn: parent
                    text:"Cell"+/*parent.index*/rect.Positioner.index
                    color:'white'
                }
            }
        }
    }
}

