import QtQuick

Rectangle {
    width: 300
    height: 480

    gradient: Gradient {
        GradientStop { position: 0.0; color: "#4a4a4a" }
        GradientStop { position: 1.0; color: "#2b2b2b" }
    }
    //View
    ListView {
        id: listView

        anchors.fill: parent

        delegate: detailsDelegate
        model: planets
    }
    //Model
    ListModel {
        id: planets

        ListElement { name: "Mercury"; imageSource: "../images/mercury.jpg"; facts: "Mercury is the smallest planet in the Solar System. It is the closest planet to the sun. It makes one trip around the Sun once every 87.969 days." }
        ListElement { name: "Venus"; imageSource: "../images/venus.jpg"; facts: "Venus is the second planet from the Sun. It is a terrestrial planet because it has a solid, rocky surface. The other terrestrial planets are Mercury, Earth and Mars. Astronomers have known Venus for thousands of years." }
        ListElement { name: "Earth"; imageSource: "../images/earth.jpg"; facts: "The Earth is the third planet from the Sun. It is one of the four terrestrial planets in our Solar System. This means most of its mass is solid. The other three are Mercury, Venus and Mars. The Earth is also called the Blue Planet, 'Planet Earth', and 'Terra'." }
        ListElement { name: "Mars"; imageSource: "../images/mars.jpg"; facts: "Mars is the fourth planet from the Sun in the Solar System. Mars is dry, rocky and cold. It is home to the largest volcano in the Solar System. Mars is named after the mythological Roman god of war because it is a red planet, which signifies the colour of blood." }
    }
    //Delegate
    Component {
        id: detailsDelegate

        Item {
            id: wrapper

            required property string name
            required property string imageSource
            required property string facts

            width: listView.width
            height: 30

            Rectangle{//text
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height:30

                color:'#333'
                border.color: Qt.lighter(color,1.2)
                Text{
                    anchors.left: parent.left
                    anchors.leftMargin: 4
                    anchors.verticalCenter: parent.verticalCenter

                    font.pixelSize: parent.height-4
                    color:'#fff'
                    text:wrapper.name
                }
            }

            Rectangle{
                id:image
                width: 26;height:26
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 2
                anchors.rightMargin: 2
                color: 'black'
                Image {
                    anchors.fill: parent
                    fillMode:Image.PreserveAspectFit
                    source: wrapper.imageSource
                }
            }

            MouseArea{
                anchors.fill: parent
                onClicked: parent.state='expanded'
            }

            Rectangle{
                id:closeButton
                width: 26;height:26
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 2
                anchors.rightMargin: 2
                color: 'lightblue'
                border.color: Qt.lighter(color,1.1)

                opacity:0
                Text {
                    anchors.centerIn: parent
                    text: '\u25C0'
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: wrapper.state=""
                }
            }

            Item{
                id:factsView

                anchors.top: image.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                opacity: 0

                Rectangle{
                    anchors.fill: parent

                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#fed958" }
                        GradientStop { position: 1.0; color: "#fecc2f" }
                    }
                    border.color: '#000000'
                    border.width: 2

                    Text{
                        wrapMode: Text.WordWrap
                        anchors.margins: 5

                        color:'#1f1f21'
                        anchors.fill: parent
                        font.pixelSize: 12
                        text: wrapper.facts
                    }
                }
            }

            states: [
                State{
                    name:'expanded'

                    PropertyChanges {
                        target: wrapper;height:listView.height
                    }
                    PropertyChanges {
                        target: image;height:listView.width;width:listView.width
                        anchors.topMargin: 30;anchors.rightMargin: 0
                    }
                    PropertyChanges {
                        target: wrapper.ListView.view; contentY:wrapper.y;interactive:false
                    }
                    PropertyChanges {
                        target: closeButton;opacity:1
                    }
                    PropertyChanges {
                        target: factsView;opacity:1
                    }
                }
            ]

            transitions:[
                Transition {
                    NumberAnimation{
                        duration: 200
                       properties: "height,width,anchors.rightMargin,anchors.topMargin,opacity,contentY"
                    }
                }
            ]
        }
    }
}
