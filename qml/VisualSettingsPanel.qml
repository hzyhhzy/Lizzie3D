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

    component StraightSlider: Item {
        id: control
        property real from: 0
        property real to: 1
        property real value: from
        property real stepSize: 0
        readonly property real normalizedValue: to === from ? 0 : app.clamp((value - from) / (to - from), 0, 1)
        readonly property real handleSize: 16
        readonly property real trackInset: handleSize / 2
        readonly property real trackHeight: 4
        readonly property real trackWidth: Math.max(0, width - handleSize)
        readonly property real trackY: Math.round((height - trackHeight) / 2)
        signal moved(real value)

        implicitHeight: 26
        activeFocusOnTab: true

        function snappedValue(rawValue) {
            var low = Math.min(from, to)
            var high = Math.max(from, to)
            var nextValue = app.clamp(rawValue, low, high)
            if (stepSize > 0)
                nextValue = from + Math.round((nextValue - from) / stepSize) * stepSize
            return app.clamp(nextValue, low, high)
        }

        function valueAt(mouseX) {
            var ratio = trackWidth <= 0 ? 0 : app.clamp((mouseX - trackInset) / trackWidth, 0, 1)
            return snappedValue(from + (to - from) * ratio)
        }

        Keys.onPressed: function(event) {
            var delta = stepSize > 0 ? stepSize : (to - from) / 100
            if (event.key === Qt.Key_Left || event.key === Qt.Key_Down) {
                moved(snappedValue(value - delta))
                event.accepted = true
            } else if (event.key === Qt.Key_Right || event.key === Qt.Key_Up) {
                moved(snappedValue(value + delta))
                event.accepted = true
            }
        }

        Rectangle {
            x: control.trackInset
            y: control.trackY
            width: control.trackWidth
            height: control.trackHeight
            radius: 2
            color: "#c9d4da"
        }

        Rectangle {
            x: control.trackInset
            y: control.trackY
            width: Math.round(control.normalizedValue * control.trackWidth)
            height: control.trackHeight
            radius: 2
            color: "#5f7079"
        }

        Rectangle {
            x: Math.round(control.trackInset + control.normalizedValue * control.trackWidth - width / 2)
            y: Math.round((control.height - height) / 2)
            width: control.handleSize
            height: control.handleSize
            radius: width / 2
            color: dragArea.pressed ? "#31434d" : "#f8fbfc"
            border.color: dragArea.containsMouse || control.activeFocus || dragArea.pressed ? "#31434d" : "#7f929c"
            border.width: 1
        }

        MouseArea {
            id: dragArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onPressed: function(mouse) {
                control.forceActiveFocus()
                control.moved(control.valueAt(mouse.x))
                mouse.accepted = true
            }

            onPositionChanged: function(mouse) {
                if (pressed)
                    control.moved(control.valueAt(mouse.x))
            }
        }
    }

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
            text: app.trText("boardSize") + "  " + app.boardDimensionsText()
            color: "#2f414c"
            font.pixelSize: app.compactLayout ? 12 : 14
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.fillWidth: true

            Button {
                text: app.trText("menuBoardSize")
                Layout.fillWidth: true
                onClicked: {
                    app.focusBoardInput()
                    app.openBoardSizeDialog()
                }
            }

            Button {
                text: app.trText("reset")
                Layout.preferredWidth: app.compactLayout ? 56 : 62
                onClicked: {
                    app.focusBoardInput()
                    app.resetBoardSize()
                }
            }
        }

        Label {
            text: app.trText("engine")
            color: "#17212a"
            font.pixelSize: app.compactLayout ? 14 : 16
            font.bold: true
            Layout.fillWidth: true
        }

        Label {
            text: app.trText("engineCommand")
            color: "#2f414c"
            font.pixelSize: app.compactLayout ? 12 : 14
            Layout.fillWidth: true
        }

        TextField {
            id: engineCommandField
            text: engineController.command
            selectByMouse: true
            font.pixelSize: app.compactLayout ? 10 : 11
            Layout.fillWidth: true
            function commitCommand() {
                if (engineController.command !== text)
                    engineController.command = text
            }
            onAccepted: {
                commitCommand()
                app.focusBoardInput()
            }
            onEditingFinished: commitCommand()

            Connections {
                target: engineController
                function onCommandChanged() {
                    if (!engineCommandField.activeFocus)
                        engineCommandField.text = engineController.command
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true

            Button {
                text: app.trText("engineStart")
                Layout.fillWidth: true
                onClicked: {
                    engineCommandField.commitCommand()
                    app.requestEngineAnalysis(true)
                    app.focusBoardInput()
                }
            }

            Button {
                text: app.trText("engineStop")
                Layout.fillWidth: true
                enabled: engineController.running
                onClicked: {
                    app.pauseEngineAnalysis()
                    app.focusBoardInput()
                }
            }

            Button {
                text: app.trText("engineAnalyze")
                Layout.fillWidth: true
                onClicked: {
                    engineCommandField.commitCommand()
                    app.requestEngineAnalysis(true)
                    app.focusBoardInput()
                }
            }
        }

        CheckBox {
            text: app.trText("engineUseFlattened2D")
            checked: app.useFlattened2DCoordinates
            font.pixelSize: app.compactLayout ? 11 : 13
            Layout.fillWidth: true
            onToggled: {
                app.focusBoardInput()
                app.useFlattened2DCoordinates = checked
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Label {
                text: app.trText("candidateDisplayCount")
                color: "#2f414c"
                font.pixelSize: app.compactLayout ? 12 : 14
                Layout.fillWidth: true
            }

            SpinBox {
                from: 1
                to: 10
                value: app.candidateDisplayCount
                editable: true
                Layout.preferredWidth: app.compactLayout ? 72 : 78
                onValueModified: {
                    app.focusBoardInput()
                    app.candidateDisplayCount = value
                }
            }
        }

        Label {
            text: app.trText("candidateMinVisitRatio") + "  " + Math.round(app.candidateMinVisitRatio * 100) + "%"
            color: "#2f414c"
            font.pixelSize: app.compactLayout ? 12 : 14
            Layout.fillWidth: true
        }

        StraightSlider {
            from: 0
            to: 100
            value: app.candidateMinVisitRatio * 100
            stepSize: 1
            Layout.fillWidth: true
            onMoved: function(nextValue) {
                app.candidateMinVisitRatio = nextValue / 100
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

            StraightSlider {
                from: app.minStoneScale
                to: 1.00
                value: app.stoneScale
                stepSize: 0.01
                Layout.fillWidth: true
                onMoved: function(nextValue) { app.stoneScale = nextValue }
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

            StraightSlider {
                from: 0
                to: 100
                value: app.gridOpacity * 100
                stepSize: 1
                Layout.fillWidth: true
                onMoved: function(nextValue) { app.gridOpacity = nextValue / 100 }
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

            StraightSlider {
                from: 0.2
                to: 1.0
                value: app.hiddenLayerTransparency
                stepSize: 0.01
                Layout.fillWidth: true
                onMoved: function(nextValue) { app.hiddenLayerTransparency = nextValue }
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
