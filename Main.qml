import QtQuick 2.5
import QtQuick.Controls 2.0

import QtPositioning 5.3
import QtLocation 5.6

Rectangle {
    id: container

    signal get_order (string address,
                      int current_index);

    property int full_picture_height: 1080

    property int top_menu_relative_height: 95
    property int order_menu_relative_height: 132
    property int bottom_menu_relative_height: 266

    property real delegate_picture_koef: 227 / 512


    property int delegate_text_point_size: 10
    property int top_menu_text_point_size: 10

    property int top_menu_heigth: top_menu_relative_height * (height / full_picture_height)
    property int order_menu_row_height: order_menu_relative_height * (height / full_picture_height)
    property int bottom_menu_height: bottom_menu_relative_height * (height / full_picture_height)

    //    property int  top_menu_heigth: 45
    //    property int  order_menu_row_height: 70
    property real delegate_active_marker_height_koef: 0.05
    property string top_menu_icon_source: "qrc:/img/grey_menu.png"


    property real address_input_container_width_koef: 0.9
    property real address_input_field_width_koef: 0.9
    property string address_input_image_source: "qrc:/img/black_pencil.png"
    property string address_input_text_field_placeholder: "Адрес..."

    property real button_i_am_here_width_koef: 0.9
    property string button_i_am_here_image_source: "qrc:/img/yellow_triangle.png"

    property real map_to_input_spacer_height_koef: 0.02
    property real address_to_button_spacer_height_koef: 0.1
    property real menu_to_list_spacer_height_koef: 0.02

    property real address_top_spacer_height_koef: 0.1
    property int address_top_spacer_height: 10

    property real map_height_koef: 0.4
    property real map_width_koef:  0.95


    property real white_container_opacity: 0.7
    property string address_street_text_text: "Московский пр., 105"
    property string address_city_text_text: "Красноярск"


    FontLoader {
        id: sf_font
        source: "qrc:/fonts/SFUIDisplay-Regular.otf"
    }

    FontLoader {
        id: sf_font_thin
        source: "qrc:/fonts/SFUIDisplay-Thin.otf"
    }

    Component.onCompleted: {
        order_list_model.append({"delegate_image_text" : "Бомбила",
                                    "delegate_image_source" : "qrc:/img/taxi_rubl_crop.png",
                                    "delegate_image_source_active" : "qrc:/img/taxi_select_rubl_crop.png"});
        order_list_model.append({"delegate_image_text" : "Официальный перевозчик",
                                    "delegate_image_source" : "qrc:/img/taxi_percent_crop.png",
                                    "delegate_image_source_active" : "qrc:/img/taxi_select_percent_crop.png"});
        order_list_model.append({"delegate_image_text" : "Минивен",
                                    "delegate_image_source" : "qrc:/img/taxi_crop.png",
                                    "delegate_image_source_active" : "qrc:/img/taxi_select_crop.png"});
    }

    Plugin {
        id: myPlugin
        name: "osm"
        PluginParameter { name: "osm.mapping.copyright"; value: "" }
                PluginParameter { name: "osm.mapping.host"; value: "http://a.tile.openstreetmap.org/" }
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

        //        Component.onCompleted: update()
    }

    //    GeocodeModel {
    //         id: geocodeModel
    //         plugin: map.plugin
    //         onStatusChanged: {
    //             if ((status == GeocodeModel.Ready) || (status == GeocodeModel.Error))
    //                 map.geocodeFinished()
    //         }
    //         onLocationsChanged:
    //         {
    //             if (count == 1) {
    //                 map.center.latitude = get(0).coordinate.latitude
    //                 map.center.longitude = get(0).coordinate.longitude
    //             }
    //         }
    //     }

    PositionSource {
        id: positionSource
        property variant lastSearchPosition: locationOslo
        active: true
        updateInterval: 120000 // 2 mins
        onPositionChanged:  {
            var currentPosition = positionSource.position.coordinate
            map.center = currentPosition
            /*            var distance = currentPosition.distanceTo(lastSearchPosition)
            if (distance > 500) {
                // 500m from last performed pizza search
                lastSearchPosition = currentPosition
                searchModel.searchArea = QtPositioning.circle(currentPosition)
                searchModel.update()
            }*/
        }
    }

    Map {
        id: map

        //        anchors.top: menu_to_list_spacer.bottom
        //        anchors.horizontalCenter: parent.horizontalCenter

        //        anchors.fill: parent

        width: parent.width
        height: parent.height + 100

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
                    Image { id: image; width: 50; height: 50; source: "qrc:/marker.png" }
                }
            }
        }

        Rectangle {
            id: in_map_container

            width: container.width
            height: container.height

            color: "transparent"

            Rectangle {
                id: top_menu

                color: "black"
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
                }

                Text {
                    id: top_menu_text
                    text: qsTr("Такси Крылья")

                    font.pointSize: top_menu_text_point_size

                    color: "white"

                    anchors.left: top_menu_icon_wrapper.right
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle {
                id: order_menu_list_view_container
                anchors.top: top_menu.bottom

                width: parent.width
                height: order_menu_row_height

                color: "transparent"

                Rectangle {
                    anchors.fill: parent
                    color: "white"

                    opacity: white_container_opacity
                }

                ListView {
                    id: order_menu_list_view

                    model: order_list_model
                    delegate: order_menu_delegate

                    anchors.fill: parent

                    orientation: Qt.Horizontal

                    //                highlight: Rectangle{
                    //                    width: order_menu_list_view.currentItem.width
                    //                    height: order_menu_list_view.currentItem.height * delegate_active_marker_height_koef
                    //                    color: "blue"
                    //                }

                    highlightFollowsCurrentItem: true
                    highlightMoveDuration: 500
                    highlightMoveVelocity: 100

                    Component {
                        id: order_menu_delegate

                        Rectangle {

                            id: order_menu_delegate_container
                            width: order_menu_list_view.width / 3
                            height: order_menu_list_view.height

                            color: "transparent"

                            property bool is_active: ListView.isCurrentItem

                            Image {
                                id: delegate_image
                                source: parent.is_active?delegate_image_source_active:delegate_image_source

                                height: width * delegate_picture_koef
                                width: parent.width * 0.55

                                smooth: true

                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Rectangle {
                                id: delegate_text_wrapper
                                anchors.top: parent.top

                                width: parent.width
                                height: parent.height - delegate_image.height

                                Text {
                                    id: delegate_text
                                    text: delegate_image_text

                                    horizontalAlignment: Text.Center

                                    width: parent.width

                                    smooth: true

                                    color: order_menu_delegate_container.is_active ? "blue" : "black"

                                    wrapMode: Text.WordWrap

                                    font.family: sf_font.name
                                    font.pointSize: delegate_text_point_size

                                    anchors.centerIn: parent
                                }

                            }


                            Rectangle {
                                id: delegate_active_marker

                                anchors.bottom: parent.bottom

                                visible: parent.is_active

                                height: parent.height * delegate_active_marker_height_koef
                                width: parent.width

                                color: "blue"
                            }

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    order_menu_list_view.currentIndex = index
                                }
                            }
                        }
                    }
                }

                ListModel{
                    id: order_list_model
                }

            }

            //        Rectangle {
            //            id: menu_to_list_spacer

            //            height: parent.height * menu_to_list_spacer_height_koef
            //            width: parent.width

            //            anchors.top: order_menu_list_view.bottom
            //            anchors.horizontalCenter: parent.horizontalCenter
            //        }



            //        Rectangle {
            //            id: map_to_input_spacer

            //            height: parent.height * map_to_input_spacer_height_koef
            //            width: parent.width

            //            anchors.top: map.bottom
            //            anchors.horizontalCenter: parent.horizontalCenter
            //        }

            Rectangle {
                id: bottom_menu_container

                anchors.bottom: parent.bottom

                height: bottom_menu_height
                width: parent.width

                color: "transparent"

                Rectangle {
                    anchors.fill: parent
                    color: "white"

                    opacity: white_container_opacity
                }

                Rectangle {
                    id: address_top_spacer

                    height: address_top_spacer_height // 10 // parent.height * address_top_spacer_height_koef
                    width: parent.width

                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter

                    color: "transparent"
                }

                Rectangle
                {
                    id: address_input_container
                    width: parent.width * address_input_container_width_koef

                    height:  address_input_wrapper.height + address_city_text.height
                    anchors.top: address_top_spacer.bottom
                    anchors.horizontalCenter: parent.horizontalCenter

                    color: "transparent"

                    Rectangle {
                        id: address_input_wrapper

                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter

                        height: address_street_text.height
                        width: address_street_text.width + address_input_image.width

                        color: "transparent"

                        Text {
                            id: address_street_text

                            horizontalAlignment: Text.Center

                            font.family: sf_font_thin.name
                            font.pointSize: 14

                            text: address_street_text_text
                        }

                        Rectangle {
                            color: "transparent"
                            anchors.left: address_street_text.right
                            height: address_street_text.height
                            width: height

                            Image {
                                id: address_input_image
                                source: address_input_image_source

                                width: parent.width * 0.6
                                height: width

                                anchors.centerIn: parent
                            }
                        }
                    }

                    Text {
                        id: address_city_text
                        text: address_city_text_text

                        horizontalAlignment: Text.Center

                        font.family: sf_font.name
                        font.pointSize: 8

                        color: "lightgray"

                        anchors.top: address_input_wrapper.bottom
                        anchors.horizontalCenter: address_input_wrapper.horizontalCenter
                    }
                }

                Rectangle {
                    id: address_to_button_spacer

                    height: parent.height * address_to_button_spacer_height_koef
                    width: parent.width

                    anchors.top: address_input_container.bottom
                    anchors.horizontalCenter: parent.horizontalCenter

                    color: "transparent"
                }


                Rectangle {
                    id: button_i_am_here

                    width: parent.width * button_i_am_here_width_koef
                    height: 0.4 * parent.height

                    color: "transparent"

                    anchors.top: address_to_button_spacer.bottom
                    anchors.horizontalCenter: parent.horizontalCenter

                    Image {
                        id: button_i_am_here_image

                        source: button_i_am_here_image_source

                        anchors.horizontalCenter: parent.horizontalCenter

                        y: -15

                        height: 35 // parent.height * 0.1
                        width: 35 // parent.width * 0.1
                    }

                    Rectangle {
                        id: button_i_am_here_rect


                        visible: true
                        color: "#fcc900"

                        radius: 5

                        width: parent.width
                        height: parent.height * 0.9

                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text {
                            text: "Я ЗДЕСЬ!"
                            anchors.centerIn: parent

                            font.family: sf_font.name
                            font.pointSize: 14
                            //                        font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                var json_obj = [{"address_text" : address_street_text.text}];
                                var json_string = JSON.stringify(json_obj);

                                console.log(json_string)

                                container.get_order(json_string,
                                                    order_menu_list_view.currentIndex);
                            }
                        }
                    }
                }
            }
        }
    }
}
