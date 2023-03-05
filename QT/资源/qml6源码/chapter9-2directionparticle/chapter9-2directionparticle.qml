import QtQuick
import QtQuick.Particles

Rectangle{
    width: 400;height: 400
    id:root
    color: '#333'

    ParticleSystem{
        id:particlesystem
    }

    Emitter{
        system:particlesystem
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: 1;height: 1

        emitRate: 10
        lifeSpan: 5800
        lifeSpanVariation: 500
        size:16
        //        velocity: AngleDirection{
        //            angle:0
        //            angleVariation: 15
        //            magnitude: 100
        //            magnitudeVariation: 50
        //        }

        //        velocity: PointDirection{
        //            x:100;y:0
        //            xVariation: 0
        //            yVariation: 100/6
        //        }

//        velocity: TargetDirection{
//            targetX: 100;targetY:0
//            targetVariation: 100/6
//            magnitude: 100
//            magnitudeVariation: 50
//        }

        velocity: AngleDirection{
            angle:-45
            angleVariation: 0
            magnitude: 100
        }

        acceleration: AngleDirection{
            angle: 90
            magnitude: 25
        }

    }

    ImageParticle{
        source:"../images/bubble.png"
        system:particlesystem
    }
}
