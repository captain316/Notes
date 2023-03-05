import QtQuick
import QtQuick.Controls

Page {
    title: "Profile"

    Column{
        anchors.centerIn: parent
        spacing: 10
        Button{
            anchors.horizontalCenter: parent.horizontalCenter
            text:"Edit"
            onClicked: stackView.push("EditProfile.qml")
        }

        Label{
            anchors.horizontalCenter: parent.horizontalCenter
            text:"Profile Screen"
        }
    }
}
