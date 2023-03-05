import QtQuick
import "../common"
Rectangle {
    id:root
    width: 300
    height: 480

    gradient: Gradient {
        GradientStop { position: 0.0; color: "#4a4a4a" }
        GradientStop { position: 1.0; color: "#2b2b2b" }
    }
    //View
    PathView{
        model:100
        anchors.fill: parent

        delegate: flipCardDelegate
        path: Path{
            startX: root.width/2;startY: 0
            PathAttribute{name: "itemZ";value:0}
            PathAttribute{name: "itemAngle";value:-90}
            PathAttribute{name: "itemScale";value:0.5}
            PathLine{x:root.width/2;y:root.height*0.4}
            PathPercent{value:0.48}
            PathLine{x:root.width/2;y:root.height*0.5}
            PathAttribute{name: "itemZ";value:100}
            PathAttribute{name: "itemAngle";value:0}
            PathAttribute{name: "itemScale";value:1}
            PathLine{x:root.width/2;y:root.height*0.6}
            PathPercent{value:0.52}
            PathLine{x:root.width/2;y:root.height}
            PathAttribute{name: "itemZ";value:0}
            PathAttribute{name: "itemAngle";value:90}
            PathAttribute{name: "itemScale";value:0.5}
        }
        pathItemCount: 16
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
    }

    //Delegate
    Component{
        id:flipCardDelegate

        BlueBox{
            id:wrapper
            width: 64;height: 64
            text: index
            z:PathView.itemZ
            scale:PathView.itemScale

            antialiasing:true

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#2ed5fa" }
                GradientStop { position: 1.0; color: "#2467ec" }
            }

            opacity:PathView.isCurrentItem?1:0.5

            transform: Rotation{
                axis {x:1;y:0;z:0}
                angle: wrapper.PathView.itemAngle
                origin {x:32;y:32}
            }
        }
    }
}
