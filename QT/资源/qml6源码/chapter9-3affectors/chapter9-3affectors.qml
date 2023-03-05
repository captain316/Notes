import QtQuick
import QtQuick.Particles

Rectangle {
    id: root
    width: 480; height: 250
    color: "#1f1f1f"

    ParticleSystem {
        id: particleSystem
    }

    Emitter {
        id: emitter
        anchors.fill: parent;
        system: particleSystem
        lifeSpan: 5000
        lifeSpanVariation: 1500
        size: 16

        velocity: AngleDirection {
            angle: 0
            angleVariation: 15
            magnitude: 100
            magnitudeVariation: 50
        }
    }

//    Age{
//        width: 240;height: 120
//        anchors.horizontalCenter: parent.horizontalCenter

//        system: particleSystem
//        lifeLeft: 1200
//        once: true
//        advancePosition: true
//        Rectangle{anchors.fill: parent;border.color: 'red';color:Qt.rgba(0,0,0,0)}
//    }

//    Attractor{
//        width: 240;height: 120
//        anchors.horizontalCenter: parent.horizontalCenter
//        pointX: 0;pointY:0
//        strength: 1.0

//        system: particleSystem
//        Rectangle{anchors.fill: parent;border.color: 'red';color:Qt.rgba(0,0,0,0)}
//    }

//        Friction{
//            width: 240;height: 120
//            anchors.horizontalCenter: parent.horizontalCenter
//            factor:0.8
//            threshold: 25
//            system: particleSystem
//            Rectangle{anchors.fill: parent;border.color: 'red';color:Qt.rgba(0,0,0,0)}
//        }

//    Gravity{
//        width: 240;height: 120
//        anchors.horizontalCenter: parent.horizontalCenter
//        magnitude: 50
//        angle: 90

//        system: particleSystem
//        Rectangle{anchors.fill: parent;border.color: 'red';color:Qt.rgba(0,0,0,0)}
//    }

//        Turbulence{
//            width: 240;height: 120
//            anchors.horizontalCenter: parent.horizontalCenter
//            strength: 100
//            system: particleSystem
//            Rectangle{anchors.fill: parent;border.color: 'red';color:Qt.rgba(0,0,0,0)}
//        }
    Wander{
        width: 240;height: 120
        anchors.horizontalCenter: parent.horizontalCenter
        affectedParameter: Wander.Position
        pace:200
        yVariance: 120
        //xVariance: 0
        system: particleSystem
        Rectangle{anchors.fill: parent;border.color: 'red';color:Qt.rgba(0,0,0,0)}
    }

    ImageParticle {
        source: "../images/bubble.png"
        system: particleSystem
    }
}
