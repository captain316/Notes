import QtQuick
import QtQuick.Controls
import Qt.labs.platform as Platform
import QtQuick.Controls.Material
import "../"
ImageViewerWindow {
    id: window
    width: 320
    height: 480
    visible: true
    title: qsTr("Image Viewer")

    header:ToolBar{
        Material.background: Material.Orange
        ToolButton{
            icon.source: "../images/baseline-menu-24px"
            onClicked: drawer.open()
        }
        Label{
            anchors.centerIn: parent
            text:'Image Viewer'
            font.pixelSize: 20
        }
    }


    Drawer{
        id:drawer

        width: parent.width/3*2
        height: parent.height

        ListView{
            anchors.fill:parent
            model: ListModel {
                ListElement {
                    text: qsTr("Open...")
                    triggered: function(){ window.openFileDialog(); }
                }
                ListElement {
                    text: qsTr("About...")
                    triggered: function(){ window.openAboutDialog(); }
                }
            }

            delegate: ItemDelegate{
                text:model.text
                highlighted: ListView.isCurrentItem
                onClicked: {
                    drawer.close()
                    model.triggered()
                }
            }
        }
    }


}
