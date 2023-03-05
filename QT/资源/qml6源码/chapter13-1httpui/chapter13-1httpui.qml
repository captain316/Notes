// LocalHostExample.qml
import QtQuick
import "http://localhost:8080" as Remote

Rectangle {
    width: 320
    height: 320
    color: 'blue'

    Remote.Button {
        anchors.centerIn: parent

        text: qsTr('Quit')
        onClicked: Qt.quit()
    }
}

//Loader {
//    id: root
//    width: 320;height:320
//    source: 'http://localhost:8080/RemoteComponent.qml'
//    onLoaded: {
//        root.width = root.item.width
//        root.height = root.item.height
//    }
//}
