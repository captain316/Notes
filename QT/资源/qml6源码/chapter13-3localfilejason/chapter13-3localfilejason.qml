import QtQuick

Rectangle {
    width: 360
    height: 360
    color: '#000'

    GridView{
        id:view
        anchors.fill: parent
        cellHeight: width/4;cellWidth: cellHeight
        delegate: Rectangle{
            required property var modelData
            width:view.cellWidth
            height: view.cellHeight
            color:modelData.value
        }
    }

    function request(){
        var xhr=new XMLHttpRequest()
        xhr.onreadystatechange=function(){
            if(xhr.readyState===XMLHttpRequest.DONE){
                var reponse=JSON.parse(xhr.response)
                view.model=reponse.colors
            }
        }

        xhr.open("GET",'colors.json')
        xhr.send()
    }

    Component.onCompleted: request()
}
