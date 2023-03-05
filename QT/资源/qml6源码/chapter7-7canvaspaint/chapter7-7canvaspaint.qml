import QtQuick

Rectangle{
    width: 500;height: 500

    Row{
        id:colorTools
        anchors{
            horizontalCenter: parent.horizontalCenter
            top:parent.top
            topMargin: 8
        }
        property color paintColor:"blue"
        Repeater{
            model:['blue','gray','yellow','green']
            ColorSquare{
                color:modelData
                down: parent.paintColor===color
                onClicked: parent.paintColor=color
            }
        }
    }

    Canvas{
        id:canvas
        anchors{
            left:parent.left
            right:parent.right
            top:colorTools.bottom
            bottom: parent.bottom
            margins:8
        }
        property real lastY
        property real lastX
        property color color:colorTools.paintColor
        onPaint: {
            var ctx=getContext('2d')
            ctx.lineWidth=1.5
            ctx.strokeStyle=canvas.color
            ctx.beginPath()
            ctx.moveTo(lastX,lastY)
            lastX=area.mouseX;lastY=area.mouseY
            ctx.lineTo(lastX,lastY)
            ctx.stroke()
        }
        MouseArea{
            id:area
            anchors.fill: parent
            onPressed: {canvas.lastX=mouseX;canvas.lastY=mouseY}
            onPositionChanged: canvas.requestPaint()
        }
    }
}
