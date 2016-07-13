import QtQuick.Window 2.2
import QtQuick 2.0

Window {
    width: 253
    height: 450
    visible: true

    title: qsTr("Hello world")


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
        order.set_from_address = address;
        order.set_list_current_index = current_index;

        main.visible = false;
        order.visible = true;
    }

    function backToMain()
    {
        order.visible = false;
        main.visible = true;
    }

    function backToOrder()
    {
        order.visible = true;
        wait.visible = false;
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

    function cancelOrder()
    {
       wait.visible = false;
       main.visible = true;
    }

    Component.onCompleted: {
        main.get_order.connect(getOrder)

        order.back_to_main.connect(backToMain)
        order.get_cost.connect(getCost)
        order.get_order_go.connect(getOrderGo)

        wait.back_to_order.connect(backToOrder)
        wait.cancel_order.connect(cancelOrder)

    }

    Main {
        id: main

        visible: true
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
