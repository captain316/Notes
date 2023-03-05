import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id:root
    width: 640
    height: 480
    visible: true

    function call(msg){
        const data ={
            expression:msg.toString(),
            result:"",
            error:""
        }

        try{
            const fun = new Function('return '+msg.toString())
            data.result=JSON.stringify(fun.call())
        }catch(e){
            data.error=e.toString()
        }
        print(data)
        return data
    }

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 9
        RowLayout{
            id:rowlayout
            Layout.fillWidth: true
            TextField{
                id:input
                Layout.fillWidth: true
                focus:true
                onAccepted: {
                    root.jsCall(input.text)
                    input.text=""
                }
            }
            Button{
                text:"Send"
                onClicked:{
                    root.jsCall(input.text)
                    input.text=""
                }
            }
        }
        Item{
            Layout.fillWidth: true
            height:root.height-rowlayout.height-9
            Rectangle{
                anchors.fill: parent
                color: 'gray'
                opacity:0.2
                radius:2
            }

            ScrollView{
                id:scrollView
                anchors.fill: parent
                anchors.margins: 9
                ScrollBar.horizontal.policy:ScrollBar.AlwaysOff
                ListView{
                    model:ListModel{
                        id:outputModel
                    }
                    delegate:ColumnLayout{
                        id:delegate
                        required property var model
                        width:ListView.view.width
                        Label{
                            id:exp
                            Layout.fillWidth: true
                            color:'green'
                            text:">"+delegate.model.expression
                        }
                        Label{
                            id:resultorerr
                            Layout.fillWidth: true
                            color:delegate.model.error===""?'blue':'red'
                            text:delegate.model.error===""?delegate.model.result:delegate.model.error
                        }
                        Rectangle{
                            height:1
                            Layout.fillWidth: true
                            color:'black'
                            opacity:0.3
                        }
                    }
                }
            }
        }
    }


    function jsCall(exp){
        const data=call(exp)
        outputModel.insert(0,data)
    }
}
