import QtQuick
import QtQuick3D

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Basic Materials")

    View3D {
        anchors.fill: parent

        environment: SceneEnvironment {
            clearColor: "darkgreen"
            backgroundMode: SceneEnvironment.SkyBox
            lightProbe: Texture{
                source:"maps/skybox.jpg"
            }
        }
        Model {
            source: "meshes/suzanne.mesh"

            position: Qt.vector3d(5, 4, 0)
            scale: Qt.vector3d(2, 2, 2)
            eulerRotation:Qt.vector3d(-80, 30, 0)

            materials: [ DefaultMaterial {
                    diffuseColor: "yellow";
                    specularAmount: 0.75
                    specularTint: 'red'
                } ]
        }

        Model {
            source: "#Sphere"

            scale: Qt.vector3d(.05, .05, .05)
            position: Qt.vector3d(5, -4, 0)

            materials: [ DefaultMaterial {
                    diffuseColor: "blue";
                    specularAmount: 0.75
                    specularTint: 'teal'
                } ]
        }

        Model {
            source: "meshes/suzanne.mesh"

            position: Qt.vector3d(-5, 4, 0)
            scale: Qt.vector3d(2, 2, 2)
            eulerRotation:Qt.vector3d(-80, 30, 0)

            materials: [ PrincipledMaterial {
                    baseColor: "yellow";
                    metalness: 0.9
                    roughness: 0.2
                } ]
        }

        Model {
            source: "#Sphere"

            scale: Qt.vector3d(.05, .05, .05)
            position: Qt.vector3d(-5, -4, 0)

            materials: [ PrincipledMaterial {
                    baseColor: "blue";
                    metalness: 0.95
                    roughness: 0.5
                } ]
        }

        PerspectiveCamera {
            position: Qt.vector3d(0, 0, 15)
            Component.onCompleted: lookAt(Qt.vector3d(0, 0, 0))
        }

        DirectionalLight{
            eulerRotation.x:-20
            eulerRotation.y:110
            castsShadow: true
        }
    }
}
