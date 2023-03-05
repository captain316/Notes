import QtQuick

Canvas{
    id:canvas
    width: 800;height: 450

    // initial start position
    property real lastX : width * Math.random();
    property real lastY : height * Math.random();
    property real hue : 0;

    property bool requestLine: false
    property bool requestBlank: false
    onPaint: {
        var ctx=getContext('2d')
        if(requestLine){
            line(ctx);
            requestLine=false;
        }
        if(requestBlank){
            blank(context);
            requestBlank=false;
        }
    }

    function line(context) {

        context.save();

        // scale with factor 0.9 around the center of canvas
        context.translate(canvas.width/2, canvas.height/2);
        context.scale(0.9, 0.9);
        context.translate(-canvas.width/2, -canvas.height/2);

        context.beginPath();
        context.lineWidth = 5 + Math.random() * 10;

        // our start position
        context.moveTo(lastX, lastY);

        // our new end position
        lastX = canvas.width * Math.random();
        lastY = canvas.height * Math.random();

        // random bezier curve, which ends on lastX, lastY
        context.bezierCurveTo(canvas.width * Math.random(),
                              canvas.height * Math.random(),
                              canvas.width * Math.random(),
                              canvas.height * Math.random(),
                              lastX, lastY);

        // glow effect
        hue = hue + 0.1 * Math.random();
        if(hue>1.0) hue-=1;
        context.strokeStyle = Qt.hsla(hue,0.5,0.5,1.0);

        // stroke the curve
        context.stroke();
        context.restore();
    }

    Component.onCompleted: {
        lineTimer.start()
        blankTimer.start()
    }

    // call line function every 50msecs
    Timer{
        id:lineTimer

        interval: 50
        repeat: true
        onTriggered: {
            canvas.requestPaint()
            requestLine=true
        }
    }

    function blank(context) {
        // makes the background 10% darker on each call
        context.fillStyle = Qt.rgba(0,0,0,0.1);
        context.fillRect(0, 0, canvas.width, canvas.height);
    }

    // call blank function every 50msecs
    Timer{
        id:blankTimer
        interval: 40
        repeat: true
        onTriggered: {
            canvas.requestPaint()
            requestBlank=true
        }
    }

}
