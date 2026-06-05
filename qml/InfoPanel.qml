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
    height: 166
    radius: 8
    color: "#e7eef2"
    border.color: "#bcc9d0"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: app.panelInnerMargin
        spacing: app.compactLayout ? 5 : 8

        Label {
            text: app.windowTitleText()
            color: "#17212a"
            font.pixelSize: 20
            font.bold: true
            Layout.fillWidth: true
        }

        Label {
            text: app.statusLabelText()
            color: app.currentPlayer === 1 ? "#111318" : "#697178"
            font.pixelSize: 15
            font.bold: true
            Layout.fillWidth: true
        }

        Label {
            text: app.trText("stones") + ": " + app.stoneCount + " / " + app.boardPointCount()
            color: "#33424d"
            font.pixelSize: 14
            Layout.fillWidth: true
        }

        Label {
            text: app.hoverKey === ""
                  ? app.trText("hoverNone")
                  : app.trText("hover") + ": " + app.coordinateText(app.hoverX, app.hoverY, app.hoverZ)
            color: "#33424d"
            font.pixelSize: 14
            Layout.fillWidth: true
        }

        RowLayout {
            spacing: 8

            Button {
                text: app.trText("undo")
                enabled: app.currentNodeId !== 0
                onClicked: app.undoMove()
            }

            Button {
                text: app.trText("clear")
                enabled: app.treeNodes.length > 1
                onClicked: app.clearBoard()
            }
        }
    }
}
