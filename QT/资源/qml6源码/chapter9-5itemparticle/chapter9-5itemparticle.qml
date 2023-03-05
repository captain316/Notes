import QtQuick
import QtQuick.Particles

Rectangle {
    id: root
    width: 480; height: 240
    color: "#1F1F1F"
    property bool tracer: false

    ParticleSystem {
        id: particleSystem
    }
    ImageParticle {
        id: smokePainter
        system: particleSystem
        groups: ['smoke']
        source: "../images/fire1.png"
        alpha: 0.3
    }

    ItemParticle{
        id:rockPainter
         groups: ['rocket']
         system: particleSystem
         delegate: itemDelegate
    }

    property var images: []
    Component.onCompleted:  {
        images.push("qq.png")
        images.push("rocket.png")
        images.push("spaceship.png")
        images.push("soccer_ball.png")
    }

    Component{
        id:itemDelegate
        Item {
            id: container
            width:32*Math.ceil(Math.random()*3)
            height: width
            Image{
                anchors.fill: parent
                anchors.margins: 4
                source: "../images/"+root.images[Math.floor(Math.random()*4)]
            }
        }
    }

    Emitter {
        id: rocketEmitter
        anchors.bottom: root.bottom
        width: root.width; height: 40
        system: particleSystem
        group: 'rocket'
        emitRate: 2
        maximumEmitted: 4
        lifeSpan: 5800
        lifeSpanVariation: 400
        size: 32
        velocity: AngleDirection { angle: 270; magnitude: 150; magnitudeVariation: 10 }
        acceleration: AngleDirection { angle: 90; magnitude: 50 }
    }

    TrailEmitter {
        id: smokeEmitter
        system: particleSystem
        group: 'smoke'
        follow: 'rocket'
        size: 16
        sizeVariation: 8
        emitRatePerParticle: 16
        velocity: AngleDirection { angle: 90; magnitude: 100; angleVariation: 15 }
        lifeSpan: 200
    }

}
