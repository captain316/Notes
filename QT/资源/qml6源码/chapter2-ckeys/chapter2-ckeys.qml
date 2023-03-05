import QtQuick

Rectangle {
    width: 300;height:300
    Rectangle{
        id:square
        width: 100;height:100
        color:'green'
        border.color: Qt.lighter(color)
    }

    focus: true
    Keys.onLeftPressed: square.x-=8
    Keys.onRightPressed: square.x+=8
    Keys.onUpPressed: square.y-=8
    Keys.onDownPressed: square.y+=8
    Keys.onPressed: function (event){
        switch(event.key){
        case Qt.Key_Plus:square.scale+=0.2;break;
        case Qt.Key_Minus:square.scale-=0.2;break;
        }
    }
}
