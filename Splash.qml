import QtQuick 2.0

Rectangle {
    id: container

    property int splash_width_max: 500

    property string splash_image_source: "qrc:/img/1.jpg"
    property int splash_image_size: container.width > splash_width_max ? splash_width_max : (container.width * 0.9)

    anchors.fill: parent

    color: "#1d1d1d"

    Rectangle {
        id: splash_image_container

        color: "transparent"

        anchors.centerIn: parent

        width: splash_image_size
        height: splash_image_size

        Image {
            id: splash_image
            source: splash_image_source
            anchors.fill: parent

            smooth: true
        }
    }
}
