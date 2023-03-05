import QtQuick

Rectangle {
    id:root
    width: 220; height: 260

    color:"#4A4A4A"

    Image {
        id: image
        source: "../images/pinwheel.png"
        x:(parent/*root*/.width-width)/2;y:40
    }

    Text {
        //un-named
        color:'white'
        /*x:(root.width-width)/2;*/y:image.y+image.height+20
        horizontalAlignment: Text.AlignHCenter
        width:root.width
        text: "大风车"
    }

}
