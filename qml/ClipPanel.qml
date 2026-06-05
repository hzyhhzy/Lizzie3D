import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: clipPanel
    required property var app
    required property Item branchPanelItem
    required property Item visualPanelItem
    anchors.right: branchPanelItem.left
    anchors.rightMargin: app.panelGap
    anchors.top: visualPanelItem.bottom
    anchors.topMargin: app.panelGap
    anchors.bottom: parent.bottom
    anchors.bottomMargin: app.bottomContentMargin
    width: app.controlPanelWidth
    radius: 8
    color: "#f3f7f9"
    border.color: "#b9c8d0"
    clip: true

    Flickable {
        id: clipPanelFlick
        anchors.fill: parent
        anchors.margins: app.panelInnerMargin
        clip: true
        interactive: contentHeight > height
        contentWidth: width
        contentHeight: clipPanelContent.implicitHeight
        boundsBehavior: Flickable.StopAtBounds

        ScrollBar.vertical: ScrollBar {
            policy: clipPanelFlick.contentHeight > clipPanelFlick.height
                    ? ScrollBar.AsNeeded
                    : ScrollBar.AlwaysOff
        }

        ColumnLayout {
        id: clipPanelContent
        width: clipPanelFlick.width
        spacing: app.compactLayout ? 5 : 8

        RowLayout {
            Layout.fillWidth: true

            Label {
                text: app.trText("clipLayers")
                color: "#17212a"
                font.pixelSize: app.compactLayout ? 16 : 18
                font.bold: true
                Layout.fillWidth: true
            }

            Button {
                text: app.trText("reset")
                Layout.preferredWidth: app.compactLayout ? 56 : 62
                onClicked: {
                    app.focusBoardInput()
                    app.resetClipCounts()
                }
            }
        }

        Label {
            text: app.trText("activeAxis") + ": " + app.frontFacingClipAxis()
            color: "#52636d"
            font.pixelSize: 12
            Layout.fillWidth: true
        }

        Item {
            id: clipCross
            property real center: width / 2
            property real crossSize: Math.max(app.compactLayout ? 138 : 170,
                                              Math.min(app.compactLayout ? 176 : 204,
                                                       clipPanel.height * (app.compactLayout ? 0.34 : 0.42)))
            property real axisRadius: crossSize * 0.34

            width: crossSize
            height: crossSize
            Layout.alignment: Qt.AlignHCenter

            Repeater {
                model: [
                    { "dx": 1, "dy": 0, "dz": 0, "color": "#d84a43" },
                    { "dx": 0, "dy": 1, "dz": 0, "color": "#39a66a" },
                    { "dx": 0, "dy": 0, "dz": 1, "color": "#3d73d8" }
                ]

                delegate: Rectangle {
                    x: clipCross.center - width / 2
                    y: clipCross.center - height / 2
                    width: clipCross.axisRadius * 2
                    height: 3
                    radius: 2
                    rotation: app.projectedAxisAngle(modelData.dx, modelData.dy, modelData.dz)
                    transformOrigin: Item.Center
                    color: modelData.color
                    opacity: 0.56
                }
            }

            Rectangle {
                x: clipCross.center - width / 2
                y: clipCross.center - height / 2
                width: 10
                height: 10
                radius: 5
                color: "#52636d"
                opacity: 0.7
            }

            Repeater {
                model: app.clipAxes

                delegate: Rectangle {
                    id: clipBubble
                    property var bubbleCenter: app.projectedAxisPoint(modelData.dx,
                                                                       modelData.dy,
                                                                       modelData.dz,
                                                                       clipCross.center,
                                                                       clipCross.axisRadius)

                    x: bubbleCenter.x - width / 2
                    y: bubbleCenter.y - height / 2
                    width: 44
                    height: 44
                    radius: 22
                    color: clipMouse.containsMouse
                           ? "#d5edf7"
                           : app.clipCount(modelData.axis) > 0
                             ? "#eef8fb"
                             : "#ffffff"
                    border.width: 2
                    border.color: clipMouse.containsMouse ? "#3489a6" : modelData.color

                    Column {
                        anchors.centerIn: parent
                        spacing: -2

                        Text {
                            text: modelData.axis
                            color: "#41515a"
                            font.pixelSize: 10
                            horizontalAlignment: Text.AlignHCenter
                            width: clipBubble.width
                        }

                        Text {
                            text: app.clipCount(modelData.axis)
                            color: "#16212a"
                            font.pixelSize: 17
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            width: clipBubble.width
                        }
                    }

                    MouseArea {
                        id: clipMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton

                        onClicked: {
                            app.focusBoardInput()
                        }

                        onWheel: function(wheel) {
                            app.focusBoardInput()
                            app.adjustClip(modelData.axis, wheel.angleDelta.y > 0 ? 1 : -1)
                            wheel.accepted = true
                        }
                    }
                }
            }
        }

        Flickable {
            id: clipRowsFlick
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(clipRowsContent.implicitHeight,
                                             app.compactLayout ? 176 : 214)
            Layout.minimumHeight: app.compactLayout ? 88 : 150
            clip: true
            contentWidth: width
            contentHeight: clipRowsContent.implicitHeight
            boundsBehavior: Flickable.StopAtBounds

            ScrollBar.vertical: ScrollBar {
                policy: clipRowsFlick.contentHeight > clipRowsFlick.height
                        ? ScrollBar.AsNeeded
                        : ScrollBar.AlwaysOff
            }

            ColumnLayout {
                id: clipRowsContent
                width: clipRowsFlick.width
                spacing: app.compactLayout ? 3 : 6

                RowLayout {
                    Layout.fillWidth: true
                    spacing: app.compactLayout ? 4 : 6

                    Label {
                        text: app.trText("axis")
                        color: "#52636d"
                        font.pixelSize: app.compactLayout ? 11 : 12
                        Layout.preferredWidth: app.compactLayout ? 36 : 42
                    }

                    Label {
                        text: app.trText("layers")
                        color: "#52636d"
                        font.pixelSize: app.compactLayout ? 11 : 12
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                    }

                    Label {
                        text: app.trText("edit")
                        color: "#52636d"
                        font.pixelSize: app.compactLayout ? 11 : 12
                        horizontalAlignment: Text.AlignHCenter
                        Layout.preferredWidth: app.compactLayout ? 68 : 76
                    }
                }

                Repeater {
                    model: app.clipAxes

                    delegate: RowLayout {
                        Layout.fillWidth: true
                        spacing: app.compactLayout ? 4 : 6

                        Label {
                            text: modelData.axis
                            color: modelData.color
                            font.pixelSize: app.compactLayout ? 12 : 13
                            font.bold: true
                            Layout.preferredWidth: app.compactLayout ? 36 : 42
                        }

                        Label {
                            text: app.clipCount(modelData.axis)
                            color: "#16212a"
                            font.pixelSize: app.compactLayout ? 14 : 15
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            Layout.fillWidth: true
                        }

                        RowLayout {
                            spacing: app.compactLayout ? 3 : 4
                            Layout.preferredWidth: app.compactLayout ? 68 : 76

                            Button {
                                text: "-"
                                enabled: app.clipCount(modelData.axis) > 0
                                Layout.preferredWidth: app.compactLayout ? 31 : 34
                                Layout.preferredHeight: app.compactLayout ? 24 : 28
                                onClicked: {
                                    app.focusBoardInput()
                                    app.adjustClip(modelData.axis, -1)
                                }
                            }

                            Button {
                                text: "+"
                                enabled: app.clipCount(modelData.axis) < app.boardSize
                                Layout.preferredWidth: app.compactLayout ? 31 : 34
                                Layout.preferredHeight: app.compactLayout ? 24 : 28
                                onClicked: {
                                    app.focusBoardInput()
                                    app.adjustClip(modelData.axis, 1)
                                }
                            }
                        }
                    }
                }
            }
        }
        }
    }
}
