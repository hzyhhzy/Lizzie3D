import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: toolbar
    required property var app

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    height: app.analysisToolbarHeight
    z: 70
    color: "#e7ecef"
    border.color: "#c4cdd2"

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: app.compactLayout ? 8 : 12
        anchors.rightMargin: app.compactLayout ? 8 : 12
        spacing: app.compactLayout ? 7 : 11

        Label {
            text: app.trText("komi")
            color: "#26333b"
            font.pixelSize: app.compactLayout ? 13 : 15
            verticalAlignment: Text.AlignVCenter
        }

        TextField {
            id: komiField
            text: Number(app.komi).toFixed(1)
            selectByMouse: true
            validator: DoubleValidator {
                bottom: -99
                top: 99
                decimals: 2
                notation: DoubleValidator.StandardNotation
            }
            Layout.preferredWidth: app.compactLayout ? 48 : 54
            implicitHeight: app.compactLayout ? 28 : 32
            font.pixelSize: app.compactLayout ? 14 : 16
            horizontalAlignment: Text.AlignHCenter

            function applyValue() {
                var nextValue = Number(text)
                if (!isNaN(nextValue))
                    app.komi = Math.round(nextValue * 10) / 10
                text = Number(app.komi).toFixed(1)
            }

            onEditingFinished: applyValue()
            Keys.onReturnPressed: {
                applyValue()
                app.focusBoardInput()
            }
            Keys.onEnterPressed: {
                applyValue()
                app.focusBoardInput()
            }

            Connections {
                target: app
                function onKomiChanged() {
                    if (!komiField.activeFocus)
                        komiField.text = Number(app.komi).toFixed(1)
                }
            }
        }

        ColumnLayout {
            spacing: 0
            Layout.preferredWidth: app.compactLayout ? 22 : 24
            Layout.preferredHeight: app.compactLayout ? 30 : 34

            StepButton {
                text: "+"
                onClicked: app.adjustKomi(0.5)
            }

            StepButton {
                text: "-"
                onClicked: app.adjustKomi(-0.5)
            }
        }

        Rectangle {
            Layout.preferredWidth: 1
            Layout.fillHeight: true
            Layout.topMargin: 7
            Layout.bottomMargin: 7
            color: "#c4cdd2"
        }

        Label {
            text: app.trText("gameRule")
            color: "#26333b"
            font.pixelSize: app.compactLayout ? 13 : 15
            verticalAlignment: Text.AlignVCenter
        }

        RowLayout {
            spacing: app.compactLayout ? 3 : 4

            RuleButton {
                mode: app.gameRuleGo
                text: app.trText("gameRuleGo")
            }

            RuleButton {
                mode: app.gameRuleGomoku
                text: app.trText("gameRuleGomoku")
            }
        }

        Rectangle {
            Layout.preferredWidth: 1
            Layout.fillHeight: true
            Layout.topMargin: 7
            Layout.bottomMargin: 7
            color: "#c4cdd2"
        }

        Label {
            text: app.trText("stoneColor")
            color: "#26333b"
            font.pixelSize: app.compactLayout ? 13 : 15
            verticalAlignment: Text.AlignVCenter
        }

        RowLayout {
            spacing: app.compactLayout ? 4 : 5

            StoneColorButton {
                mode: app.stoneColorModeAuto
                tip: app.trText("stoneColorAutoTip")
            }

            StoneColorButton {
                mode: app.stoneColorModeBlack
                tip: app.trText("stoneColorBlackTip")
            }

            StoneColorButton {
                mode: app.stoneColorModeWhite
                tip: app.trText("stoneColorWhiteTip")
            }
        }

        Item { Layout.fillWidth: true }
    }

    component StepButton: Rectangle {
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
            font.pixelSize: 11
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

    component StoneColorButton: Rectangle {
        id: colorButton
        property int mode: 0
        property string tip: ""
        readonly property bool selected: app.stoneColorMode === mode

        Layout.preferredWidth: app.compactLayout ? 34 : 38
        Layout.preferredHeight: app.compactLayout ? 28 : 32
        radius: 4
        color: selected ? "#d8e9f1" : colorMouse.containsMouse ? "#eef5f8" : "#f8fafb"
        border.color: selected ? "#2e8eb0" : "#b5c2c9"
        border.width: selected ? 2 : 1

        Item {
            anchors.fill: parent

            Rectangle {
                visible: colorButton.mode === app.stoneColorModeAuto
                x: parent.width / 2 - width + 3
                y: parent.height / 2 - height / 2
                width: app.currentPlayer === 1 ? 17 : 13
                height: width
                radius: width / 2
                color: "#050607"
                border.color: "#1a1d20"
            }

            Rectangle {
                visible: colorButton.mode === app.stoneColorModeAuto
                x: parent.width / 2 - 2
                y: parent.height / 2 - height / 2
                width: app.currentPlayer === 2 ? 17 : 13
                height: width
                radius: width / 2
                color: "#ffffff"
                border.color: "#aeb8be"
            }

            Rectangle {
                visible: colorButton.mode === app.stoneColorModeBlack
                anchors.centerIn: parent
                width: app.compactLayout ? 18 : 21
                height: width
                radius: width / 2
                color: "#050607"
                border.color: "#1a1d20"
            }

            Rectangle {
                visible: colorButton.mode === app.stoneColorModeWhite
                anchors.centerIn: parent
                width: app.compactLayout ? 18 : 21
                height: width
                radius: width / 2
                color: "#ffffff"
                border.color: "#aeb8be"
            }
        }

        ToolTip.visible: colorMouse.containsMouse
        ToolTip.text: tip

        MouseArea {
            id: colorMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                app.stoneColorMode = colorButton.mode
                app.focusBoardInput()
            }
        }
    }

    component RuleButton: Rectangle {
        id: ruleButton
        property int mode: 0
        property string text: ""
        readonly property bool selected: app.gameRuleMode === mode

        Layout.preferredWidth: app.compactLayout ? 44 : 56
        Layout.preferredHeight: app.compactLayout ? 28 : 32
        radius: 4
        color: selected ? "#d8e9f1" : ruleMouse.containsMouse ? "#eef5f8" : "#f8fafb"
        border.color: selected ? "#2e8eb0" : "#b5c2c9"
        border.width: selected ? 2 : 1

        Text {
            anchors.centerIn: parent
            text: ruleButton.text
            color: "#26333b"
            font.pixelSize: app.compactLayout ? 12 : 14
            font.bold: ruleButton.selected
        }

        MouseArea {
            id: ruleMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                app.requestRuleModeChange(ruleButton.mode)
                app.focusBoardInput()
            }
        }
    }
}
