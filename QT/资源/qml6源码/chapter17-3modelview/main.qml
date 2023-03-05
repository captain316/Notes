import QtQuick
import org.example
import QtQuick.Layouts
Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Model View")

    Background{
        id:background
    }

    ColumnLayout{
        anchors.fill: parent
        anchors.margins:8

        ListView{
            id:view
           Layout.fillWidth: true
           Layout.fillHeight: true
            model: CppModel{
                id:cppModel
                onCountChanged: {
                    print("当前count:"+arg);
                    print("last entry:"+cppModel.get(arg-1));
                }
            }
            delegate: ListDelegate{
                text:model.name+' hsv('+
                     model.hue.toFixed(2)+','+
                     model.saturation.toFixed(2)+','+
                     model.brightness.toFixed(2)+')'
                color:model.name
                onClicked: {
                    view.currentIndex=model.index
                }
                onRemove: {
                    cppModel.remove(model.index)
                }
            }
            highlight:ListHighlight{}
            add:Transition {
                NumberAnimation{
                    properties: "x";
                    from:-view.width;
                    duration:250;
                }
                NumberAnimation{
                    properties: "y";
                    from:view.height;
                    duration:250;
                }
            }
        }
        TextEntry{
            id:textEntry
            onAppend: function(color){
             //   print('..... onAppend')
                if(cppModel.count===0)
                    cppModel.append(color)
                else
                    cppModel.insert(view.currentIndex,color)
            }

            onUp:{
                view.decrementCurrentIndex()
            }

            onDown:{
                view.incrementCurrentIndex()
            }
        }
    }
}
