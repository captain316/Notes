import QtQuick
import "../common"
Window {
    width: 640
    height: 480
    visible: true

    GridView{
        anchors.fill: parent
        anchors.margins: 20
        clip:true

        model:100
        cellWidth:45;cellHeight:45
        flow:GridView.FlowTopToBottom

        delegate: GreenBox{
            required property int index
            width: 40;height:40
            text:index
        }
    }
}
