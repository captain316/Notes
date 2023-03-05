import QtQuick
import QtQuick.Controls

Page {
    title: "Profile"

    Column{
        anchors.centerIn: parent
        spacing: 10
        Button{
            anchors.horizontalCenter: parent.horizontalCenter
            text:"Home"
            onClicked: swipeView.setCurrentIndex(0)
        }

        Label{
            anchors.horizontalCenter: parent.horizontalCenter
            text:"Profile Screen"
        }
    }
}
