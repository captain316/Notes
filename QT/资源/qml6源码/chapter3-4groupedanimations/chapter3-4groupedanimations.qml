import QtQuick

Window {
    id:root
    width: 640
    height: 480
    visible: true
    title: qsTr("UFO")
    property int duration: 3000

    Image {
        source: "../images/background.png"
        anchors.fill: parent
    }

    ClickableImageV3{
        id:ufo
        x:20;y:root.height-height
        source: "../images/ufo.png"
        text:'UFO'
        onClicked: anim.restart()
    }

    ParallelAnimation/*SequentialAnimation*/{
        id:anim
        NumberAnimation{
            target:ufo
            properties: "y"
            from:root.height-ufo.height
            to:20
            duration: root.duration
        }

        NumberAnimation{
            target:ufo
            properties: "x"
            from:20
            to:500
            duration: root.duration
        }
    }
}
