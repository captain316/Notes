import QtQuick

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("input")

//    Rectangle{
//        width: 200;height:80
//        color:'linen'
//        TextInput{
//            id:input1
//            x:8;y:8
//            width: 96;height:20
//            focus: true
//            text:'Text input 1'
//            KeyNavigation.tab: input2
//        }

//        TextInput{
//            id:input2
//            x:8;y:36
//            width: 96;height:20
//            //focus: true
//            text:'Text input 2'
//            KeyNavigation.tab: input1
//        }
//    }
    TLineEditV1{
        id:input1
        text: "Text input 1"
        input.font.pixelSize: 16
        height: 10*input.font.pixelSize+10
        input.color: 'white'
        focus:true
        KeyNavigation.tab: input2
    }

    TLineEditV1{
        id:input2
        text: "Text input 2"
        input.font.pixelSize: 16
        y:input1.y+input1.height+12
        height: input.font.pixelSize+10
        input.color: 'white'
        KeyNavigation.tab: input1
    }
}
