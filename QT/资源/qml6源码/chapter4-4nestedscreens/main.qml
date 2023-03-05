import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id:window
    width: 320
    height: 480
    visible: true
    title: qsTr("Stack")

    header:ToolBar{
        ToolButton{
            text:stackView.depth>1?"\u25C0":"\u2630"
            font.pixelSize: Qt.application.font.pixelSize*1.6
            onClicked: {
                if(stackView.depth>1){
                    stackView.pop()
                }else{
                    drawer.open()
                }
            }
        }
        Label{
            text:stackView.currentItem.title
            anchors.centerIn: parent
        }
    }

    Drawer{
        id:drawer
        width: window.width*0.66;height: window.height

        Column{
            anchors.fill:parent

            ItemDelegate{
                text:"Profile"
                width: parent.width
                onClicked: {
                    stackView.push("Profile.qml")
                    drawer.close()
                }
            }
            ItemDelegate{
                text:"About"
                width: parent.width
                onClicked: {
                    stackView.push(aboutPage)
                    drawer.close()
                }
            }
        }
    }

    StackView{
        id: stackView
        anchors.fill: parent

        initialItem: Home{}
    }

    Component{
        id:aboutPage

        About{}
    }
}
