import QtQuick

Rectangle {
    id:root
    property int step:0
    width: 480; height: 240
    color: '#1e1e1e'

    Grid{
        rows:2;columns: 4
        anchors.centerIn: parent
        spacing: 20

        Image{
            id:sourceImage
            width: 80
            height: width
            source: '../images/qq.png'
        }

        ShaderEffect{
            id:effect
            width: 80;height: width
            fragmentShader: "red.frag.qsb"
        }
        ShaderEffect{
            id:effect2
            width: 80;height: width
            property variant src: sourceImage
            fragmentShader: "red2.frag.qsb"
        }
        ShaderEffect{
            id:effect3
            width: 80;height: width
            property variant src: sourceImage
            property real redChannel: 0.6
            fragmentShader: "red3.frag.qsb"
        }
        ShaderEffect{
            id:effect4
            width: 80;height: width
            property variant src: sourceImage
            property real redChannel
            NumberAnimation on redChannel{
                from: 0.0;to:1.0;
                loops: Animation.Infinite
                duration: 4000
            }

            fragmentShader: "red3.frag.qsb"
        }
    }
}
