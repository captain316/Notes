import QtQuick
import QtMultimedia
import QtQuick.Controls

Rectangle {
    id:root
    width: 640
    height: 450
    color: '#333'

    property int _imageIndex: -1
    CaptureSession{
        id:captureSession
        camera: Camera{}
        imageCapture: ImageCapture{
            id:imageCapture
            onImageSaved: function(Id,path){
                imagePaths.append({"path":path})
                listView.positionViewAtEnd()
                img.source="file:///"+path
            }
        }

        videoOutput: output
    }

    ListModel{id:imagePaths}

    ListView{
        id:listView
        anchors{
            left:root.left;right:root.right
         //   top:output.bottom
            bottom: root.bottom
            bottomMargin: 10
        }
        height: 100
        orientation: ListView.Horizontal
        spacing: 10
        model:imagePaths

        delegate: Image {
            id: name

            required property string path
            required property int index

            source: "file:///"+path
            fillMode: Image.PreserveAspectFit
            height:100


            MouseArea{
                anchors.fill: parent
                onClicked: {
                    root._imageIndex=parent.index
                    img.source=parent.source
                }
            }
        }

        Rectangle{
            anchors.fill: parent
            opacity: 0.1
            color:'lightgreen'
        }
    }

    VideoOutput{
        id:output
        width: 300;height: 200
        anchors.verticalCenter: root.verticalCenter
        anchors.left: root.left

        MouseArea{
            anchors.fill: parent
            onClicked: imageCapture.captureToFile()
        }
    }
    Image{
        id:img
        width:300;
        anchors.right: root.right
        anchors.verticalCenter: root.verticalCenter
       // source: imageCapture.preview
        fillMode: Image.PreserveAspectFit
    }

    MediaDevices{
        id:mediaDevices
    }

    Row{
        ComboBox{
            id:cameraComboBox
            height: 30
            model: mediaDevices.videoInputs
            textRole: "description"
            onAccepted: function(index){
               captureSession.camera.cameraDevice=cameraComboBox.currentValue
            }
        }

        Button{
            width: 50;height: 30
            text:'删除'
            onClicked: {
                imagePaths.remove(root._imageIndex)
                img.source=""
            }
        }
        Button{
            width: 50;height: 30
            text:'播放'
            onClicked: {
                startPlayback()
            }
        }

    }

    function startPlayback(){
        root._imageIndex=-1
        playTimer.start()
    }

    Timer{
        id:playTimer
        interval:200
        repeat:false

        onTriggered: {
            if(root._imageIndex+1<imagePaths.count){
                root._imageIndex=root._imageIndex+1
                img.source="file:///"+imagePaths.get(root._imageIndex).path
                playTimer.start()
            }
        }
    }

    Component.onCompleted: captureSession.camera.start()
}
