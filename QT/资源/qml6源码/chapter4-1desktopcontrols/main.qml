import QtQuick
import QtQuick.Controls
import Qt.labs.platform as Platform

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: qsTr("Image Viewer")

    background: Rectangle{
        color:'darkGray'
    }

    Image {
        id: image
        //source: "images/qq.png"
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        asynchronous: true
    }

    header:ToolBar{
        Flow{
            anchors.fill: parent
            ToolButton{
                text:"打开"
                icon.source: "images/open.png"
                onClicked: fileOPenDialog.open()
            }
        }
    }

    Platform.FileDialog{
        //folder:
        id:fileOPenDialog
        title:"选择图片"
        nameFilters:[
            "Images files(*.png *.jpg)","all files(*.*)"
        ]

        onAccepted:{
            image.source=fileOPenDialog.file
        }
    }

    menuBar: MenuBar{
        Menu{
            title: "&File"
            MenuItem{
                text: "&Open..."
                icon.source: "images/open.png"
                onTriggered: fileOPenDialog.open()
            }
        }
        Menu{
            title: "&Help"
            MenuItem{
                text: "&About..."
                onTriggered: aboutDialog.open()
            }
        }
    }

    Dialog{
        id:aboutDialog
        width: 300;height:150
        anchors.centerIn: parent
        title:"About"
        Label{
            anchors.fill: parent
            text:"AAAAAAAAAAA\nBBBBBBBBBBBBBB"
            horizontalAlignment: Text.AlignHCenter
        }
        standardButtons: Platform.StandardButton.Ok
    }
}
