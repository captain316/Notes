import QtQuick

Rectangle {
    width: 120
    height: 300

    gradient: Gradient {
        GradientStop { position: 0.0; color: "#f6f6f6" }
        GradientStop { position: 1.0; color: "#d7d7d7" }
    }

    ListModel{
        id:actionModel
        ListElement{
            name:"张三"
            hello:function(value){console.log(value+"张三在此！")}
        }
        ListElement{
            name:"李四"
            hello:function(value){console.log(value+"李四在此！")}
        }
        ListElement{
            name:"王五"
            hello:function(value){console.log(value+"王五在此！")}
        }
    }

    ListView{
        anchors.fill: parent
        anchors.margins: 20

        focus: true
        spacing:5
        clip: true
        model:actionModel

        delegate: Rectangle{
            id:delegate

            required property int index
            required property string name
            required property var hello

            width: ListView.view.width
            height:40
            color:"lightblue"

            Text {
                anchors.centerIn: parent
                font.pixelSize: 12
                text: delegate.name
            }

            MouseArea{
                anchors.fill: parent
                onClicked: delegate.hello(delegate.index)
            }
        }
    }
}
