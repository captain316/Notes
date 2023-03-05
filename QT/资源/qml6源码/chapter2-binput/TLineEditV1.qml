import QtQuick

//Rectangle{
//    width: 200;height:30
//    color:'lightsteelblue'
//    border.color: "gray"
//    property alias text: input.text
//    property alias input: input

//    TextInput{
//        id:input
//        anchors.fill: parent
//        anchors.margins: 2
//    }
//}

FocusScope{
    width: 200;height:50
    Rectangle{
        anchors.fill: parent
        color:'lightsteelblue'
        border.color: "gray"
    }
    property alias text: input.text
    property alias input: input

    TextEdit/*TextInput*/{
        id:input
        anchors.fill: parent
        anchors.margins: 2
        focus:true
        wrapMode:Text.WordWrap
    }
}
