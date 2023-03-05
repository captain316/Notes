import QtQuick
import QtQuick.Shapes
Rectangle {
    width: 600
    height: 600

    Shape{
        anchors.centerIn: parent

        ShapePath{
            strokeColor: 'darkGray'
            fillColor: 'lightGray'
            strokeWidth: 3

            startX: -40;startY: 200
            PathArc{x:40;y:200;radiusX:200;radiusY:200;useLargeArc:true}
            PathLine{x:40;y:120}
            PathArc{x:-40;y:120;radiusX:120;radiusY:120;useLargeArc:true;direction: PathArc.Counterclockwise}
            PathLine{x:-40;y:200}

            PathMove{x:-20;y:80}
            PathArc{x:20;y:80;radiusX:20;radiusY:20}
            PathArc{x:-20;y:80;radiusX:20;radiusY:20}

            PathMove{x:-20;y:130}
            PathArc{x:20;y:130;radiusX:20;radiusY:20}
            PathArc{x:-20;y:130;radiusX:20;radiusY:20}

            PathMove{x:-20;y:180}
            PathArc{x:20;y:180;radiusX:20;radiusY:20}
            PathArc{x:-20;y:180;radiusX:20;radiusY:20}

            PathMove{x:-20;y:230}
            PathArc{x:20;y:230;radiusX:20;radiusY:20}
            PathArc{x:-20;y:230;radiusX:20;radiusY:20}
        }
    }
}
