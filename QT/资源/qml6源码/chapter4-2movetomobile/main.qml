import QtQuick
import QtQuick.Controls
import Qt.labs.platform as Platform
import QtQuick.Controls.Material

ApplicationWindow {
    width: 320
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

//    header:ToolBar{
//        Flow{
//            anchors.fill: parent
//            ToolButton{
//                text:"打开"
//                icon.source: "images/open.png"
//                onClicked: fileOPenDialog.open()
//            }
//        }
//    }
    header:ToolBar{
        Material.background: Material.Orange
        ToolButton{
            icon.source: "images/baseline-menu-24px"
            onClicked: drawer.open()
        }
        Label{
            anchors.centerIn: parent
            text:'Image Viewer'
            font.pixelSize: 20
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

    Drawer{
        id:drawer

        width: parent.width/3*2
        height: parent.height

        ListView{
            anchors.fill:parent
            model:ListModel{
                ListElement{
                    text:'open...'
                    triggered:function(){fileOPenDialog.open();}
                }
                ListElement{
                    text:'About...'
                    triggered:function(){aboutDialog.open();}
                }
            }

            delegate: ItemDelegate{
                text:model.text
                highlighted: ListView.isCurrentItem
                onClicked: {
                    drawer.close()
                    model.triggered()
                }
            }
        }
    }

//    menuBar: MenuBar{
//        Menu{
//            title: "&File"
//            MenuItem{
//                text: "&Open..."
//                icon.source: "images/open.png"
//                onTriggered: fileOPenDialog.open()
//            }
//        }
//        Menu{
//            title: "&Help"
//            MenuItem{
//                text: "&About..."
//                onTriggered: aboutDialog.open()
//            }
//        }
//    }

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
