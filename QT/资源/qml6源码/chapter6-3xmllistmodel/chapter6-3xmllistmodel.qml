import QtQuick
import QtQml.XmlListModel

Window {
    width: 400
    height: 480
    visible: true

    ListView{
        id:listView
        anchors.fill: parent

        model:imageModel
        delegate: imageDelegate
    }

    XmlListModel{
        id:imageModel

        source: "https://www.nasa.gov/rss/dyn/image_of_the_day.rss"
        query: "/rss/channel/item"
        XmlListModelRole { name: "title"; elementName: "title" }
        XmlListModelRole { name: "imageSource"; elementName: "enclosure"; attributeName: "url"; }
    }

    Component{
        id:imageDelegate

        Rectangle{
            id:wrapper
            color: '#333'
            required property string title
            required property string imageSource
            width:listView.width
            height: 220


            Column{
                Text {
                    text: wrapper.title
                    color: '#e0e0e0'
                }
                Image {
                    source: wrapper.imageSource
                    height: 200
                    width: listView.width
                    fillMode: Image.PreserveAspectCrop
                }
            }
        }
    }
}
