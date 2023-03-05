import QtQuick

Canvas{
    id:root
    width: 600;height: 400

    property var operation : [
        'source-over', 'source-in', 'source-over',
        'source-atop', 'destination-over', 'destination-in',
        'destination-out', 'destination-atop', 'lighter',
        'copy', 'xor', 'qt-clear', 'qt-destination',
        'qt-multiply', 'qt-screen', 'qt-overlay', 'qt-darken',
        'qt-lighten', 'qt-color-dodge', 'qt-color-burn',
        'qt-hard-light', 'qt-soft-light', 'qt-difference', 'qt-exclusion'
    ]


    onPaint: {
        var ctx=getContext('2d')
        ctx.fillStyle='lightblue'
        ctx.globalCompositeOperation='xor'

//        for(var i=0;i<40;i++){
//            ctx.beginPath()
//            ctx.arc(Math.random()*500,Math.random()*400,20,0,2*Math.PI)
//            ctx.closePath()
//            ctx.fill()
//        }
        for(var i=0;i<operation.length;i++){
            var dx=Math.floor(i%6)*100
            var dy=Math.floor(i/6)*100

            ctx.save()
            ctx.fillStyle='lightblue'
            ctx.fillRect(10+dx,10+dy,60,60)
            ctx.globalCompositeOperation=root.operation[i]
            ctx.globalAlpha=0.7
            ctx.beginPath()
            ctx.arc(60+dx,60+dy,30,0,2*Math.PI)
            ctx.closePath()
            ctx.fill()
            ctx.restore()
        }
    }
}
