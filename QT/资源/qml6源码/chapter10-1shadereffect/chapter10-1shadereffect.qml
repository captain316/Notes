import QtQuick

Rectangle{
    width: 480;height: 240
    color:"#333"

    Row{
        anchors.centerIn: parent
        spacing: 20
        Image {
            id: sourceImage
            source: "../images/qq.png"
            width: 90;height: width
        }
        ShaderEffect{
            id:effect
            width: 90;height: width
            property variant source: sourceImage
        }
        ShaderEffect{
            id:effect2
            width: 90;height: width
            property variant src: sourceImage
            vertexShader:"default.vert.qsb"
            fragmentShader:"default.frag.qsb"
        }
    }
}
