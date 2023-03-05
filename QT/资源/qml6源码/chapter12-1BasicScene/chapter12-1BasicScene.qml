import QtQuick
import QtQuick3D

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Basic Scene")

    View3D{
        anchors.fill: parent

        environment: SceneEnvironment{
            clearColor: "#222222"
            backgroundMode: SceneEnvironment.Color
        }

        Model{
            position: Qt.vector3d(0,0,0)
            scale:Qt.vector3d(1,1.25,1)
            source: "#Cone"
            materials: [PrincipledMaterial{baseColor: "yellow"}]
        }

        Model{
            position: Qt.vector3d(80,0,50)
            source: "#Sphere"
            materials: [PrincipledMaterial{baseColor: "green"}]
        }
        Model{
            position: Qt.vector3d(-80,0,50)
            source: "#Cube"
            materials: [PrincipledMaterial{baseColor: "red"}]
        }

        Model{
            position: Qt.vector3d(0,-50,0)
            eulerRotation.x:-90
            scale:Qt.vector3d(4,4,4)
            source: "#Rectangle"
            materials: [PrincipledMaterial{baseColor: "white"}]
        }

        DirectionalLight{
            eulerRotation.x:-20
            eulerRotation.y:110

            castsShadow: true
        }
        PointLight{
            position: Qt.vector3d(100,100,100)

            castsShadow: true
        }
        SpotLight{
            position: Qt.vector3d(50,200,50)
            eulerRotation.x:-90
            brightness: 5
            ambientColor: Qt.rgba(0.1,0.1,0.1,1)
            castsShadow: true
        }
        PerspectiveCamera{
            position: Qt.vector3d(0,200,300)
            Component.onCompleted: lookAt(Qt.vector3d(0,0,0))
        }
    }
}
