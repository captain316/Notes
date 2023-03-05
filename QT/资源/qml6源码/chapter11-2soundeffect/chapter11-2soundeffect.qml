import QtQuick
import QtQuick.Controls
import QtMultimedia

Window {
    width: 500
    height: 500
    visible: true

    SoundEffect{id:mine; source:"../images/mine.wav";volume: 0.05}
    SoundEffect{id:machineGun; source:"../images/machineGun.wav";loops: 2}

    Rectangle{
        id:rectangle
        anchors.centerIn: parent
        width: 300;height: width
        color: 'red'
        state:"DEFAULT"

        states:[
            State{
                name:'DEFAULT'
                PropertyChanges {
                    target: rectangle
                    rotation:0;
                }
            },
            State{
                name:'REVERSE'
                PropertyChanges {
                    target: rectangle
                    rotation:170;
                }
            }
        ]

        transitions: [
            Transition{
                to:"DEFAULT"
                ParallelAnimation{
                    ScriptAction{script:machineGun.play()}
                    PropertyAnimation{
                        properties: 'rotation'
                        duration: 200
                    }
                }
            },
            Transition{
                to:"REVERSE"
                ParallelAnimation{
                    ScriptAction{script:mine.play()}
                    PropertyAnimation{
                        properties: 'rotation'
                        duration: 200
                    }
                }
            }
        ]
    }

    Button{
        anchors.centerIn: parent
        text:'Flip!'
        onClicked: rectangle.state=rectangle.state==="DEFAULT"?"REVERSE":"DEFAULT"
    }
}
