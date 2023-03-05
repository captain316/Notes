import QtQuick
import QtQuick.Layouts
Rectangle{
    id:root
    width: childrenRect.width
    height: childrenRect.height

    color:'gray'
    gradient: Gradient{
        GradientStop{position:0.0;color:root.color}
        GradientStop{position:1.0;color:Qt.lighter(root.color,1.5)}
    }

    ColumnLayout{
        spacing: 20
        Grid{
            spacing: 10
            columns:5
            EasingType{
                title:'Linear'
                easingType: Easing.Linear
                onClicked: {
                    animation.easing.type=easingType
                    box.toggle=!box.toggle
                }
            }
            EasingType{
                title:'InExpo'
                easingType: Easing.InExpo
                onClicked: {
                    animation.easing.type=easingType
                    box.toggle=!box.toggle
                }
            }
            EasingType{
                title:'OutExpo'
                easingType: Easing.OutExpo
                onClicked: {
                    animation.easing.type=easingType
                    box.toggle=!box.toggle
                }
            }
            EasingType{
                title:'InOutExpo'
                easingType: Easing.InOutExpo
                onClicked: {
                    animation.easing.type=easingType
                    box.toggle=!box.toggle
                }
            }
            EasingType{
                title:'InOutCubic'
                easingType: Easing.InOutCubic
                onClicked: {
                    animation.easing.type=easingType
                    box.toggle=!box.toggle
                }
            }
            EasingType{
                title:'SineCurve'
                easingType: Easing.SineCurve
                onClicked: {
                    animation.easing.type=easingType
                    box.toggle=!box.toggle
                }
            }
            EasingType{
                title:'InOutCirc'
                easingType: Easing.InOutCirc
                onClicked: {
                    animation.easing.type=easingType
                    box.toggle=!box.toggle
                }
            }
            EasingType{
                title:'InOutElastic'
                easingType: Easing.InOutElastic
                onClicked: {
                    animation.easing.type=easingType
                    box.toggle=!box.toggle
                }
            }
            EasingType{
                title:'InOutBack'
                easingType: Easing.InOutBack
                onClicked: {
                    animation.easing.type=easingType
                    box.toggle=!box.toggle
                }
            }
            EasingType{
                title:'InOutBounce'
                easingType: Easing.InOutBounce
                onClicked: {
                    animation.easing.type=easingType
                    box.toggle=!box.toggle
                }
            }
        }
        Rectangle{
            height:100
            Layout.fillWidth: true
            gradient: Gradient{
                GradientStop{position:0.0;color:'gray'}
                GradientStop{position:1.0;color:'green'}
            }
            Rectangle{
                id:box
                property  bool toggle
                anchors.verticalCenter: parent.verticalCenter
                width: 80;height:80
                gradient: Gradient{
                    GradientStop{position:0.0;color:'red'}
                    GradientStop{position:1.0;color:'yellow'}
                }

                x:toggle?20:root.width-width-20
                Behavior on x{
                    NumberAnimation{
                        id:animation
                        duration:1000
                    }
                }
            }
        }
    }
}
