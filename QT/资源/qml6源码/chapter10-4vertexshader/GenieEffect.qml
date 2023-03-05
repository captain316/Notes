import QtQuick

ShaderEffect{
    id:genieEffect
    width: 160;height: width
    anchors.centerIn: parent
    mesh:GridMesh{resolution: Qt.size(16,16)}
    property variant source: sourceImage
    property bool minimized:false
    property real minimize: 0.0
    property real side:0.5
    property real bend: 0.0



    ParallelAnimation{
        id:animMinimize
        running: genieEffect.minimized
        SequentialAnimation{
            PauseAnimation {duration: 300}
            NumberAnimation{target:genieEffect;property: 'minimize';to:1.0;duration:700;easing.type: Easing.InOutSine}
        }
        SequentialAnimation{
            NumberAnimation{target:genieEffect;property: 'bend';to:1.0;duration:700;easing.type: Easing.InOutSine}
        }
    }

    ParallelAnimation{
        id:animNormalize
        running: !genieEffect.minimized
        SequentialAnimation{
            NumberAnimation{target:genieEffect;property: 'minimize';to:0.0;duration:700;easing.type: Easing.InOutSine}
        }
        SequentialAnimation{
            PauseAnimation {duration: 300}
            NumberAnimation{target:genieEffect;property: 'bend';to:0.0;duration:700;easing.type: Easing.InOutSine}
        }
    }
    vertexShader: 'sprite.vert.qsb'
}
