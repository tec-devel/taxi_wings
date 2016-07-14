import QtQuick 2.0

import QtPositioning 5.3
import QtLocation 5.6

Item {

    id: container

    signal back_to_order
    signal cancel_order


    property int full_picture_height: 1080



    property int top_menu_relative_height: 95
    property int order_label_relative_height: 50
    property int order_to_route_spacer_relative_height: 60
    property int route_and_cost_container_relative_height: 200
    property int cancel_button_relative_height: 88

    property int top_menu_heigth: top_menu_relative_height * (height / full_picture_height)
    property int order_label_height: order_label_relative_height * (height / full_picture_height)
    property int order_to_route_spacer_height: order_to_route_spacer_relative_height * (height / full_picture_height)
    property int route_and_cost_container_height: route_and_cost_container_relative_height * (height / full_picture_height)
    property int cancel_button_height: cancel_button_relative_height * (height / full_picture_height)


    property string top_menu_icon_source: "qrc:/img/back.png"
    property string top_menu_logo_source: "qrc:/img/logo.png"
    property string reload_icon_source: ""

    property int route_container_item_heigth: route_and_cost_container_height / 2

    property string route_from_icon_source: "qrc:/img/dot.png"
    property string route_to_icon_source: "qrc:/img/yellow_arrow.png"

    property int horizontal_label_width: 30

    property string set_from_address: ""
    property string set_to_address: ""
    property string set_order_cost: ""


    FontLoader {
        id: sf_font
        source: "qrc:/fonts/SFUIDisplay-Regular.otf"
    }

    FontLoader {
        id: sf_font_thin
        source: "qrc:/fonts/SFUIDisplay-Thin.otf"
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
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    container.back_to_order();
                }
            }
        }

        Text {
            id: top_current_text
            text: qsTr("ЗАКАЗ")

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

        Text {
            id: top_trips_text
            text: qsTr("")

            //            anchors.right: parent.right
            anchors.left: top_menu_logo.right
            anchors.verticalCenter: parent.verticalCenter

            horizontalAlignment: Text.Center
        }

        Rectangle {

            id: reload_icon_wrapper

            height: parent.height * 0.9
            width: height

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: top_trips_text.right

            color: "transparent"

            Image {
                id: reload_icon

                height: parent.height * 0.5
                width: height

                smooth: true

                anchors.centerIn: parent

                source: reload_icon_source
            }
        }
    }







    Plugin {
        id: myPlugin
        name: "osm"
        PluginParameter { name: "osm.mapping.copyright"; value: "" }
        //        PluginParameter { name: "osm.mapping.host"; value: "http://osm.tile.server.address/" }
        //        PluginParameter { name: "osm.mapping.copyright"; value: "All mine" }
        //        PluginParameter { name: "osm.routing.host"; value: "http://osrm.server.address/viaroute" }
        //        PluginParameter { name: "osm.geocoding.host"; value: "http://geocoding.server.address" }
    }

    property variant locationOslo: QtPositioning.coordinate( 59.93, 10.76)

    PlaceSearchModel {
        id: searchModel

        plugin: myPlugin

        searchTerm: "Pizza"
        searchArea: QtPositioning.circle(locationOslo)

        Component.onCompleted: update()
    }

    PositionSource {
        id: positionSource
        property variant lastSearchPosition: locationOslo
        active: true
        updateInterval: 120000 // 2 mins
        onPositionChanged:  {
            var currentPosition = positionSource.position.coordinate
            map.center = currentPosition
            var distance = currentPosition.distanceTo(lastSearchPosition)
            if (distance > 500) {
                // 500m from last performed pizza search
                lastSearchPosition = currentPosition
                searchModel.searchArea = QtPositioning.circle(currentPosition)
                searchModel.update()
            }
        }
    }

    Rectangle {
        id: on_map_container

        x: map.x
        y: map.y

        width: parent.width
        height: parent.height * 0.3

        color: "transparent"
    }

    Map {
        id: map

        anchors.top: top_menu.bottom

        width: parent.width
        height: parent.height * 0.3 + 50

        plugin: myPlugin;
        center: locationOslo
        zoomLevel: 17

        //        height: parent.height * map_height_koef // 0.5
        //        width: parent.width * map_width_koef // 0.95

        MapItemView {
            model: searchModel
            delegate: MapQuickItem {
                coordinate: place.location.coordinate

                anchorPoint.x: image.width * 0.5
                anchorPoint.y: image.height

                sourceItem: Column {
                    Image { id: image; source: "qrc:/marker.png" }
                    Text { text: title; font.bold: true }
                }
            }
        }
    }



    Rectangle {
        id: order_label

        width: parent.width
        height: order_label_height // 30

        anchors.top: on_map_container.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            id: order_label_spacer

            height: parent.height
            width: horizontal_label_width

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
        }

        Text {
            id: order_label_text

            //                text: "The date is: " + new Date().toLocaleDateString(Qt.locale("ru_RU"))



            text: qsTr("Заказ на "
                       + new Date().toLocaleDateString(Qt.locale("ru_RU"), "d MMMM")
                       + ", "
                       + new Date().toLocaleTimeString(Qt.locale("ru_RU"), "h:mm"))

            font.pointSize: 10
            font.family: sf_font.name

            anchors.left: order_label_spacer.right
        }
    }


    Rectangle {
        id: driver_search_label

        width: parent.width
        height: order_label_height // 30

        anchors.top: order_label.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            id: driver_search_label_spacer

            height: parent.height
            width: horizontal_label_width

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
        }

        Text {
            id: drive_search_label_text
            text: qsTr("Идет поиск водителя...")

            font.pointSize: 10
            font.family: sf_font.name

            anchors.left: driver_search_label_spacer.right
        }
    }

    Rectangle {
        id: order_to_route_spacer

        anchors.top: driver_search_label.bottom

        width: parent.width
        height: order_to_route_spacer_height
    }

    Rectangle {
        id: route_and_cost_container

        width: parent.width
        height: route_and_cost_container_height // parent.height * 0.18

        anchors.top: order_to_route_spacer.bottom

        Rectangle {
            id: route_container

            anchors.left: parent.left

            width: parent.width * 0.7
            height: parent.height


            /// ELEMENTS FROM

            Rectangle {

                id: route_from_icon_wrapper

                height: route_container_item_heigth
                width: height

                anchors.left: parent.left

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
                    text: set_from_address // "Московский пр., 205"

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

            Rectangle {
                id: line_from_to_to

                //            anchors.top: route_from_icon_wrapper.bottom
                //            anchors.horizontalCenter: route_from_icon_wrapper.horizontalCenter

                x: route_from_icon.x + route_from_icon.width / 2
                y: route_from_icon.y + route_from_icon.height

                height: route_to_icon_wrapper.y - route_from_icon_wrapper.y
                width: 2

                color: "black"
            }

            /// ELEMENTS TO


            Rectangle {

                id: route_to_icon_wrapper

                height: route_container_item_heigth // parent.height * 0.9
                width: height

                anchors.horizontalCenter: route_from_icon_wrapper.horizontalCenter
                anchors.top: route_from_icon_wrapper.bottom

//                x: line_from_to_to.x - width / 2
//                y: line_from_to_to.y + line_from_to_to.height - (height - route_to_icon.height) / 2 //  + height / 2

                color: "transparent"
                Image {
                    id: route_to_icon

                    height: parent.height // * 0.7
                    width: height

                    smooth: true

                    anchors.centerIn: parent

                    source: route_to_icon_source
                }
            }

            Rectangle {
                anchors.left: route_to_icon_wrapper.right
                anchors.verticalCenter: route_to_icon_wrapper.verticalCenter

                width: parent.width - route_to_icon_wrapper.width
                height: route_container_item_heigth

                color: "transparent"

                Text {
                    id: route_text_to
                    text: set_to_address //"Краснопутиловская ул., 100"

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


        Rectangle {
            id: cost_rect

            height: route_container.height
            width: parent.width * 0.3

            anchors.left: route_container.right
            anchors.verticalCenter: route_container.verticalCenter

            Text {
                anchors.centerIn: parent

                font.pointSize: 18
                font.family: sf_font.name

                text: set_order_cost + " р" // "115 р"
            }
        }
    }

    Rectangle {
        id: cancel_button

        width: parent.width
        height: cancel_button_height

        color: "#fcc900"

        anchors.bottom: parent.bottom

        Text {
            id: cancel_button_text
            text: qsTr("ОТМЕНИТЬ ЗАКАЗ")
            anchors.centerIn: parent

            font.pointSize: 10
            font.family: sf_font_thin.name
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                container.cancel_order();
            }
        }
    }
}
