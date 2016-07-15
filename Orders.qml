import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: container

    signal goto_orders_order
    signal goto_orders_order_with_address(string json_string)

    property int route_container_item_heigth: 20
    property string route_from_icon_source: "qrc:/img/dot.png"

    property string top_menu_icon_source: "qrc:/img/back.png"
    property string top_menu_logo_source: "qrc:/img/logo.png"

    property int full_picture_height: 1080

    property int top_menu_relative_height: 95
    property int top_menu_heigth: top_menu_relative_height * (height / full_picture_height)

    property int top_menu_font_size: 12
    property string yelow_collor_code: "#fcc900"


    FontLoader {
        id: sf_font
        source: "qrc:/fonts/SFUIDisplay-Regular.otf"
    }

    FontLoader {
        id: sf_font_thin
        source: "qrc:/fonts/SFUIDisplay-Thin.otf"
    }


    Component.onCompleted:
    {
        orders_model.append({"json_string": "[{\"address_text\": \"address 1\"}, {\"address_text\": \"address 2\"}]"})
        orders_model.append({"json_string": "[{\"address_text\": \"address 1\"}, {\"address_text\": \"address 3\"}]"})
        orders_model.append({"json_string": "[{\"address_text\": \"address 1\"}, {\"address_text\": \"address 4\"},  {\"address_text\": \"address 6\"},  {\"address_text\": \"address 6\"}]"})
        orders_model.append({"json_string": "[{\"address_text\": \"address 1\"}, {\"address_text\": \"address 5\"}, {\"address_text\": \"address 6\"}]"})
        orders_model.append({"json_string": "[{\"address_text\": \"address 1\"}, {\"address_text\": \"address 6\"}, {\"address_text\": \"address 6\"}]"})
    }



    Rectangle {
        id: top_menu

        color: "white"
        height: top_menu_heigth
        width: parent.width

        Rectangle {

            id: top_menu_icon_wrapper

            height: parent.height * 0.9
            width: height

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left

            color: "transparent"
            Image {
                id: top_menu_icon

                height: parent.height * 0.5
                width: height

                smooth: true

                anchors.centerIn: parent

                source: top_menu_icon_source

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        container.goto_orders_order()
                    }
                }
            }
        }

        Text {
            id: top_current_text
            text: qsTr("ЗАКАЗ")

            font.family: sf_font.name
            font.pointSize: top_menu_font_size

            anchors.left: top_menu_icon_wrapper.right
            anchors.right: top_menu_logo.left
            anchors.verticalCenter: parent.verticalCenter

            horizontalAlignment: Text.Center
        }

        Image {
            id: top_menu_logo

            height: parent.height
            width: height

            source: top_menu_logo_source

            anchors.centerIn: parent
        }

        Rectangle {
            anchors.right: parent.right
            anchors.left: top_menu_logo.right

            height: parent.height

            Text {
                id: top_trips_text
                text: qsTr("ПОЕЗДКИ")

                font.family: sf_font.name
                font.pointSize: top_menu_font_size

                anchors.centerIn: parent
            }

            Rectangle {
                id: top_current_text_acitve

                height: 3

                width: parent.width

                color: yelow_collor_code

                anchors.bottom: parent.bottom
            }

        }
    }

    ListModel {
        id: orders_model
    }

    ListView{
        id: orders_list_view
        model: orders_model

        width: parent.width
        height: parent.height

        delegate: orders_list_view_delegate

        anchors.top: top_menu.bottom
    }

    Component {
        id: orders_list_view_delegate

        //        property string _json_string: json_string

        Rectangle {
            id: orders_list_view_delegate_rect

            width: orders_list_view.width
            height: delegate_list_view.height + (delegate_list_view.height * 0.1)

            color: "transparent"


            Component.onCompleted: {

                var json_obj = JSON.parse(json_string);

                for(var i = 0; i < json_obj.length; i++)
                {
                    delegate_model.append(json_obj[i]);
                }
            }

            ListModel {
                id: delegate_model
            }

            ListView {
                id: delegate_list_view

                delegate: delegate_list_delegate

                width: parent.width * 0.9
                height: count * 20

                anchors.centerIn: parent

                clip: false

                model: delegate_model
            }

//            DropShadow {
//                anchors.fill: delegate_list_view
//                horizontalOffset: 0
//                verticalOffset: 1
//                radius: 4.0
//                samples: 17
//                color: "#80000000"
//                source: delegate_list_view
//            }


            Component {
                id: delegate_list_delegate // lol

                Rectangle {

                    width: parent.width
                    height: 20

                    Rectangle {

                        id: route_from_icon_wrapper

                        height: route_container_item_heigth
                        width: height

                        //                        anchors.left: parent.left

                        color: "transparent"
                        Image {
                            id: route_from_icon

                            height: parent.height * 0.3
                            width: height

                            smooth: true

                            anchors.centerIn: parent

                            source: route_from_icon_source
                        }
                    }

                    Rectangle {
                        anchors.left: route_from_icon_wrapper.right
                        anchors.verticalCenter: route_from_icon_wrapper.verticalCenter

                        width: parent.width - route_from_icon_wrapper.width
                        height: route_container_item_heigth

                        color: "transparent"

                        Text {
                            id: route_text_from
                            text: address_text // "Московский пр., 205"

                            font.pointSize: 8
                            font.family: sf_font.name

                            wrapMode: Text.WordWrap

                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Rectangle {
                            height: 2
                            width: parent.width

                            visible: false

                            anchors.bottom: parent.bottom
                            color: "lightgray"
                        }
                    }
                }
            }
        }







    }
}
