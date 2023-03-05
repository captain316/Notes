import QtQuick

Rectangle {
    width: 480; height: 240
    color: '#1e1e1e'

    GenieEffect{
        source: Image{source:'../images/qq.png'}
        MouseArea{
            anchors.fill: parent
            onClicked: {
                parent.minimized=!parent.minimized
              //  console.log(parent.minimized)
            }
        }
    }
}
