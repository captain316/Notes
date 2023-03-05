import QtQuick
import QtQuick.Particles

Rectangle{
    width: 480;height: 160
    id:root
    color: '#333'

    ParticleSystem{
        id:particlesystem
    }

    Emitter{
        system:particlesystem
        width: 160;height: 80
        anchors.centerIn: parent
        emitRate: 10
        lifeSpan: 1000
        lifeSpanVariation: 500
        size:16
        endSize: 50

        Rectangle{
            border.color: 'green'
            anchors.fill: parent
            color: Qt.rgba(0,0,0,0)
        }
    }

    ImageParticle{
        source:"../images/bubble.png"
        system:particlesystem
    }
}
