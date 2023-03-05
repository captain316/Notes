import QtQuick

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("layout")

    GreenSquare{
        //        BlueSquare{
        //            text: '(1)'
        //            anchors.fill: parent
        //            anchors.margins: 8
        //        }

        //        BlueSquare{
        //            text: '(2)'
        //            anchors.left: parent.left
        //            y:8
        //            anchors.margins: 8
        //        }

        //        BlueSquare{
        //            text: '(3)'
        //            anchors.left: parent.right
        //        }

        //        BlueSquare{
        //            id:blue1
        //            text: '(4-1)'
        //            //anchors.top: parent.top
        //            y:8
        //            anchors.horizontalCenter: parent.horizontalCenter
        //            anchors.margins: 8
        //            height: 25

        //        }
        //        BlueSquare{
        //            text: '(4-2)'
        //            //anchors.top: parent.top
        //            width: 75
        //            anchors.top: blue1.bottom
        //            anchors.horizontalCenter: parent.horizontalCenter
        //            anchors.margins: 8
        //            height: 25

        //        }

//        BlueSquare{
//            text: '(5)'
//            anchors.centerIn: parent
//        }

        BlueSquare{
            text: '(6)'
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenterOffset: -12
        }
    }
}
