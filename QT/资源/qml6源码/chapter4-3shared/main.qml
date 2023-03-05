
import QtQuick
import QtQuick.Controls

ImageViewerWindow {
    id: window

    width: 640
    height: 480

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            MenuItem {
                text: qsTr("&Open...")
                icon.source: "../images/open.png"
                onTriggered: window.openFileDialog()
            }
        }

        Menu {
            title: qsTr("&Help")
            MenuItem {
                text: qsTr("&About...")
                onTriggered: window.openAboutDialog()
            }
        }
    }

    header: ToolBar {
        Flow {
            anchors.fill: parent
            ToolButton {
                text: qsTr("Open")
                icon.source: "../images/open.png"
                onClicked: window.openFileDialog()
            }
        }
    }
}
