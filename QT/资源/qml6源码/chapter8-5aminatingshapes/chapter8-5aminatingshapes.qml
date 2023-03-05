import QtQuick
import QtQuick.Shapes

Rectangle {
    id: root
    width: 600
    height: 600

    Shape {
        anchors.centerIn: parent

        ShapePath {
            id:shapePath
            property real t:0.0

            NumberAnimation on t{from:0.0;to:1.0;duration:500;loops:Animation.Infinite;running:true}


            strokeWidth: 3
            strokeColor: "darkGray"
            fillColor: "lightGray"

            startX: -40; startY: 200

            // The circle

            PathArc { x: 40; y: 200; radiusX: 200; radiusY: 200; useLargeArc: true }
            PathLine { x: 40; y: 120 }
            PathArc { x: -40; y: 120; radiusX: 120; radiusY: 120; useLargeArc: true; direction: PathArc.Counterclockwise }
            PathLine { x: -40; y: 200 }

            // The dots

            PathMove { x: -20+(1.0-shapePath.t)*20; y: 80+shapePath.t*50 }
            PathArc { x: 20-(1.0-shapePath.t)*20; y: 80+shapePath.t*50; radiusX: 20*shapePath.t; radiusY: 20*shapePath.t; useLargeArc: true }
            PathArc { x: -20+(1.0-shapePath.t)*20; y: 80+shapePath.t*50; radiusX: 20*shapePath.t; radiusY: 20*shapePath.t; useLargeArc: true }

            PathMove { x: -20; y: 130+shapePath.t*50 }
            PathArc { x: 20; y: 130+shapePath.t*50; radiusX: 20; radiusY: 20; useLargeArc: true }
            PathArc { x: -20; y: 130+shapePath.t*50; radiusX: 20; radiusY: 20; useLargeArc: true }

            PathMove { x: -20; y: 180+shapePath.t*50 }
            PathArc { x: 20; y: 180+shapePath.t*50; radiusX: 20; radiusY: 20; useLargeArc: true }
            PathArc { x: -20; y: 180+shapePath.t*50; radiusX: 20; radiusY: 20; useLargeArc: true }

            PathMove { x: -20+shapePath.t*20; y: 230+shapePath.t*50 }
            PathArc { x: 20-shapePath.t*20; y: 230+shapePath.t*50; radiusX: 20*(1.0-shapePath.t); radiusY: 20*(1.0-shapePath.t); useLargeArc: true }
            PathArc { x: -20+shapePath.t*20; y: 230+shapePath.t*50; radiusX: 20*(1.0-shapePath.t); radiusY: 20*(1.0-shapePath.t); useLargeArc: true }
        }
    }
}
