import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id:window
    width: 320
    height: 480
    visible: true
    title: qsTr("Side by Side")


    SwipeView{
        id: swipeView
        anchors.fill: parent

        Home{

        }

        About{

        }

        EditProfile{

        }

        Profile{

        }

    }

    PageIndicator{
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        currentIndex: swipeView.currentIndex
        count:swipeView.count
    }
}
