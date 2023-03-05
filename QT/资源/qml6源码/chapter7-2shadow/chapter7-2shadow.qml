import QtQuick

Canvas{
    id:canvas

    width: 400;height:200

    onPaint: {
        var ctx=getContext("2d")
        ctx.fillStyle = "#333"
        ctx.fillRect(0,0,canvas.width,canvas.height)

        //阴影设置
        ctx.shadowColor='lightblue'
        ctx.shadowOffsetX=2
        ctx.shadowOffsetY=2
        ctx.shadowBlur=10

        //渲染文字
        ctx.font='bold 80px sans-serif';
        ctx.fillStyle="lightgreen"
        ctx.fillText("Canvas!",50,180)
    }
}
