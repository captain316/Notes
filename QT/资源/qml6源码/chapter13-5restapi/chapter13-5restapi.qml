import QtQuick
import "colorservice.js" as Service
Rectangle {
    width: 480
    height: 320
    color: '#000'

    ListModel {
        id: gridModel
    }
    GridView {
        id: view
        anchors.top: parent.top
        anchors.bottom: message.top
        anchors.left: parent.left
        anchors.right: sideBar.left
        anchors.margins: 8
        model: gridModel
        cellWidth: 64
        cellHeight: 64
        delegate: Rectangle {
            required property var model
            width: 64
            height: 64
            color: model.value
        }
    }

    StatusLabel {
        id: message
        text: 'status:NULL'
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }

    Column {
        id: sideBar
        width: 160
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 8
        spacing: 8
        Button {
            text: 'Read Colors'
            onClicked: {
                Service.getColors(function(reponse){
                    gridModel.clear()
                    const entries=reponse.data
                    for(let i=0;i<entries.length;i++){
                        gridModel.append(entries[i])
                    }
                }
                )
            }
        }
        Button {
            text: 'Create New'
            onClicked: {
                const index=gridModel.count-1
                const entry={
                    name:'color-'+index,
                    value:Qt.hsla(Math.random(),0.5,0.5,1.0).toString()
                }

                Service.createColor(entry,function(response){
                    gridModel.append(response)
                }
                )
            }
        }
        Button {
            text: 'Read Last Color'
            onClicked: {
                const index=gridModel.count-1
                const name=gridModel.get(index).name

                Service.getColor(name,function(reponse){
                    message.text=reponse.value
                }
                )
            }
        }
        Button {
            text: 'Update Last Color'
            onClicked: {
                const index=gridModel.count-1
                const name=gridModel.get(index).name
                const entry={
                    value:Qt.hsla(Math.random(),0.5,0.5,1.0).toString()
                }

                Service.updateColor(name,entry,function(response){
                    gridModel.setProperty(gridModel.count-1,'value',response.value)
                }
                )
            }
        }
        Button {
            text: 'Delete Last Color'
            onClicked: {
                const index=gridModel.count-1
                const name=gridModel.get(index).name

                Service.deleteColor(name)
                gridModel.remove(index,1)
            }
        }
    }
}
