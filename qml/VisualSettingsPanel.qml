import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: visualPanel
    required property var app
    required property Item branchPanelItem
    anchors.right: branchPanelItem.left
    anchors.rightMargin: app.panelGap
    anchors.top: parent.top
    anchors.topMargin: app.topContentMargin
    width: app.controlPanelWidth
    height: app.visualPanelHeight
    radius: 8
    color: "#f3f7f9"
    border.color: "#b9c8d0"
    clip: true

    Flickable {
        id: visualPanelFlick
        anchors.fill: parent
        anchors.margins: app.panelInnerMargin
        clip: true
        interactive: contentHeight > height
        contentWidth: width
        contentHeight: visualPanelContent.implicitHeight
        boundsBehavior: Flickable.StopAtBounds

        ScrollBar.vertical: ScrollBar {
            policy: visualPanelFlick.contentHeight > visualPanelFlick.height
                    ? ScrollBar.AsNeeded
                    : ScrollBar.AlwaysOff
        }

        ColumnLayout {
        id: visualPanelContent
        width: visualPanelFlick.width
        spacing: app.compactLayout ? 5 : 8

        Label {
            text: app.trText("boardSize") + " / " + app.trText("visualSettings")
            color: "#17212a"
            font.pixelSize: app.compactLayout ? 16 : 18
            font.bold: true
            Layout.fillWidth: true
        }

        Label {
            text: app.trText("boardSize") + "  " + app.boardSize + "x" + app.boardSize + "x" + app.boardSize
            color: "#2f414c"
            font.pixelSize: app.compactLayout ? 12 : 14
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.fillWidth: true

            SpinBox {
                from: app.minBoardSize
                to: app.maxBoardSize
                value: app.boardSize
                editable: true
                Layout.fillWidth: true
                onValueModified: {
                    app.focusBoardInput()
                    app.setBoardSize(value)
                }
            }

            Button {
                text: app.trText("reset")
                Layout.preferredWidth: app.compactLayout ? 56 : 62
                onClicked: {
                    app.focusBoardInput()
                    app.setBoardSize(app.defaultBoardSize)
                }
            }
        }

        Label {
            text: app.trText("stoneSize") + "  " + Math.round(app.stoneScale * 100) + "%"
            color: "#2f414c"
            font.pixelSize: app.compactLayout ? 12 : 14
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.fillWidth: true

            Slider {
                from: app.minStoneScale
                to: 1.00
                value: app.stoneScale
                stepSize: 0.01
                Layout.fillWidth: true
                onMoved: app.stoneScale = value
            }

            Button {
                text: app.trText("reset")
                Layout.preferredWidth: app.compactLayout ? 56 : 62
                onClicked: {
                    app.focusBoardInput()
                    app.stoneScale = app.defaultStoneScale
                }
            }
        }

        Label {
            text: app.trText("moveNumberDisplay") + "  " + app.moveNumberDisplayText()
            color: "#2f414c"
            font.pixelSize: app.compactLayout ? 12 : 14
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.fillWidth: true

            ComboBox {
                model: [
                    app.trText("moveNumberAll"),
                    app.trText("moveNumberLastOnly"),
                    app.trText("moveNumberHidden")
                ]
                currentIndex: app.moveNumberDisplayMode
                Layout.fillWidth: true
                onActivated: function(index) {
                    app.focusBoardInput()
                    app.moveNumberDisplayMode = index
                }
            }

            Button {
                text: app.trText("reset")
                Layout.preferredWidth: app.compactLayout ? 56 : 62
                onClicked: {
                    app.focusBoardInput()
                    app.moveNumberDisplayMode = app.defaultMoveNumberDisplayMode
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: app.compactLayout ? 4 : 8

            CheckBox {
                text: app.trText("stoneLighting")
                checked: app.stoneLightingEnabled
                font.pixelSize: app.compactLayout ? 11 : 13
                Layout.fillWidth: true
                onToggled: {
                    app.focusBoardInput()
                    app.stoneLightingEnabled = checked
                }
            }

            CheckBox {
                text: app.trText("lightFollowsCamera")
                checked: app.lightFollowsCamera
                font.pixelSize: app.compactLayout ? 11 : 13
                Layout.fillWidth: true
                onToggled: {
                    app.focusBoardInput()
                    app.lightFollowsCamera = checked
                }
            }
        }

        Label {
            text: app.trText("gridPointOpacity") + "  " + Math.round(app.gridOpacity * 100) + "%"
            color: "#2f414c"
            font.pixelSize: app.compactLayout ? 12 : 14
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.fillWidth: true

            Slider {
                from: 0.12
                to: 0.9
                value: app.gridOpacity
                stepSize: 0.01
                Layout.fillWidth: true
                onMoved: app.gridOpacity = value
            }

            Button {
                text: app.trText("reset")
                Layout.preferredWidth: app.compactLayout ? 56 : 62
                onClicked: {
                    app.focusBoardInput()
                    app.gridOpacity = app.defaultGridOpacity
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: app.compactLayout ? 4 : 8

            CheckBox {
                text: app.trText("hideLines")
                checked: app.hideGridLines
                font.pixelSize: app.compactLayout ? 11 : 13
                Layout.fillWidth: true
                onToggled: {
                    app.focusBoardInput()
                    app.hideGridLines = checked
                }
            }

            CheckBox {
                text: app.trText("hidePoints")
                checked: app.hideGridPoints
                font.pixelSize: app.compactLayout ? 11 : 13
                Layout.fillWidth: true
                onToggled: {
                    app.focusBoardInput()
                    app.hideGridPoints = checked
                }
            }
        }

        Label {
            text: app.trText("hiddenTransparency") + "  " + Math.round(app.hiddenLayerTransparency * 100) + "%"
            color: "#2f414c"
            font.pixelSize: app.compactLayout ? 12 : 14
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.fillWidth: true

            Slider {
                from: 0.2
                to: 1.0
                value: app.hiddenLayerTransparency
                stepSize: 0.01
                Layout.fillWidth: true
                onMoved: app.hiddenLayerTransparency = value
            }

            Button {
                text: app.trText("reset")
                Layout.preferredWidth: app.compactLayout ? 56 : 62
                onClicked: {
                    app.focusBoardInput()
                    app.hiddenLayerTransparency = app.defaultHiddenLayerTransparency
                }
            }
        }
        }
    }
}
