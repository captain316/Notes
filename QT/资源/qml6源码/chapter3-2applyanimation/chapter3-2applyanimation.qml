import QtQuick

Window {
    id:root
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")
    color:'gray'

    ClickableImageV2{
        id:qq1
        x:40;y:root.height-height
        source:"../images/qq.png"
        text:"animation on property"

        NumberAnimation on y{
            to:40;duration:3000
        }
    }

    ClickableImageV2{
        id:qq2
        x:40+qq1.width+20;y:root.height-height
        source:"../images/qq.png"
        text:"animation on property"

        Behavior on y{
            NumberAnimation{duration:3000}
        }

        onClicked: y=40
    }

    ClickableImageV2{
        id:qq3
        x:qq2.x+qq1.width+20;y:root.height-height
        source:"../images/qq.png"
        text:"animation on property"
       // onClicked: anim.restart()

        NumberAnimation{
            id:anim
            target:qq3
            from:root.height-qq3.height
            to:40;duration:3000
            property:"y"
            running:area.pressed
        }

        MouseArea{
            id:area
            anchors.fill: parent
        }
    }
}
