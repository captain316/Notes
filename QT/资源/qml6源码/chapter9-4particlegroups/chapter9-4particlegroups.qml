import QtQuick
import QtQuick.Particles

Rectangle {
    id: root
    width: 480; height: 240
    color: "#1F1F1F"
    property bool tracer: true

    ParticleSystem{
        id:particlesystem
    }
    Emitter{
        id:rocketEmitter
        anchors.bottom: root.bottom
        width: root.width;height: 40

        system: particlesystem
        group: 'rocket'
        emitRate:2
        maximumEmitted: 4
        lifeSpan: 4800
        lifeSpanVariation: 400
        size:32
        velocity: AngleDirection{
            angle:270;magnitude: 150;magnitudeVariation: 10
        }
        acceleration: AngleDirection{
            angle:90;magnitude: 50
        }
        Tracer{color:'red';visible: root.tracer}
    }
    TrailEmitter{
        id:somkeEitter
        system: particlesystem
        emitHeight: 1
        emitWidth: 4
        group: 'smoke'
        follow:'rocket'
        emitRatePerParticle: 64
        lifeSpan: 200
        size:16
        sizeVariation: 4
        endSize: 0
        velocity: AngleDirection{
            angle:90;magnitude: 100;angleVariation: 5
        }
    }

    Friction{
        groups: ['rocket']
        anchors.top:parent.top
        width: root.width;height: 80
        system: particlesystem
        threshold: 5
        factor: 0.9
    }

    Turbulence{
        groups: ['rocket']
        anchors.bottom: root.bottom
        width: root.width;height: 160
        system: particlesystem
        strength: 25
        Tracer{color:'green';visible: root.tracer}
    }

    GroupGoal{
        id:rocketChanger
        anchors.top: root.top
        width: root.width;height: 80
        system: particlesystem
        groups: ['rocket']
        goalState: 'explosion'
        jump: true
        Tracer{color:'blue';visible: root.tracer}
    }

    ParticleGroup{
        name:'explosion'
        system: particlesystem

        TrailEmitter{
            id:explosionEmitter
            group: 'sparkle'
            follow:'rocket'
            lifeSpan: 750
            emitRatePerParticle: 200
            size: 32
            velocity: AngleDirection{
                angle: -90;angleVariation: 180;magnitude: 50
            }
        }
//        TrailEmitter{
//            id:explosion2Emitter
//            group: 'sparkle'
//            follow:'rocket'
//            lifeSpan: 750
//            emitRatePerParticle: 200
//            size: 32
//            velocity: AngleDirection{
//                angle: 90;angleVariation: 180;magnitude: 50
//            }
//        }
    }

    ImageParticle{
        id:sparklePainter
        system:particlesystem
        groups: ['sparkle']
        source:"../images/fire1.png"
        alpha:0.3
        color:'red'
        colorVariation: 2.6
        entryEffect: ImageParticle.Fade
    }

    ImageParticle{
        id:somkePainter
        system:particlesystem
        groups: ['smoke']
        source:"../images/fire1.png"
        alpha:0.3
        entryEffect: ImageParticle.Fade
    }
    ImageParticle{
        id:rocketPainter
        system:particlesystem
        groups: ['rocket']
        source:"../images/spaceship.png"
        entryEffect: ImageParticle.Fade
    }
}
