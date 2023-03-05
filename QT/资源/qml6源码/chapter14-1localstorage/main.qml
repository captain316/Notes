import QtQuick
import QtQuick.LocalStorage
Window {
    width: 640
    height: 480
    visible: true

    Rectangle{
        id:crazy
        width: 100;height: width
        x:50;y:50
        color:'lightgreen'
        Text{
            anchors.centerIn: parent
            text:Math.round(parent.x)+'/'+Math.round(parent.y)
        }
        MouseArea{
            anchors.fill: parent
            drag.target: parent
        }
    }

    property var db

    function initDB(){
        print("initDB")
        db=LocalStorage.openDatabaseSync("Crazybox",'1.0','Position Box',100000)
        db.transaction(function(tx){
            print('create table')
            tx.executeSql('CREATE TABLE IF NOT EXISTS data(name TEXT,value TEXT)')
        }
        )
    }
    function readDB(){
        print("readDB")
        if(!db){return}
        db.transaction(function(tx){
            print('read Crazybox info');
            var result=tx.executeSql('select * from data where name="crazy"')
            if(result.rows.length===1){
                print('update crazybox position')
                var value=result.rows[0].value
                var obj=JSON.parse(value)
                crazy.x=obj.x
                crazy.y=obj.y
            }
        }
        )
    }
    function storeDB(){
        print("storeDB")
        if(!db){return}

        db.transaction(function(tx){
            var result=tx.executeSql('select * from data where name="crazy"')
            var obj={x:crazy.x,y:crazy.y}
            if(result.rows.length===1){
                print('crazy info exists,update it')
                tx.executeSql('UPDATE data set value=? where name="crazy"',[JSON.stringify(obj)])
            }else{
                print('crazy info does not exists,create one')
                tx.executeSql('INSERT INTO data VALUES(?,?)',['crazy',JSON.stringify(obj)])
            }
        }
        )
    }


    Component.onCompleted: {
        initDB()
        readDB()
    }
    Component.onDestruction: storeDB()
}
