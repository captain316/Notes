import QtQuick

Canvas{
    id:root

    width: 200;height: 200

    onPaint: {
        var ctx=getContext("2d")
        ctx.lineWidth=4
        ctx.strokeStyle='blue'

        ctx.fillStyle='steelblue'

        ctx.beginPath()
        ctx.moveTo(50,50)
        ctx.lineTo(150,50)
        ctx.lineTo(150,150)
        ctx.lineTo(50,150)
        ctx.closePath()
        ctx.fill()
        ctx.stroke()

        ctx.fillRect(20,20,80,80)
        ctx.clearRect(30,30,60,60)
        ctx.strokeRect(20,20,40,40)

        var gradient = ctx.createLinearGradient(0,0,0,root.height)
        gradient.addColorStop(0,'blue')
        gradient.addColorStop(0.5,'lightblue')

        ctx.fillStyle=gradient
        ctx.fillRect(50,50,100,100)
        ctx.fillRect(100,0,100,100)
        ctx.fillRect(0,100,100,100)
    }
}
