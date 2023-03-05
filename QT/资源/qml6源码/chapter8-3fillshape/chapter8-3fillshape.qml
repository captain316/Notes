import QtQuick
import QtQuick.Shapes

Rectangle {
    width: 640
    height: 480

    Shape{
        ShapePath{
            strokeColor: 'darkGray'
            fillColor: 'orange'
            strokeWidth: 3

            fillRule: ShapePath.OddEvenFill

            PathPolyline{
                path: [
                    Qt.point(100, 20),
                    Qt.point(150, 180),
                    Qt.point( 20, 75),
                    Qt.point(180, 75),
                    Qt.point( 50, 180),
                    Qt.point(100, 20),
                ]

            }
        }
    }

    Shape{
        ShapePath{
            strokeColor: 'darkGray'
            fillColor: 'orange'
            strokeWidth: 3

            fillRule: ShapePath.WindingFill

            PathPolyline{
                path: [
                    Qt.point(100+200, 20),
                    Qt.point(150+200, 180),
                    Qt.point( 20+200, 75),
                    Qt.point(180+200, 75),
                    Qt.point( 50+200, 180),
                    Qt.point(100+200, 20),
                ]

            }
        }
    }
}
