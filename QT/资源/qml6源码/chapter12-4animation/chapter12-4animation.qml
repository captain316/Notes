import QtQuick
import QtQuick3D

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Animating an Asset")

    View3D {
        anchors.fill: parent

        Monkey_with_bones{
            id:monkey
        }

        SequentialAnimation{
            loops:Animation.Infinite
            running:true
            NumberAnimation{
                target:monkey
                property: "left_ear.eulerRotation.y"
                from:-30
                to:60
                duration:1000
                easing.type: Easing.InOutQuad
            }
            NumberAnimation{
                target:monkey
                property: "left_ear.eulerRotation.y"
                from:60
                to:-30
                duration:1000
                easing.type: Easing.InOutQuad
            }
        }

        environment: SceneEnvironment {
            clearColor: "#222222"
            backgroundMode: SceneEnvironment.Color
        }

        PerspectiveCamera {
            position: Qt.vector3d(0, 0, 5)
            Component.onCompleted: lookAt(Qt.vector3d(0, 0, 0))
            clipNear: 0.1
        }

        DirectionalLight {
            eulerRotation.x: 20
            eulerRotation.y: 20

            castsShadow: true
        }
    }


}
