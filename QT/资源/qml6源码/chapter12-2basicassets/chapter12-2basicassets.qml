import QtQuick
import QtQuick3D

Window {
    width: 640
    height: 480
    visible: true

    View3D{
        anchors.fill: parent
        environment: SceneEnvironment{
            clearColor: '#222222'
            backgroundMode: SceneEnvironment.Color
        }

        Model {
            id: suzanne
            eulerRotation.x:-80
            eulerRotation.y:30
            source: "meshes/suzanne.mesh"
            scale: Qt.vector3d(2,2,2)
            DefaultMaterial {
                id: defaultMaterial_material
                diffuseColor: "yellow"
            }
            materials: [
                defaultMaterial_material
            ]
        }

        PerspectiveCamera {
            position: Qt.vector3d(0,0,5)
            Component.onCompleted: lookAt(Qt.vector3d(0,0,0))
            clipNear: 1
            clipFar: 100
        }

        DirectionalLight{
            eulerRotation.x:-20
            eulerRotation.y:110

            castsShadow: true
        }
    }
}
