import QtQuick.Window 2.2
import QtQuick 2.0

Window {
    width: 253
    height: 450
    visible: true

    title: qsTr("Hello world")

    property int splash_timer_interval: 5

    Timer{
        id: splash_timer
        interval: splash_timer_interval

        repeat: false
        onTriggered: {
            main.visible = true;
            splash.visible = false;
        }
    }

    Timer{
        id:test_timer

        interval: 500

        repeat: false

        onTriggered: {
            var cost = Math.random() % 200;

            if(cost < 150)
                cost = 149;

            order.set_button_go_cost_text = cost;
        }
    }

    function getOrder(address, current_index)
    {
        console.log("getOrder", address)
        order.set_address_json_string = address;
        order.set_list_current_index = current_index;

        main.visible = false;
        order.visible = true;
    }

    function gotoOrderMain()
    {
        main.visible = true;
        order.visible = false;
    }

    function gotoOrderOrders()
    {
        orders.visible = true;
        order.visible = false;
    }

    function getCost(address_from,
                     address_to)
    {
        test_timer.start()
    }

    function getOrderGo(address_from,
                        address_to,
                        cost)
    {
        order.visible = false;
        wait.visible = true;

        wait.set_from_address = address_from;
        wait.set_to_address = address_to;
        wait.set_order_cost = cost;
    }


    function backToOrder()
    {
        order.visible = true;
        wait.visible = false;
    }

    function cancelOrder()
    {
       wait.visible = false;
       main.visible = true;
    }


    function gotoOrdersOrder()
    {

        console.log("1234")
        order.visible = true;
        orders.visible = false;
    }

    function gotoOrdersOrderWithAddress(json_string)
    {
    }



    Component.onCompleted: {
        splash_timer.start();

        main.get_order.connect(getOrder)

        order.goto_order_main.connect(gotoOrderMain)
        order.goto_order_orders.connect(gotoOrderOrders)

        order.get_cost.connect(getCost)
        order.get_order_go.connect(getOrderGo)

        orders.goto_orders_order.connect(gotoOrdersOrder)
        orders.goto_orders_order_with_address.connect(gotoOrdersOrderWithAddress)

        wait.back_to_order.connect(backToOrder)
        wait.cancel_order.connect(cancelOrder)
    }

    Splash {
        id: splash

        visible: true
        anchors.fill: parent
    }

    Main {
        id: main

        visible: true
        anchors.fill: parent
    }

    Orders {
        id: orders

        visible: false
        anchors.fill: parent
    }

    Order {
        id: order

        visible: false
        anchors.fill: parent
    }

    Wait {
        id: wait

        visible: false
        anchors.fill: parent
    }
}
