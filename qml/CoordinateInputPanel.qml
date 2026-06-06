import QtQuick
import QtQuick.Controls
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
    width: app.compactLayout ? 312 : 356
    height: app.compactLayout ? 76 : 86
    z: 55
    radius: 6
    color: "#eef3f6"
    border.color: app.hoverKey !== "" && !app.selectedPointLegal()
                  ? "#d73b35"
                  : app.selectedPointLocked ? "#2e8eb0" : "#b6c2c9"
    border.width: app.selectedPointLocked ? 2 : 1
    opacity: 0.97

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: app.compactLayout ? 6 : 8
        spacing: app.compactLayout ? 4 : 6

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

            TextField {
                id: coordinateTextField
                text: app.coordinateInputText
                selectByMouse: true
                Layout.preferredWidth: app.compactLayout ? 54 : 62
                implicitHeight: app.compactLayout ? 28 : 32
                font.pixelSize: app.compactLayout ? 14 : 16
                horizontalAlignment: Text.AlignHCenter

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

            Button {
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

    component NumericStepField: RowLayout {
        id: numericRoot
        property string labelText: ""
        property int value: 0
        property int maxValue: 19
        signal edited(int value)

        spacing: 2
        Layout.preferredWidth: app.compactLayout ? 96 : 108

        Label {
            text: numericRoot.labelText
            color: "#26333b"
            font.pixelSize: app.compactLayout ? 14 : 16
            verticalAlignment: Text.AlignVCenter
        }

        TextField {
            id: numericField
            text: String(numericRoot.value)
            validator: IntValidator { bottom: 1; top: numericRoot.maxValue }
            selectByMouse: true
            Layout.preferredWidth: app.compactLayout ? 32 : 36
            implicitHeight: app.compactLayout ? 28 : 32
            font.pixelSize: app.compactLayout ? 14 : 16
            horizontalAlignment: Text.AlignHCenter

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
            Layout.preferredWidth: app.compactLayout ? 20 : 22
            Layout.preferredHeight: app.compactLayout ? 28 : 32

            SmallStepButton {
                text: "+"
                onClicked: numericRoot.edited(Math.min(numericRoot.maxValue, numericRoot.value + 1))
            }

            SmallStepButton {
                text: "-"
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
            font.pixelSize: 10
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
