import QtQuick
import QtMultimedia
import QtQuick.Controls

Window {
    id:root
    width: 640
    height: 480
    visible: true

    MediaPlayer{
        id:player
        source: "../5.3ListView.mp4"
        audioOutput:AudioOutput{
            volume: volumeSlider.value
        }
        videoOutput: videoOutput
    }

    VideoOutput{
        id:videoOutput
        width: root.width-80;
        anchors.centerIn: parent
    }

    Rectangle{
        color:'black'
        width: col.width;height: col.height
        anchors.top:parent.top
        anchors.right:parent.right
        Column{
            id:col
            Text {
                color: 'white'
                text: qsTr("音量")
            }
            Slider{
                id:volumeSlider
                orientation: Qt.Vertical
                value:0.5
                anchors.margins: 20
            }
        }
    }
    Row{
        height: 50;
        anchors.left: parent.left
        anchors.right:parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20
        spacing:20

        Button{
            width: 50
            anchors.verticalCenter: parent.verticalCenter
            text:player.playbackState===MediaPlayer.PlayingState?'Pause':'Play'
            onClicked: {
                switch(player.playbackState){
                case MediaPlayer.PlayingState:player.pause();break;
                case MediaPlayer.PausedState:player.play();break;
                case MediaPlayer.StoppedState:player.play();break;
                }
            }
        }
        Slider{
            id:progressSlider
            width: parent.width-80
            anchors.verticalCenter: parent.verticalCenter
            value:player.duration>0?player.position/player.duration:0

            background: Rectangle{
                implicitHeight: 8
                radius: 3
                color: 'lightgreen'

                Rectangle{
                    width: progressSlider.value*parent.width
                    height: parent.height
                    color:'blue'
                    radius: 3
                }
            }

            onMoved:function(){
                player.position=player.duration*progressSlider.value
            }
        }
    }

    Component.onCompleted: {
        player.play()
    }
}
