import QtQuick

Canvas{
    id:canvas
    width: 330;height: 150

    onPaint: {
        var ctx=getContext('2d');

        ctx.save()
        ctx.strokeStyle='red'
        ctx.beginPath()
        ctx.moveTo(210,10)
        ctx.lineTo(310,10)
        ctx.lineTo(260,75)
        ctx.closePath()
        ctx.stroke()
        ctx.clip()
        ctx.drawImage("../images/soccer_ball.png",200,10)
        ctx.restore()

        ctx.drawImage("../images/soccer_ball.png",10,10)
    }

    Component.onCompleted: {
        loadImage("../images/soccer_ball.png")
    }
}
