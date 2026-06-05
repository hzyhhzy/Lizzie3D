import QtQuick

Rectangle {
    id: hoverCoordinateBadge
    required property var app
    property var screenPoint: app.hoverLabelPoint()

    visible: app.hoverKey !== ""
    x: screenPoint.x - width / 2
    y: screenPoint.y - height - 6
    z: 5
    width: hoverCoordinateText.implicitWidth + 28
    height: 34
    radius: 8
    color: "#eaf8ef"
    border.color: "#2fb97f"
    border.width: 2

    Text {
        id: hoverCoordinateText
        anchors.centerIn: parent
        text: app.hoverKey === "" ? "" : app.coordinateText(app.hoverX, app.hoverY, app.hoverZ)
        color: "#12633e"
        font.pixelSize: 18
        font.bold: true
    }
}
