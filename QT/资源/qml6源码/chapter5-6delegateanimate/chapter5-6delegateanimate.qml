import QtQuick

Rectangle {
    width: 480
    height: 300

    gradient: Gradient {
        GradientStop { position: 0.0; color: "#dbddde" }
        GradientStop { position: 1.0; color: "#5fc9f8" }
    }

    //按钮
    Rectangle{
        property int count:count=theModel.count-1
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20

        height: 40
        color:'#53f769'
        border.color: Qt.lighter(color,1.1)

        Text{
            anchors.centerIn: parent
            text:"Add Item"
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                theModel.append({"num":++parent.count})
            }
        }
    }

    //View
    GridView{
        anchors.fill: parent
        anchors.margins: 20
        anchors.bottomMargin: 80

        clip: true
        cellHeight: 45;cellWidth: 45

        model:theModel
        delegate: numberDelegate
    }

    //Model
    ListModel{
        id:theModel
        ListElement{num:0}
        ListElement{num:1}
        ListElement{num:2}
        ListElement{num:3}
    }

    //Delegate
    Component{
        id:numberDelegate

        Rectangle{
            id:wrapper

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#f8306a" }
                GradientStop { position: 1.0; color: "#fb5b40" }
            }

            required property int index
            required property int num
            width: 40;height: 40

            Text{
                anchors.centerIn: parent
                font.pixelSize: 12
                text:wrapper.num
            }

            GridView.onAdd:addAnimation.start()
            GridView.onRemove:removeAnimation.start()

            NumberAnimation{
                id:addAnimation
                target: wrapper
                property: "scale"
                from:0;to:1
                duration:250
                easing.type: Easing.InOutQuad
            }

            SequentialAnimation{
                id:removeAnimation

                PropertyAction {
                    target: wrapper; property: "GridView.delayRemove" ;value:true
                }
                NumberAnimation{
                    target: wrapper
                    property: "scale"
                    to:0
                    duration:250
                    easing.type: Easing.InOutQuad
                }

                PropertyAction {
                    target: wrapper; property: "GridView.delayRemove" ;value:false
                }
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    theModel.remove(index)
                }
            }
        }
    }
}
