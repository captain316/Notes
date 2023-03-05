import QtQuick

Item{
    id:root
    width: 150;height:260
    property color black: 'black'
    property color red: 'red'
    property color green: 'green'

    Rectangle{
        anchors.fill: parent
        color:"#333333"
    }

    state: "stop"
    states: [
        State {
            name: "stop"
            PropertyChanges {target: light1;color:root.red}
            PropertyChanges {target: light2;color:root.black}
        },
        State {
            name: "go"
            PropertyChanges {target: light1;color:root.black}
            PropertyChanges {target: light2;color:root.green}
        }
    ]

    transitions: //[
        Transition {
            //from: "stop";to: "go"
            from:"*";to:"*"

            ColorAnimation {
                target: light1;properties: 'color';duration: 1000
            }
            ColorAnimation {
                target: light2;properties: 'color';duration: 1000
            }
        }
//    ]

    Rectangle{
        id:light1
        x:25;y:15
        width:100;height: width
        radius: width/2
        color:root.black
        border.color: Qt.lighter(color,1.1)
    }

    Rectangle{
        id:light2
        x:25;y:135
        width:100;height: width
        radius: width/2
        color:root.black
        border.color: Qt.lighter(color,1.1)
    }

    MouseArea{
        anchors.fill: parent
        onClicked: parent.state=(parent.state=="stop"?"go":"stop")
    }
}
