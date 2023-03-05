import QtQuick
import QtQuick3D

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Mixing 2D and 3D")

    View3D {
        anchors.fill: parent
        //renderMode:View3D.Offscreen

        environment: SceneEnvironment {
            clearColor: "#222222"
            backgroundMode: SceneEnvironment.Color
        }

        Node{
            y:-30
            eulerRotation.y:-10
        Rectangle{
            anchors.horizontalCenter: parent.horizontalCenter
            color:'orange'
            width: text.width+10
            height:text.height+10
            Text{
                anchors.centerIn: parent
                id:text
                text:"I'm Suzanne"
                font.pointSize: 14
                color:'black'
            }
        }
        }

        Model {
            source: "meshes/suzanne.mesh"

            position: Qt.vector3d(0, 0, 0)
            scale: Qt.vector3d(30, 30, 30)
            eulerRotation: Qt.vector3d(-80, 30, 0)

            materials: [ DefaultMaterial {
                    diffuseColor: "yellow";
                    specularTint: "red";
                    specularAmount: 0.7
                } ]
        }

        PerspectiveCamera {
            position: Qt.vector3d(0, 0, 150)
            Component.onCompleted: lookAt(Qt.vector3d(0, 0, 0))
        }

        DirectionalLight {
            eulerRotation.x: -20
            eulerRotation.y: 110
            brightness: 2
            castsShadow: true
        }
    }
}
