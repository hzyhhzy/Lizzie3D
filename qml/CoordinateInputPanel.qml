import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic as Basic
import QtQuick.Layouts

Rectangle {
    id: coordinatePanel
    required property var app

    readonly property real leftLimit: app.boardStageLeftReserve + app.panelGap
    readonly property real rightLimit: parent.width - app.boardStageRightReserve - app.panelGap

    x: app.clamp(app.boardStageCenterX - width / 2,
                 leftLimit,
                 Math.max(leftLimit, rightLimit - width))
    anchors.top: parent.top
    anchors.topMargin: app.analysisToolbarHeight + app.panelGap
    width: app.compactLayout ? 454 : 516
    height: app.compactLayout ? 84 : 94
    z: 55
    radius: 6
    color: "#eef3f6"
    border.color: app.hoverKey !== "" && !app.selectedPointLegal()
                  ? "#d73b35"
                  : app.selectedPointLocked ? "#2e8eb0" : "#b6c2c9"
    border.width: app.selectedPointLocked ? 2 : 1
    opacity: 0.97

    NudgeAxisControl {
        id: nudgeAxis
        anchors.left: parent.left
        anchors.leftMargin: app.compactLayout ? 7 : 9
        anchors.verticalCenter: parent.verticalCenter
        width: app.compactLayout ? 78 : 90
        height: width
    }

    ColumnLayout {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: nudgeAxis.right
        anchors.right: parent.right
        anchors.topMargin: app.compactLayout ? 6 : 7
        anchors.bottomMargin: app.compactLayout ? 6 : 7
        anchors.leftMargin: app.compactLayout ? 6 : 8
        anchors.rightMargin: app.compactLayout ? 6 : 7
        spacing: app.compactLayout ? 4 : 5

        RowLayout {
            Layout.fillWidth: true
            spacing: app.compactLayout ? 6 : 8

            NumericStepField {
                labelText: "x="
                value: app.coordinateInputX + 1
                maxValue: app.boardSizeX
                onEdited: function(nextValue) {
                    app.setSelectedPoint(nextValue - 1, app.coordinateInputY, app.coordinateInputZ, true)
                }
            }

            NumericStepField {
                labelText: "y="
                value: app.coordinateInputY + 1
                maxValue: app.boardSizeY
                onEdited: function(nextValue) {
                    app.setSelectedPoint(app.coordinateInputX, nextValue - 1, app.coordinateInputZ, true)
                }
            }

            NumericStepField {
                labelText: "z="
                value: app.coordinateInputZ + 1
                maxValue: app.boardSizeZ
                onEdited: function(nextValue) {
                    app.setSelectedPoint(app.coordinateInputX, app.coordinateInputY, nextValue - 1, true)
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: app.compactLayout ? 5 : 7

            Label {
                text: app.trText("coordinateShort") + "="
                color: "#26333b"
                font.pixelSize: app.compactLayout ? 14 : 16
                verticalAlignment: Text.AlignVCenter
            }

            Basic.TextField {
                id: coordinateTextField
                text: app.coordinateInputText
                selectByMouse: true
                Layout.preferredWidth: app.compactLayout ? 74 : 86
                implicitHeight: app.compactLayout ? 34 : 38
                leftPadding: 4
                rightPadding: 4
                topPadding: 0
                bottomPadding: 1
                color: "#17252d"
                selectedTextColor: "#ffffff"
                selectionColor: "#2e8eb0"
                font.pixelSize: app.compactLayout ? 22 : 25
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                background: Rectangle {
                    radius: 5
                    color: coordinateTextField.activeFocus ? "#ffffff" : "#f9fbfc"
                    border.color: app.hoverKey !== "" && !app.selectedPointLegal()
                                  ? "#d73b35"
                                  : coordinateTextField.activeFocus ? "#2e8eb0" : "#9fb0b8"
                    border.width: coordinateTextField.activeFocus ? 2 : 1
                }

                onTextEdited: app.editCoordinateInputText(text)
                onEditingFinished: app.applyCoordinateInputText(text)
                Keys.onReturnPressed: {
                    app.applyCoordinateInputText(text)
                    app.playCoordinateInput()
                    app.focusBoardInput()
                }
                Keys.onEnterPressed: {
                    app.applyCoordinateInputText(text)
                    app.playCoordinateInput()
                    app.focusBoardInput()
                }

                Connections {
                    target: app
                    function onCoordinateInputTextChanged() {
                        if (!coordinateTextField.activeFocus)
                            coordinateTextField.text = app.coordinateInputText
                    }
                }
            }

            CheckBox {
                id: confirmCheck
                text: app.trText("moveClickConfirm")
                checked: app.moveClickConfirm
                font.pixelSize: app.compactLayout ? 12 : 14
                Layout.fillWidth: true
                indicator.width: app.compactLayout ? 16 : 18
                indicator.height: indicator.width
                onToggled: {
                    app.moveClickConfirm = checked
                    app.focusBoardInput()
                }
            }

            Basic.Button {
                text: app.trText("playMove")
                enabled: app.selectedPointPlayable()
                Layout.preferredWidth: app.compactLayout ? 58 : 70
                implicitHeight: app.compactLayout ? 30 : 34
                font.pixelSize: app.compactLayout ? 14 : 16
                font.bold: true
                background: Rectangle {
                    radius: 5
                    color: !parent.enabled ? "#aeb8be"
                           : parent.down ? "#0f7f59"
                             : parent.hovered ? "#21a977" : "#169566"
                    border.color: parent.enabled ? "#0b704e" : "#8f9aa1"
                }
                contentItem: Text {
                    text: parent.text
                    color: parent.enabled ? "#ffffff" : "#edf2f4"
                    font: parent.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    app.playCoordinateInput()
                    app.focusBoardInput()
                }
            }
        }
    }

    component NudgeAxisControl: Item {
        id: axisControl
        property string hoveredAxis: ""

        function axisItems() {
            var cx = width / 2
            var cy = height / 2
            var r = width * 0.39
            var right = app.cameraRightVector()
            var up = app.cameraUpVector()
            var back = app.cameraBackVector()
            var axes = [
                { "axis": "+X", "dx": 1, "dy": 0, "dz": 0, "color": "#d84a43" },
                { "axis": "-X", "dx": -1, "dy": 0, "dz": 0, "color": "#d84a43" },
                { "axis": "+Y", "dx": 0, "dy": 1, "dz": 0, "color": "#39a66a" },
                { "axis": "-Y", "dx": 0, "dy": -1, "dz": 0, "color": "#39a66a" },
                { "axis": "+Z", "dx": 0, "dy": 0, "dz": 1, "color": "#3d73d8" },
                { "axis": "-Z", "dx": 0, "dy": 0, "dz": -1, "color": "#3d73d8" }
            ]
            var items = []
            for (var i = 0; i < axes.length; ++i) {
                var a = axes[i]
                var sx = a.dx * right.x + a.dy * right.y + a.dz * right.z
                var sy = -(a.dx * up.x + a.dy * up.y + a.dz * up.z)
                var depth = a.dx * back.x + a.dy * back.y + a.dz * back.z
                var len = Math.sqrt(sx * sx + sy * sy)
                if (len < 0.0001) {
                    sx = depth >= 0 ? 0.24 : -0.24
                    sy = depth >= 0 ? -0.24 : 0.24
                    len = Math.sqrt(sx * sx + sy * sy)
                }
                var projectionScale = app.clamp(len, 0.38, 1.0)
                var ux = sx / len
                var uy = sy / len
                var length = r * projectionScale
                items.push({
                    "axis": a.axis,
                    "dx": a.dx,
                    "dy": a.dy,
                    "dz": a.dz,
                    "x": cx + ux * length,
                    "y": cy + uy * length,
                    "ux": ux,
                    "uy": uy,
                    "depth": depth,
                    "color": a.color
                })
            }
            items.sort(function(left, rightItem) { return left.depth - rightItem.depth })
            return items
        }

        function hoveredAxisAt(x, y) {
            var items = axisItems()
            var bestAxis = ""
            var bestDistance = 9999
            for (var i = 0; i < items.length; ++i) {
                var dx = x - items[i].x
                var dy = y - items[i].y
                var distance = Math.sqrt(dx * dx + dy * dy)
                if (distance < bestDistance) {
                    bestDistance = distance
                    bestAxis = items[i].axis
                }
            }
            return bestDistance <= (app.compactLayout ? 19 : 22) ? bestAxis : ""
        }

        function moveForAxis(axisName) {
            var items = axisItems()
            for (var i = 0; i < items.length; ++i) {
                if (items[i].axis === axisName)
                    return items[i]
            }
            return null
        }

        Canvas {
            id: axisCanvas
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                var cx = width / 2
                var cy = height / 2
                var items = axisControl.axisItems()

                ctx.lineCap = "round"
                ctx.lineJoin = "round"
                for (var i = 0; i < items.length; ++i) {
                    var item = items[i]
                    var ux = item.ux
                    var uy = item.uy
                    var px = -uy
                    var py = ux
                    var highlighted = axisControl.hoveredAxis === item.axis
                    var tipX = item.x
                    var tipY = item.y
                    var coneLength = app.compactLayout ? 11 : 13
                    var coneWidth = app.compactLayout ? 9 : 11
                    var rodEndX = tipX - ux * coneLength
                    var rodEndY = tipY - uy * coneLength
                    var rodStartX = cx + ux * 5
                    var rodStartY = cy + uy * 5
                    var shadeOffset = highlighted ? 2.2 : 1.6

                    ctx.strokeStyle = "#17252d"
                    ctx.globalAlpha = highlighted ? 0.32 : 0.18
                    ctx.lineWidth = highlighted ? 7.5 : 6
                    ctx.beginPath()
                    ctx.moveTo(rodStartX - px * shadeOffset, rodStartY - py * shadeOffset)
                    ctx.lineTo(rodEndX - px * shadeOffset, rodEndY - py * shadeOffset)
                    ctx.stroke()

                    ctx.strokeStyle = item.color
                    ctx.globalAlpha = highlighted ? 1 : (item.depth > 0 ? 0.94 : 0.68)
                    ctx.lineWidth = highlighted ? 6.2 : 5
                    ctx.beginPath()
                    ctx.moveTo(rodStartX, rodStartY)
                    ctx.lineTo(rodEndX, rodEndY)
                    ctx.stroke()

                    ctx.strokeStyle = "#ffffff"
                    ctx.globalAlpha = highlighted ? 0.55 : 0.28
                    ctx.lineWidth = 1.4
                    ctx.beginPath()
                    ctx.moveTo(rodStartX + px * 1.4, rodStartY + py * 1.4)
                    ctx.lineTo(rodEndX + px * 1.4, rodEndY + py * 1.4)
                    ctx.stroke()

                    var baseX = tipX - ux * coneLength
                    var baseY = tipY - uy * coneLength
                    if (highlighted) {
                        ctx.strokeStyle = "#17252d"
                        ctx.globalAlpha = 0.35
                        ctx.lineWidth = 3
                        ctx.beginPath()
                        ctx.moveTo(tipX, tipY)
                        ctx.lineTo(baseX + px * coneWidth * 0.55, baseY + py * coneWidth * 0.55)
                        ctx.lineTo(baseX - px * coneWidth * 0.55, baseY - py * coneWidth * 0.55)
                        ctx.closePath()
                        ctx.stroke()
                    }

                    ctx.globalAlpha = highlighted ? 1 : (item.depth > 0 ? 0.96 : 0.72)
                    ctx.fillStyle = highlighted ? "#fff3a6" : item.color
                    ctx.beginPath()
                    ctx.moveTo(tipX, tipY)
                    ctx.lineTo(baseX + px * coneWidth * 0.5, baseY + py * coneWidth * 0.5)
                    ctx.lineTo(baseX - px * coneWidth * 0.5, baseY - py * coneWidth * 0.5)
                    ctx.closePath()
                    ctx.fill()
                }

                ctx.globalAlpha = 1
                ctx.fillStyle = app.selectedPointColor()
                ctx.beginPath()
                ctx.arc(cx, cy, app.compactLayout ? 4 : 4.5, 0, Math.PI * 2)
                ctx.fill()
            }

            Component.onCompleted: requestPaint()

            Connections {
                target: app
                function onCameraYawChanged() { axisCanvas.requestPaint() }
                function onCameraPitchChanged() { axisCanvas.requestPaint() }
                function onSelectedPointLockedChanged() { axisCanvas.requestPaint() }
                function onHoverKeyChanged() { axisCanvas.requestPaint() }
                function onLegalityRevisionChanged() { axisCanvas.requestPaint() }
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onPositionChanged: function(mouse) {
                var nextAxis = axisControl.hoveredAxisAt(mouse.x, mouse.y)
                if (axisControl.hoveredAxis !== nextAxis) {
                    axisControl.hoveredAxis = nextAxis
                    axisCanvas.requestPaint()
                }
            }

            onExited: {
                axisControl.hoveredAxis = ""
                axisCanvas.requestPaint()
            }

            onClicked: function(mouse) {
                var axisName = axisControl.hoveredAxisAt(mouse.x, mouse.y)
                var best = axisControl.moveForAxis(axisName)
                if (best) {
                    app.nudgeSelectedPoint(best.dx, best.dy, best.dz)
                    mouse.accepted = true
                }
            }
        }
    }

    component NumericStepField: RowLayout {
        id: numericRoot
        property string labelText: ""
        property int value: 0
        property int maxValue: 19
        signal edited(int value)

        spacing: 2
        Layout.preferredWidth: app.compactLayout ? 86 : 96

        Label {
            text: numericRoot.labelText
            color: "#26333b"
            font.pixelSize: app.compactLayout ? 15 : 17
            verticalAlignment: Text.AlignVCenter
        }

        Basic.TextField {
            id: numericField
            text: String(numericRoot.value)
            validator: IntValidator { bottom: 1; top: numericRoot.maxValue }
            selectByMouse: true
            Layout.preferredWidth: app.compactLayout ? 32 : 36
            implicitHeight: app.compactLayout ? 30 : 34
            leftPadding: 2
            rightPadding: 2
            topPadding: 0
            bottomPadding: 1
            color: "#17252d"
            selectedTextColor: "#ffffff"
            selectionColor: "#2e8eb0"
            font.pixelSize: app.compactLayout ? 17 : 19
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            background: Rectangle {
                radius: 4
                color: numericField.activeFocus ? "#ffffff" : "#f9fbfc"
                border.color: numericField.activeFocus ? "#2e8eb0" : "#9fb0b8"
                border.width: numericField.activeFocus ? 2 : 1
            }

            function commit() {
                numericRoot.edited(app.clampOneBasedCoordinateInput(text, numericRoot.maxValue))
            }

            onTextEdited: commit()
            onEditingFinished: {
                commit()
                text = String(numericRoot.value)
            }
            Keys.onReturnPressed: {
                commit()
                app.focusBoardInput()
            }
            Keys.onEnterPressed: {
                commit()
                app.focusBoardInput()
            }

            Connections {
                target: numericRoot
                function onValueChanged() {
                    if (!numericField.activeFocus)
                        numericField.text = String(numericRoot.value)
                }
            }
        }

        ColumnLayout {
            spacing: 0
            Layout.minimumWidth: app.compactLayout ? 14 : 16
            Layout.preferredWidth: app.compactLayout ? 14 : 16
            Layout.maximumWidth: app.compactLayout ? 14 : 16
            Layout.preferredHeight: app.compactLayout ? 30 : 34

            SmallStepButton {
                text: "^"
                onClicked: numericRoot.edited(Math.min(numericRoot.maxValue, numericRoot.value + 1))
            }

            SmallStepButton {
                text: "∨"
                onClicked: numericRoot.edited(Math.max(1, numericRoot.value - 1))
            }
        }
    }

    component SmallStepButton: Rectangle {
        id: stepButton
        signal clicked()
        property string text: ""

        Layout.fillWidth: true
        Layout.fillHeight: true
        radius: 2
        color: stepMouse.pressed ? "#cfdbe1" : stepMouse.containsMouse ? "#dde6eb" : "#f7fafb"
        border.color: "#aebbc2"

        Text {
            anchors.centerIn: parent
            text: stepButton.text
            color: "#26333b"
            font.pixelSize: app.compactLayout ? 9 : 10
            font.bold: true
        }

        MouseArea {
            id: stepMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                stepButton.clicked()
                app.focusBoardInput()
            }
        }
    }
}
