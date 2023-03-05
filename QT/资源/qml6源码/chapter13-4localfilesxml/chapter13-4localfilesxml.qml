import QtQuick
import QtQml.XmlListModel
Rectangle {
    width: 360
    height: 360
    color: '#000'

    GridView {
        id: view
        anchors.fill: parent
        cellWidth: width / 4
        cellHeight: cellWidth

        model:xmlModel
        delegate:Rectangle{
            id:delegate
            required property var model
            width: view.cellHeight;height: width
            color:model.name
            Text {
                anchors.centerIn: parent
                text: delegate.model.value
            }
        }
    }

    XmlListModel{
        id:xmlModel
        source:"colors.xml"
        query: "/colors/color"
        XmlListModelRole{name:'name';elementName:'name'}
        XmlListModelRole{name:'value';elementName:'value'}
    }
}
