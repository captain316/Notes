//import QtQuick
import QtQuick 2.9
import QtQuick.Window 2.2
Window {
    width: 500/*background.width*/         //：绑定，不是=（赋值）
    height: 300/*background.height*/
    visible: true
    title: qsTr("转呀转呀")

    Image {                                 //topmost的先绘制
        anchors.fill:  parent;              //用当前元素填充parent
        id: background                      //就像是C++的引用，不能修改
        source: "../images/background.png"  //url

        Image {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            id: pole
            source: "../images/pole.png"
        }

        Image {
            anchors.centerIn: parent        //放到parent的中间去
//            anchors.verticalCenter: parent.verticalCenter
//            anchors.horizontalCenter: parent.horizontalCenter
            id: wheel
            source: "../images/pinwheel.png"

            Behavior on rotation {          //为特定的属性修改行为提供动画
                NumberAnimation{
                    duration:500
                }
            }
        }

        MouseArea{
            anchors.fill: parent
            onClicked:wheel.rotation+=360
        }
    }
}
