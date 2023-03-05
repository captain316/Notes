import QtQuick

Rectangle{
    width: 240;height: 120

    Canvas{
        id:canvas
        x:10;y:10
        width: 100;height: 100
        onPaint: {
            var ctx=getContext('2d')
            var x=10+Math.random()*80
            var y=10+Math.random()*80
            ctx.globalAlpha=0.7
            ctx.fillStyle=Qt.hsla(Math.random(),0.5,0.5,1.0)
            ctx.beginPath()
            ctx.arc(x,y,x/10,0,360)
            ctx.closePath()
            ctx.fill()
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                var url=canvas.toDataURL('image/png')
                image.source=url
            }
        }
    }

    Image {
        id: image
        x:130;y:10
        width: 100;height: 100
    }

    Timer{
        interval: 1000
        running: true
        repeat: true
        onTriggered: canvas.requestPaint()
    }
}
