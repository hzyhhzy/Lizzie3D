import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: infoPanel
    required property var app

    anchors.left: parent.left
    anchors.top: parent.top
    anchors.leftMargin: app.panelMargin
    anchors.topMargin: app.topContentMargin
    width: app.infoPanelWidth
    height: app.compactLayout ? 146 : 168
    radius: 4
    color: "#3d4144"
    border.color: "#2b2f32"
    z: 45

    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        radius: 4
        color: "transparent"
        border.color: "#565c60"
        opacity: 0.55
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: app.compactLayout ? 10 : 12
        spacing: app.compactLayout ? 6 : 8

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: app.compactLayout ? 78 : 94
            spacing: app.compactLayout ? 10 : 14

            ColumnLayout {
                Layout.preferredWidth: app.compactLayout ? 86 : 98
                Layout.fillHeight: true
                spacing: 5

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Rectangle {
                        anchors.centerIn: parent
                        width: app.currentPlayer === 1 ? (app.compactLayout ? 48 : 58) : (app.compactLayout ? 34 : 42)
                        height: width
                        radius: width / 2
                        color: "#050607"
                        border.color: "#11181d"
                        border.width: 1
                    }
                }

                Label {
                    text: app.trText("captured") + ": " + app.blackCaptures
                    color: "#e3e7ea"
                    font.pixelSize: app.compactLayout ? 13 : 15
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
            }

            ColumnLayout {
                Layout.preferredWidth: app.compactLayout ? 56 : 68
                Layout.fillHeight: true
                spacing: 3

                Label {
                    text: app.currentMoveNumberText()
                    color: "#e5e8ea"
                    font.pixelSize: app.compactLayout ? 20 : 24
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: app.compactLayout ? 14 : 16
                    height: width
                    radius: width / 2
                    color: app.engineDotColor()
                    border.color: "#2b2f32"
                    border.width: 1
                }

                Label {
                    text: Number(app.komi).toFixed(1)
                    color: "#e5e8ea"
                    font.pixelSize: app.compactLayout ? 18 : 22
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
            }

            ColumnLayout {
                Layout.preferredWidth: app.compactLayout ? 86 : 98
                Layout.fillHeight: true
                spacing: 5

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Rectangle {
                        anchors.centerIn: parent
                        width: app.currentPlayer === 2 ? (app.compactLayout ? 48 : 58) : (app.compactLayout ? 34 : 42)
                        height: width
                        radius: width / 2
                        color: "#f8fbfd"
                        border.color: "#d7dee3"
                        border.width: 1
                    }
                }

                Label {
                    text: app.trText("captured") + ": " + app.whiteCaptures
                    color: "#e3e7ea"
                    font.pixelSize: app.compactLayout ? 13 : 15
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: "#2b2f32"
            opacity: 0.9
        }

        Label {
            text: app.engineCandidateSummaryText()
            color: "#e3e7ea"
            font.pixelSize: app.compactLayout ? 13 : 15
            elide: Text.ElideRight
            Layout.fillWidth: true
        }
    }
}
