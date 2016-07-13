import QtQuick 2.0
import QtQuick.Controls 2.0

Item {

    id: container

    signal back_to_main
    signal get_cost(string address_from,
                    string address_to)
    signal get_order_go(string address_from,
                        string address_to,
                        string cost)




    property int full_picture_height: 1080

    property int top_menu_relative_height: 95
    property int order_menu_relative_height: 132
    property int bottom_menu_relative_height: 266
    property int route_container_relative_height: 330
    property int taxi_time_container_relative_height: 80
    property int route_container_to_clock_spacer_relative_height: 10
    property int taxi_time_to_rout_req_spacer_relative_height: 32
    property int order_requirements_container_relative_heigth: 88
    property int button_go_container_relative_height: 94


    property real delegate_picture_koef: 227 / 512


    property int delegate_text_point_size: 10
    property int top_menu_text_point_size: 10

    property int top_menu_heigth: top_menu_relative_height * (height / full_picture_height)
    property int order_menu_row_height: order_menu_relative_height * (height / full_picture_height)
    property int bottom_menu_height: bottom_menu_relative_height * (height / full_picture_height)
    property int route_container_height: route_container_relative_height * (height / full_picture_height)
    property int taxi_time_container_height: taxi_time_container_relative_height * (height / full_picture_height)
    property int route_container_to_clock_spacer_height: route_container_to_clock_spacer_relative_height * (height / full_picture_height)
    property int taxi_time_to_rout_req_spacer_height: taxi_time_to_rout_req_spacer_relative_height * (height / full_picture_height)
    property int order_requirements_container_heigth: order_requirements_container_relative_heigth * (height / full_picture_height)
    property int button_go_container_height: button_go_container_relative_height * (height / full_picture_height)

    //    property int  top_menu_heigth: 80
    //    property int  order_menu_row_height: 100
    property real delegate_active_marker_height_koef: 0.05

    property real menu_to_list_spacer_height_koef: 0.02
    property string top_menu_icon_source: "qrc:/img/back.png"
    property string top_menu_logo_source: "qrc:/img/logo.png"


    property int route_container_item_heigth: route_container_height / 3

    property string route_from_icon_source: "qrc:/img/dot.png"
    property string route_to_icon_source: "qrc:/img/yellow_arrow.png"
    property string route_add_icon_source: "qrc:/img/dot_plus.png"

    property string clock_icon_source: "qrc:/img/clock.png"

    property real route_container_width_koef: 0.9
    property real route_container_height_koef: 0.5

    property string add_address_icon_source: ""
    property real add_address_button_width_koef: 0.9

    property real white_container_opacity: 1
    property string order_requirements_icon_source: ""


    property string set_button_go_cost_text: ""

    property int set_list_current_index: 0
    property string set_from_address: ""

    onSet_button_go_cost_textChanged: {
        button_cost_calc_indicator.visible = false;
        button_go_cost_text.visible = true;
    }

    onVisibleChanged: {
        if(visible)
        {
            set_button_go_cost_text = ""

            button_cost_calc_indicator.visible = true;
            button_go_cost_text.visible = false;

            container.get_cost(route_text_from.text,
                               route_text_to.text);
        }
    }


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
                        container.back_to_main()
                    }
                }
            }
        }

        Text {
            id: top_current_text
            text: qsTr("ЗАКАЗ")

            font.family: sf_font.name

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
            text: qsTr("ПОЕЗДКИ")

            font.family: sf_font.name

            anchors.right: parent.right
            anchors.left: top_menu_logo.right
            anchors.verticalCenter: parent.verticalCenter

            horizontalAlignment: Text.Center
        }
    }

    Rectangle {
        id: order_menu_list_view_container
        anchors.top: top_menu.bottom

        width: parent.width
        height: order_menu_row_height

        color: "red"

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

            currentIndex: set_list_current_index

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
                            //                            order_menu_list_view.currentIndex = index
                        }
                    }
                }
            }
        }

        ListModel{
            id: order_list_model
        }
    }

    Rectangle {
        id: menu_to_list_spacer

        height: 1 // parent.height * menu_to_list_spacer_height_koef
        width: parent.width

        anchors.top: order_menu_list_view_container.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Rectangle {
        id: route_container
        anchors.top: menu_to_list_spacer.bottom

        width: parent.width * 0.9
        height: route_container_height // item_heigth * 3 // parent.height * 0.35

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
                text: set_from_address

                font.pointSize: 10
                font.family: sf_font.name

                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                height: 2
                width: parent.width

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

            height: route_to_icon_wrapper.y - route_from_icon_wrapper.y // 30
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

            //            anchors.top: line_from_to_to.bottom

            x: line_from_to_to.x - width / 2
            //            y: line_from_to_to.y + line_from_to_to.height - (height - route_to_icon.height) / 2 //  + height / 2

            color: "transparent"
            Image {
                id: route_to_icon

                height: parent.height * 0.7
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
                text: "Краснопутиловская ул., 100"

                font.pointSize: 10
                font.family: sf_font.name

                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                height: 2
                width: parent.width

                anchors.bottom: parent.bottom
                color: "lightgray"
            }
        }


        /// ELEMENTS ADD BUTTON


        Rectangle {

            id: route_add_icon_wrapper

            height: route_container_item_heigth // parent.height * 0.9
            width: height

            anchors.horizontalCenter: route_to_icon_wrapper.horizontalCenter
            anchors.top: route_to_icon_wrapper.bottom

            color: "transparent"
            Image {
                id: route_add_icon

                height: parent.height * 0.5
                width: height

                smooth: true

                anchors.centerIn: parent

                source: route_add_icon_source
            }
        }

        Rectangle {
            anchors.left: route_add_icon_wrapper.right
            anchors.verticalCenter: route_add_icon_wrapper.verticalCenter

            width: parent.width - route_add_icon_wrapper.width
            height: route_container_item_heigth

            color: "transparent"

            Text {
                id: route_text_add
                text: "Добавить маршрут"

                color: "lightgray"

                font.pointSize: 10
                font.family: sf_font.name

                anchors.verticalCenter: parent.verticalCenter
            }

//            Rectangle {
//                height: 2
//                width: parent.width

//                anchors.bottom: parent.bottom
//                color: "lightgray"
//            }
        }
    }

    Rectangle {
        id: route_container_to_clock_spacer

        height: route_container_to_clock_spacer_height //  parent.height * menu_to_list_spacer_height_koef
        width: parent.width

        anchors.top: route_container.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Rectangle {
        id: taxi_time_container

        width: parent.width * 0.7
        height: taxi_time_container_height

        anchors.top: route_container_to_clock_spacer.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {

            id: clock_icon_wrapper

            height: parent.height * 0.7
            width: height

            color: "transparent"
            Image {
                id: clock_icon

                height: parent.height
                width: height

                smooth: true

                anchors.centerIn: parent

                source: clock_icon_source
            }
        }

        Rectangle {
            id: clock_time_label_wrapper

            anchors.left: clock_icon_wrapper.right

            width: parent.width - clock_icon_wrapper.width
            height: clock_icon_wrapper.height

            Text {
                id: clock_time_label

                width: parent.width

                font.pointSize: 8
                font.family: sf_font.name

                text: qsTr("Время подачи автомобиля")

                anchors.top: parent.top

                horizontalAlignment: Text.Center

                //                width: parent.width
            }

            Text {
                id: clock_time_label_

                width: clock_time_label.width

                font.pointSize: 8
                font.family: sf_font.name

                text: qsTr("Сейчас")

                anchors.top: clock_time_label.bottom
                horizontalAlignment: Text.Center

                color: "maroon"
            }
        }
    }

    Rectangle {
        id: taxi_time_to_rout_req_spacer

        height: taxi_time_to_rout_req_spacer_height
        width: parent.width

        anchors.top: taxi_time_container.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Rectangle {
        id: order_requirements_container

        width: parent.width * 0.9
        height: order_requirements_container_heigth

        border.width: 1
        border.color: "#869092"

        radius: 5

        anchors.top: taxi_time_to_rout_req_spacer.bottom
        anchors.horizontalCenter: taxi_time_container.horizontalCenter

        Rectangle {

            id: order_requirements_wrapper

            height: parent.height // parent.height * 0.9
            width: height

            anchors.right: parent.right

            color: "transparent"
            Image {
                id: order_requirements_icon

                height: parent.height * 0.7
                width: height

                smooth: true

                anchors.centerIn: parent

                source: order_requirements_icon_source
            }
        }

        Text {
            id: order_requirements_text
            text: qsTr("Пожелания к заказу")

            font.family: sf_font.name
            font.pointSize: 8

            anchors.right: order_requirements_wrapper.left
            anchors.verticalCenter: order_requirements_wrapper.verticalCenter

            width: parent.width - order_requirements_wrapper.width

            color: "#869092"

            horizontalAlignment: Text.Center
        }
    }



    Rectangle {
        id: button_go_container

        width: parent.width
        height: button_go_container_height

        anchors.bottom: parent.bottom


        Rectangle {
            id: button_go_cost
            width: parent.width / 2
            height: parent.height

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            color: "#fcc900"

            AnimatedImage {
                id: button_cost_calc_indicator
                source: "qrc:/img/ajax-loader.gif"
                anchors.centerIn: parent

                height: parent.height * 0.5
                width: height
            }

            Text {

                id: button_go_cost_text

                visible: false

                anchors.centerIn: parent

                font.family: sf_font.name
                font.pointSize: 14

                text: set_button_go_cost_text + " р"
            }
        }

        Rectangle {
            id: button_go_order
            width: parent.width / 2
            height: parent.height

            anchors.left: button_go_cost.right
            anchors.verticalCenter: parent.verticalCenter

            color: "#fcc900"


            Text {
                anchors.centerIn: parent

                font.pointSize: 10
                font.family: sf_font.name

                text: "ЗАКАЗАТЬ"
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    container.get_order_go(route_text_from.text,
                                           route_text_to.text,
                                           set_button_go_cost_text);
                }
            }
        }

        Rectangle {
            id: button_go_separator

            width: 1
            height: parent.height * 0.5

            anchors.centerIn: parent

            color: "gray"
        }
    }
}
