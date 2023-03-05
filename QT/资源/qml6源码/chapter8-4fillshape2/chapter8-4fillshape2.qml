import QtQuick
import QtQuick.Shapes

Rectangle {
    width: 640
    height: 480
    Shape{
        ShapePath{
            strokeColor: 'darkGray'
            fillColor: 'lightgreen'
            strokeWidth: 3

            startX: 20;startY: 140

            PathLine{x:180;y:140}
            PathArc{
                x:20;y:140
                direction: PathArc.Counterclockwise
                radiusX: 80;radiusY: 80
            }
        }
    }
    Shape{
        ShapePath{
            strokeColor: 'darkGray'
            fillGradient: LinearGradient{
                x1:50;y1:300
                x2:150;y2:280
                GradientStop{position:0.0;color:'lightgreen'}
                GradientStop{position:0.7;color:'yellow'}
                GradientStop{position:1.0;color:'darkgreen'}
            }

            strokeWidth: 3

            startX: 20;startY: 340

            PathLine{x:180;y:340}
            PathArc{
                x:20;y:340
                direction: PathArc.Counterclockwise
                radiusX: 80;radiusY: 80
            }
        }
    }
    Shape{
        ShapePath{
            strokeColor: 'darkGray'
            fillGradient: ConicalGradient{
                centerX: 300;centerY: 100
                angle: 45
                GradientStop{position:0.0;color:'lightgreen'}
                GradientStop{position:0.7;color:'yellow'}
                GradientStop{position:1.0;color:'darkgreen'}
            }

            strokeWidth: 3

            startX: 220;startY: 140

            PathLine{x:380;y:140}
            PathArc{
                x:220;y:140
                direction: PathArc.Counterclockwise
                radiusX: 80;radiusY: 80
            }
        }
    }
    Shape{
        ShapePath{
            strokeColor: 'darkGray'
            fillGradient: RadialGradient{
                centerX: 300;centerY: 280;centerRadius: 60
                focalX: centerX;focalY:centerY;focalRadius: 10

                GradientStop{position:0.0;color:'lightgreen'}
                GradientStop{position:0.7;color:'yellow'}
                GradientStop{position:1.0;color:'darkgreen'}
            }

            strokeWidth: 3

            startX: 220;startY: 340

            PathLine{x:380;y:340}
            PathArc{
                x:220;y:340
                direction: PathArc.Counterclockwise
                radiusX: 80;radiusY: 80
            }
        }
    }
}
