import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic as Basic
import QtQuick.Layouts

Rectangle {
    id: infoPanel
    required property var app

    anchors.left: parent.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.leftMargin: app.panelMargin
    anchors.topMargin: app.topContentMargin
    anchors.bottomMargin: app.bottomContentMargin
    width: app.infoPanelWidth
    radius: 4
    color: "transparent"
    border.width: 0
    clip: false
    z: 45

    readonly property int panelPadding: app.compactLayout ? 9 : 12
    readonly property int tableRowHeight: app.compactLayout ? 22 : 24
    readonly property int tableHeaderHeight: app.compactLayout ? 23 : 25
    readonly property int indexColumnWidth: app.compactLayout ? 38 : 44
    readonly property int winrateColumnWidth: app.compactLayout ? 54 : 62
    readonly property int visitsColumnWidth: app.compactLayout ? 60 : 68
    readonly property int summaryRowHeight: 72
    readonly property int winrateBarHeight: 40
    readonly property int winrateGraphHeight: 96
    readonly property int activeStoneSize: 44
    readonly property int inactiveStoneSize: 34
    readonly property int panelGap: app.compactLayout ? 8 : 10
    readonly property bool winrateBarVisible: app.analysisModeActive() || app.engineWinratePlaceholderActive()
    readonly property bool winrateGraphVisible: app.analysisModeActive()
    readonly property int topPanelHeight: panelPadding * 2
                                          + summaryRowHeight
                                          + (winrateBarVisible ? 6 + 1 + 6 + winrateBarHeight : 0)
                                          + (winrateGraphVisible ? 6 + winrateGraphHeight : 0)
                                          + 2
    readonly property int positionColumnWidth: Math.max(64, candidateTable.width
                                                        - indexColumnWidth
                                                        - winrateColumnWidth
                                                        - visitsColumnWidth)

    component StraightScrollBar: Basic.ScrollBar {
        id: scrollBar
        padding: 1
        minimumSize: 0.08
        implicitWidth: 10
        implicitHeight: 10

        background: Rectangle {
            color: "#d5dadd"
            radius: 0
        }

        contentItem: Rectangle {
            implicitWidth: 8
            implicitHeight: 34
            radius: 0
            color: scrollBar.pressed ? "#4b555a" : scrollBar.hovered ? "#687277" : "#7d878c"
        }
    }

    component TableHeaderCell: Rectangle {
        property string text: ""
        width: 60
        height: infoPanel.tableHeaderHeight
        color: "#c5c9cc"
        border.color: "#8d9498"
        border.width: 1

        Text {
            anchors.centerIn: parent
            text: parent.text
            color: "#2d3438"
            font.pixelSize: app.compactLayout ? 11 : 12
            font.bold: true
        }
    }

    component TableCell: Text {
        width: 60
        height: infoPanel.tableRowHeight
        color: "#15191c"
        font.pixelSize: app.compactLayout ? 12 : 13
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    Rectangle {
        id: summaryPanel
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: infoPanel.topPanelHeight
        radius: 4
        color: "#4c5458"
        border.color: "#3b4449"
        border.width: 1
        clip: true

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: 4
            color: "transparent"
            border.color: "#6a7377"
            opacity: 0.55
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: infoPanel.panelPadding
            spacing: 6

            RowLayout {
                Layout.fillWidth: true
                Layout.minimumHeight: infoPanel.summaryRowHeight
                Layout.preferredHeight: infoPanel.summaryRowHeight
                Layout.maximumHeight: infoPanel.summaryRowHeight
                spacing: 12

                ColumnLayout {
                    Layout.preferredWidth: 86
                    Layout.fillHeight: true
                    spacing: 5

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Rectangle {
                            anchors.centerIn: parent
                            width: app.currentPlayer === 1 ? infoPanel.activeStoneSize : infoPanel.inactiveStoneSize
                            height: width
                            radius: width / 2
                            color: "#050607"
                            border.color: "#11181d"
                            border.width: 1
                        }
                    }

                    Label {
                        text: app.trText("captured") + ": " + app.blackCaptures
                        color: "#edf2f4"
                        font.pixelSize: app.compactLayout ? 13 : 15
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                    }
                }

                ColumnLayout {
                    Layout.preferredWidth: 58
                    Layout.fillHeight: true
                    spacing: 3

                    Label {
                        text: app.currentMoveNumberText()
                        color: "#f1f5f7"
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
                        border.color: "#3b4449"
                        border.width: 1
                    }

                    Label {
                        text: Number(app.komi).toFixed(1)
                        color: "#f1f5f7"
                        font.pixelSize: app.compactLayout ? 18 : 22
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                    }
                }

                ColumnLayout {
                    Layout.preferredWidth: 86
                    Layout.fillHeight: true
                    spacing: 5

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Rectangle {
                            anchors.centerIn: parent
                            width: app.currentPlayer === 2 ? infoPanel.activeStoneSize : infoPanel.inactiveStoneSize
                            height: width
                            radius: width / 2
                            color: "#f8fbfd"
                            border.color: "#d7dee3"
                            border.width: 1
                        }
                    }

                    Label {
                        text: app.trText("captured") + ": " + app.whiteCaptures
                        color: "#edf2f4"
                        font.pixelSize: app.compactLayout ? 13 : 15
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                    }
                }
            }

            Rectangle {
                visible: infoPanel.winrateBarVisible
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: "#384146"
                opacity: 0.75
            }

            Item {
                id: winrateBarSlot
                visible: infoPanel.winrateBarVisible
                Layout.fillWidth: true
                Layout.minimumHeight: infoPanel.winrateBarHeight
                Layout.preferredHeight: infoPanel.winrateBarHeight
                Layout.maximumHeight: infoPanel.winrateBarHeight

            Item {
                id: winrateContent
                anchors.fill: parent
                visible: !app.engineWinratePlaceholderActive() && app.currentAnalysisHasWinrate()

                readonly property real blackWinrate: app.currentAnalysisBlackWinrate()
                readonly property real whiteWinrate: app.currentAnalysisWhiteWinrate()

                Text {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    text: winrateContent.blackWinrate.toFixed(1) + "%"
                    color: "#f3f5f6"
                    font.pixelSize: app.compactLayout ? 13 : 15
                }

                Text {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    text: winrateContent.whiteWinrate.toFixed(1) + "%"
                    color: "#f3f5f6"
                    font.pixelSize: app.compactLayout ? 13 : 15
                }

                Rectangle {
                    id: winrateTrack
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 20
                    color: "#f6f7f8"
                    border.color: "#c7cbce"
                    border.width: 1

                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: parent.width * winrateContent.blackWinrate / 100
                        color: "#030405"
                    }

                    Rectangle {
                        x: parent.width * 0.5
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 1
                        color: "#8d9498"
                        opacity: 0.75
                    }
                }
            }

            Text {
                anchors.fill: parent
                visible: app.engineWinratePlaceholderActive()
                text: app.engineWinratePlaceholderText()
                color: "#edf2f4"
                font.pixelSize: app.compactLayout ? 15 : 17
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
        }

        Rectangle {
            id: winrateGraph
            visible: infoPanel.winrateGraphVisible
            Layout.fillWidth: true
            Layout.minimumHeight: infoPanel.winrateGraphHeight
            Layout.preferredHeight: infoPanel.winrateGraphHeight
            Layout.maximumHeight: infoPanel.winrateGraphHeight
            color: "#636b6f"
            border.color: "#3f484d"
            clip: true

            Canvas {
                id: winrateCanvas
                anchors.fill: parent
                anchors.margins: 4

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)

                    var left = 26
                    var right = 8
                    var top = 8
                    var bottom = 18
                    var plotWidth = Math.max(1, width - left - right)
                    var plotHeight = Math.max(1, height - top - bottom)
                    var currentMove = app.currentMoveNumberValue()
                    var xMax = currentMove > 45 ? Math.max(50, currentMove * 1.1) : 50
                    var points = app.winrateHistoryPoints()

                    ctx.strokeStyle = "#dce2e5"
                    ctx.globalAlpha = 0.70
                    ctx.setLineDash([5, 5])
                    for (var g = 0; g <= 2; ++g) {
                        var gy = top + plotHeight * g / 2
                        ctx.beginPath()
                        ctx.moveTo(left, gy)
                        ctx.lineTo(left + plotWidth, gy)
                        ctx.stroke()
                    }
                    ctx.setLineDash([])
                    ctx.globalAlpha = 1

                    ctx.strokeStyle = "#20282d"
                    ctx.lineWidth = 1
                    ctx.beginPath()
                    ctx.moveTo(left, top)
                    ctx.lineTo(left, top + plotHeight)
                    ctx.lineTo(left + plotWidth, top + plotHeight)
                    ctx.stroke()

                    ctx.fillStyle = "#e9eef1"
                    ctx.font = (app.compactLayout ? "10px" : "11px") + " sans-serif"
                    ctx.textAlign = "right"
                    ctx.textBaseline = "middle"
                    ctx.fillText("100", left - 3, top)
                    ctx.fillText("50", left - 3, top + plotHeight / 2)
                    ctx.fillText("0", left - 3, top + plotHeight)

                    if (points.length <= 0)
                        return

                    ctx.strokeStyle = "#48d3ff"
                    ctx.fillStyle = "#48d3ff"
                    ctx.lineWidth = 2
                    ctx.beginPath()
                    var started = false
                    for (var i = 0; i < points.length; ++i) {
                        var px = left + app.clamp(points[i].move / xMax, 0, 1) * plotWidth
                        var py = top + (100 - points[i].winrate) / 100 * plotHeight
                        if (!started) {
                            ctx.moveTo(px, py)
                            started = true
                        } else {
                            ctx.lineTo(px, py)
                        }
                    }
                    ctx.stroke()

                    for (var p = 0; p < points.length; ++p) {
                        var dx = left + app.clamp(points[p].move / xMax, 0, 1) * plotWidth
                        var dy = top + (100 - points[p].winrate) / 100 * plotHeight
                        ctx.beginPath()
                        ctx.arc(dx, dy, 2.3, 0, Math.PI * 2)
                        ctx.fill()
                    }
                }

                onWidthChanged: requestPaint()
                onHeightChanged: requestPaint()
                Component.onCompleted: requestPaint()

                Connections {
                    target: app
                    function onAnalysisRevisionChanged() { winrateCanvas.requestPaint() }
                    function onCurrentNodeIdChanged() { winrateCanvas.requestPaint() }
                    function onLanguageChanged() { winrateCanvas.requestPaint() }
                    function onPlayModeChanged() { winrateCanvas.requestPaint() }
                }
            }
        }

        }
    }

    Rectangle {
        id: candidateTable
        visible: app.analysisModeActive()
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: summaryPanel.bottom
        anchors.topMargin: infoPanel.panelGap
        anchors.bottom: parent.bottom
        radius: 4
        color: "#dfe3e5"
        border.color: "#8d9498"
        clip: true

        Row {
            id: candidateHeader
            width: parent.width
            height: infoPanel.tableHeaderHeight

            TableHeaderCell {
                width: infoPanel.indexColumnWidth
                text: app.trText("candidateIndex")
            }

            TableHeaderCell {
                width: infoPanel.positionColumnWidth
                text: app.trText("candidatePosition")
            }

            TableHeaderCell {
                width: infoPanel.winrateColumnWidth
                text: app.trText("candidateWinrate")
            }

            TableHeaderCell {
                width: infoPanel.visitsColumnWidth
                text: app.trText("candidateVisits")
            }
        }

        Flickable {
            id: candidateFlick
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: candidateHeader.bottom
            anchors.bottom: parent.bottom
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            contentWidth: width
            contentHeight: candidateColumn.height

            ScrollBar.vertical: StraightScrollBar {
                policy: ScrollBar.AsNeeded
            }

            Column {
                id: candidateColumn
                width: candidateFlick.width

                    Repeater {
                        model: app.engineCandidateTableItems

                        delegate: Rectangle {
                            width: candidateColumn.width
                            height: infoPanel.tableRowHeight
                            readonly property bool selected: modelData.key !== "" && app.hoverKey === modelData.key
                            color: selected ? "#b9bdc0"
                                             : index % 2 === 0 ? "#f0f2f3" : "#e3e6e8"
                            border.color: "#9ba2a6"
                            border.width: 1

                            Row {
                                anchors.fill: parent

                                TableCell {
                                    width: infoPanel.indexColumnWidth
                                    text: modelData.row
                                    color: parent.parent.selected ? "#003cff" : "#15191c"
                                    font.bold: parent.parent.selected
                                }

                                TableCell {
                                    width: infoPanel.positionColumnWidth
                                    text: modelData.coordinate
                                    color: parent.parent.selected ? "#003cff" : "#15191c"
                                    font.bold: parent.parent.selected
                                }

                                TableCell {
                                    width: infoPanel.winrateColumnWidth
                                    text: modelData.winrateText
                                    color: parent.parent.selected ? "#003cff" : "#15191c"
                                    font.bold: parent.parent.selected
                                }

                                TableCell {
                                    width: infoPanel.visitsColumnWidth
                                    text: modelData.visitsText
                                    color: parent.parent.selected ? "#003cff" : "#15191c"
                                    font.bold: parent.parent.selected
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                acceptedButtons: Qt.LeftButton
                                onClicked: {
                                    app.selectEngineCandidateRow(modelData.row)
                                    mouse.accepted = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
