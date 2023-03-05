import QtQuick
import QtQuick.Shapes
Rectangle{
    id:root
    width: 600;height: 400

    Shape{
        ShapePath{
            strokeColor: 'darkgray'
            strokeWidth: 3
            startX: 20;startY: 70
            PathLine{
                x:180;y:130
            }
        }

        ShapePath{
            strokeColor: 'darkgray'
            strokeWidth: 3

            PathPolyline{
                path: [
                    Qt.point(220,100),
                    Qt.point(260, 20),
                    Qt.point(300, 170),
                    Qt.point(340, 60),
                    Qt.point(380, 100)
                ]
            }
        }

        ShapePath{
            strokeColor: 'darkgray'
            strokeWidth: 3
            startX: 420;startY: 100
            PathArc{
                x:580;y:180;radiusX: 120;radiusY:120;
            }
        }

        ShapePath{
            strokeColor: 'darkgray'
            strokeWidth: 3
            startX: 20;startY: 300
            PathQuad{
                x:180;y:300;
                controlX: 160;controlY: 250
            }
        }

        ShapePath{
            strokeColor: 'darkgray'
            strokeWidth: 3
            startX: 220;startY: 300
            PathCubic{
                x:380;y:300;
                control1X: 260;control1Y: 250
                control2X: 360;control2Y: 350
            }
        }

        ShapePath{
            strokeColor: 'darkgray'
            strokeWidth: 3
            startX: 420;startY: 300

            PathCurve { x: 460; y: 220; }
            PathCurve { x: 500; y: 370 }
            PathCurve { x: 540; y: 270 }
            PathCurve { x: 580; y: 300 }
        }
    }
}
