import QtQuick
import "../common"

Window {
    width: 80;height: 300
    visible: true

    ListView{
        id:lv
        anchors.fill: parent
        anchors.margins: 20
        clip: true
        model: 5

        //       layoutDirection: "RightToLeft"
        //       orientation:ListView.Horizontal
        delegate: Item{
            id:wrapper
            required property int index
            width: lv.width
            height: 40
            Text{
                anchors.centerIn: parent
                text:wrapper.index
            }

            Component.onCompleted: {console.log(index+" added")}
            Component.onDestruction:  {console.log(index+" deleted")}
        }

        highlight: highlightComponent
        header:headerComponent
        footer:footerComponent

        focus: true
        cacheBuffer: 80
        spacing: 5
    }
    Component{
        id:footerComponent
        BlueBox{
            width: lv.width;height: 30
            text: 'Footer'
        }
    }
    Component{
        id:headerComponent
        BlueBox{
            width: lv.width;height: 30
            text: 'Header'
        }
    }
    Component{
        id:highlightComponent

        GreenBox{
            id:gb
            width: lv.width

            y:lv.currentItem.y

            Behavior on y{
                SequentialAnimation{
                    PropertyAnimation{target:gb;property:"opacity";to:0;duration:200}
                    NumberAnimation{duration:200}
                    PropertyAnimation{target:gb;property:"opacity";to:1;duration:200}

                }
            }
        }
    }
}
