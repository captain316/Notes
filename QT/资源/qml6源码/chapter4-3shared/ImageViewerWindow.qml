import QtQuick
import QtQuick.Controls
import Qt.labs.platform as Platform

ApplicationWindow {
    function openFileDialog() { fileOPenDialog.open(); }
    function openAboutDialog() { aboutDialog.open(); }

    visible: true
    title: qsTr("Image Viewer")

    background: Rectangle {
        color: "darkGray"
    }

    Image {
        id: image
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        asynchronous: true
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
