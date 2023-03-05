import QtQuick

Image{
    id:root
    source:"../images/background.png"
    property int padding: 40
    property bool running: false
    Image{
        id:qq
        source:"../images/qq.png"
        x:root.padding;y:(root.height-height)/2

        NumberAnimation on x{
            to:root.width-qq.width-root.padding
            duration: 3000
            running:root.running
        }

        RotationAnimator on rotation{
            to:360
            duration: 3000
            running:root.running
        }
    }
    OpacityAnimator on opacity{
        target: qq
        to:0
        duration: 3000
        running:root.running
    }

    MouseArea{
        anchors.fill: parent
        onClicked: root.running = true
    }
}
