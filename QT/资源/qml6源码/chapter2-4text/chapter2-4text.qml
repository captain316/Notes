import QtQuick

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Text {
        id:text1
        text: "The quick brown fox"
        color: "#303030"
        font.family: "Ubuntu"
        font.pixelSize: 28
    }

    Text {
        width:84
        //elide: Text.ElideMiddle
        y:text1.y+text1.height+20
        text: "一个很长很长的句子 !!!!!!!!!!"

        style: Text.Sunken
        styleColor: '#000000'
        font.pixelSize: 28

        color: "#ffffff"
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    }
}
