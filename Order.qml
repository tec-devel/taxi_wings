import QtQuick 2.0
import QtQuick.Controls 2.0

Item {

    id: container

    signal goto_order_main
    signal goto_order_orders

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
    property int button_add_adress_container_relative_heigth: 88
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
    property int button_add_adress_container_heigth: button_add_adress_container_relative_heigth * (height / full_picture_height)
    property int button_go_container_height: button_go_container_relative_height * (height / full_picture_height)

    property int top_menu_font_size: 12
    property string yelow_collor_code: "#fcc900"

    property real delegate_active_marker_height_koef: 0.05

    property real menu_to_list_spacer_height_koef: 0.02
    property string top_menu_icon_source: "qrc:/img/back.png"
    property string top_menu_logo_source: "qrc:/img/logo.png"


    property int route_container_item_heigth: route_container_height / 3

    property string route_from_icon_source: "qrc:/img/dot.png"
    property string route_to_icon_source: "qrc:/img/yellow_arrow.png"

    property string clock_icon_source: "qrc:/img/clock.png"

    property real route_container_width_koef: 0.9
    property real route_container_height_koef: 0.5

    property string add_address_icon_source: "qrc:/img/dot_plus.png"
    property real add_address_button_width_koef: 0.9

    property real white_container_opacity: 1
    property string order_requirements_icon_source: ""


    property int set_list_current_index: 0

    property string set_button_go_cost_text: ""

    property string set_address_json_string: ""


    onSet_button_go_cost_textChanged: {
        button_cost_calc_indicator.visible = false;
        button_go_cost_text.visible = true;
    }

    onSet_address_json_stringChanged: {
        var json_route_object = JSON.parse(set_address_json_string);

        console.log(json_route_object.length, set_address_json_string);
        console.log(json_route_object);


        if(json_route_object.length >= 1)
        {
            route_list_model.clear();

            for(var i = 0; i < json_route_object.length; i++)
                route_list_model.append(json_route_object[i])

            if(json_route_object.length === 1)
                route_list_model.append({"address_text":""});
        }
    }

    onVisibleChanged: {
        if(visible)
        {
            set_button_go_cost_text = ""

            button_cost_calc_indicator.visible = true;
            button_go_cost_text.visible = false;

            //            container.get_cost(route_text_from.text,
            //                               route_text_to.text);
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

        //        route_list_model.append({"address_text":"address1"});
        //        route_list_model.append({"address_text":"address2"});
        //        route_list_model.append({"address_text":"address3"});
        //        route_list_model.append({"address_text":"address4"});
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
                        container.goto_order_main()
                    }
                }
            }
        }

        Rectangle {
            id: top_current_text_wrapper

            anchors.left: top_menu_icon_wrapper.right
            anchors.right: top_menu_logo.left

            height: parent.height

            Text {
                id: top_current_text
                text: qsTr("ЗАКАЗ")

                font.family: sf_font.name
                font.pointSize: top_menu_font_size

                anchors.centerIn: parent

                horizontalAlignment: Text.Center
            }

            Rectangle {
                id: top_current_text_acitve

                height: 3

                width: parent.width

                color: yelow_collor_code

                anchors.bottom: parent.bottom
            }
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

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    container.goto_order_orders()
                }
            }
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

            width: parent.width

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

        ListView {
            id: route_list_view
            delegate: route_list_view_delegate
            model: route_list_model

            clip: true

            width: parent.width
            height: ((count * route_container_item_heigth) > parent.height) ? parent.height : count * route_container_item_heigth
        }

        ListModel {
            id: route_list_model
        }

        Component {
            id: route_list_view_delegate

            Rectangle {
                width: route_list_view.width
                height: route_container_item_heigth

                Rectangle {

                    id: route_from_icon_wrapper_delegate

                    height: parent.height // route_container_item_heigth
                    width: height

                    anchors.left: parent.left

                    color: "transparent"
                    Image {
                        id: route_from_icon_delegate

                        height: parent.height * 0.3
                        width: height

                        smooth: true

                        anchors.centerIn: parent

                        source: (index != (route_list_view.count - 1)) ? route_from_icon_source : route_to_icon_source
                    }
                }


                Rectangle {
                    id: top_line

                    y: 0
                    x:
                        route_from_icon_wrapper_delegate.width / 2

                    width: 2
                    height: (route_from_icon_wrapper_delegate.height - route_from_icon_delegate.height) / 2

                    color: "black"

                    visible: index != 0
                }

                Rectangle {
                    id: bottom_line

                    y:
                        (route_from_icon_wrapper_delegate.height - route_from_icon_delegate.height) / 2 +
                        route_from_icon_delegate.height

                    x:
                        route_from_icon_wrapper_delegate.width / 2

                    width: 2
                    height: (route_from_icon_wrapper_delegate.height - route_from_icon_delegate.height) / 2

                    color: "black"

                    visible: index != (route_list_view.count - 1)
                }

                Rectangle {
                    anchors.left: route_from_icon_wrapper_delegate.right
                    anchors.verticalCenter: route_from_icon_wrapper_delegate.verticalCenter

                    width: parent.width - route_from_icon_wrapper_delegate.width
                    height: route_container_item_heigth

                    color: "transparent"

                    Component.onCompleted: {
                        route_text_input_delegate.
                        editingFinished.
                        connect(addressEditingFinished);
                    }

                    function addressEditingFinished()
                    {
                        route_text_delegate.visible = true;
                        route_text_input_delegate.visible = false;

                        var address_obj = {"address_text":route_text_input_delegate.text};

                        route_list_model.set(index, address_obj);

                        console.log(route_text_input_delegate.text);
                        console.log(index);
                    }

                    Text {
                        id: route_text_delegate

                        property string address_text_: address_text

                        text: (address_text_ == "")?"Введите адрес":address_text_

                        font.pointSize: 10
                        font.family: sf_font.name

                        color: (address_text_ == "")?"lightgray":"black"

                        anchors.verticalCenter: parent.verticalCenter


                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                route_text_input_delegate.text = parent.address_text_
                                route_text_input_delegate.visible = true;

                                route_text_input_delegate.st

                                parent.visible = false
                            }
                        }
                    }

                    Rectangle {
                        height: 2
                        width: parent.width

                        anchors.bottom: parent.bottom
                        color: "lightgray"
                    }

                    TextInput {
                        id: route_text_input_delegate

                        anchors.fill: parent

                        visible: false

                        verticalAlignment: TextInput.AlignVCenter

                        font.pointSize: 10
                        font.family: sf_font.name
                    }
                }
            }
        }

    }


    Rectangle {
        id: add_address_button

        height: button_add_adress_container_heigth
        width: parent.width * 0.9

        anchors.top: route_container.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {

            id: add_address_button_icon_wrapper

            height: parent.height * 0.7
            width: height

            color: "transparent"

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            Image {
                id: add_address_icon

                height: parent.height
                width: height

                smooth: true

                anchors.centerIn: parent

                source: add_address_icon_source
            }
        }

        Rectangle {
            id: add_address_button_text_wrapper

            height: parent.height

            anchors.left: add_address_button_icon_wrapper.right
            anchors.right: parent.right

            Text {
                id: add_button_text
                text: qsTr("Добавить адрес")
                anchors.centerIn: parent
            }
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                route_list_model.append({"address_text":""});
            }
        }
    }


    Rectangle {
        id: route_container_to_clock_spacer

        height: route_container_to_clock_spacer_height //  parent.height * menu_to_list_spacer_height_koef
        width: parent.width

        anchors.top: add_address_button.bottom
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

            color: yelow_collor_code

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
                font.pointSize: top_menu_font_size

                text: set_button_go_cost_text + " р"
            }
        }

        Rectangle {
            id: button_go_order
            width: parent.width / 2
            height: parent.height

            anchors.left: button_go_cost.right
            anchors.verticalCenter: parent.verticalCenter

            color: yelow_collor_code


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
