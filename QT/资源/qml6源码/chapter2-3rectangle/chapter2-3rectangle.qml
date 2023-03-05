import QtQuick

Window {
    width: 300
    height: 480
    visible: true
    title: qsTr("Rect")

    Rectangle{
        id:rect1
        x:12;y:12
        width:76;height:96
        color:'lightsteelblue'
    }

    Rectangle{
        id:rect2
        x:112;y:12
        width:76;height:96
        border.color:'lightsteelblue'
        border.width: 4
        radius: 20
    }

    Rectangle{
        id:rect3
        x:212;y:12
        width:76;height:96
        gradient: Gradient{
            GradientStop{position:0.0;color:'lightsteelblue'}
            GradientStop{position:1.0;color:'slategray'}
        }

        border.color:'lightsteelblue'
        border.width: 4
        radius: 20
    }
}
