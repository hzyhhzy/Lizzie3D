import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick3D

Rectangle {
    id: clipPanel
    required property var app
    required property Item branchPanelItem
    required property Item visualPanelItem
    property alias clipCamera: clipCamera
    property alias clipAxisView: clipAxisView
    property string hoverClipAxis: ""
    property real lastMouseX: 0
    property real lastMouseY: 0
    property bool dragMoved: false
    readonly property real clipAxisLength: app.compactLayout ? 42 : 48
    readonly property real clipHandleScale: app.compactLayout ? 0.30 : 0.34
    readonly property real clipHandleWorldRadius: clipHandleScale * 50
    readonly property real clipAxisRodLength: Math.max(0, (clipAxisLength - clipHandleWorldRadius - 4) * 2)

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

    HoverHandler {
        onHoveredChanged: app.setViewNavigationKeysBlocked(hovered)
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: app.panelInnerMargin
        spacing: app.compactLayout ? 6 : 8

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
                    app.resetClipCounts()
                    app.focusBoardInput()
                }
            }
        }

        Item {
            id: clipAxisContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: app.compactLayout ? 132 : 166

            View3D {
                id: clipAxisView
                anchors.fill: parent
                camera: clipCamera

                environment: SceneEnvironment {
                    backgroundMode: SceneEnvironment.Transparent
                    antialiasingMode: SceneEnvironment.MSAA
                    antialiasingQuality: SceneEnvironment.High
                }

                PerspectiveCamera {
                    id: clipCamera
                    fieldOfView: 42
                    clipNear: 4
                    clipFar: 1000
                }

                Repeater3D {
                    model: [
                        { "dx": 1, "dy": 0, "dz": 0, "color": "#d84a43" },
                        { "dx": 0, "dy": 1, "dz": 0, "color": "#39a66a" },
                        { "dx": 0, "dy": 0, "dz": 1, "color": "#3d73d8" }
                    ]

                    delegate: Model {
                        readonly property real axisLength: clipPanel.clipAxisLength
                        readonly property int dx: modelData.dx
                        readonly property int dy: modelData.dy
                        readonly property int dz: modelData.dz

                        source: "#Cube"
                        pickable: false
                        position: Qt.vector3d(0, 0, 0)
                        scale: dx !== 0
                               ? Qt.vector3d(clipPanel.clipAxisRodLength / 100, 0.03, 0.03)
                               : dy !== 0
                                 ? Qt.vector3d(0.03, clipPanel.clipAxisRodLength / 100, 0.03)
                                 : Qt.vector3d(0.03, 0.03, clipPanel.clipAxisRodLength / 100)
                        materials: PrincipledMaterial {
                            lighting: PrincipledMaterial.NoLighting
                            baseColor: modelData.color
                        }
                    }
                }

                Repeater3D {
                    model: app.clipAxes

                    delegate: Model {
                        readonly property real axisLength: clipPanel.clipAxisLength
                        readonly property bool clipHandle: true
                        readonly property string clipAxisName: modelData.axis
                        readonly property bool hovered: clipPanel.hoverClipAxis === modelData.axis
                        readonly property int count: app.clipCount(modelData.axis)

                        source: "#Rectangle"
                        pickable: true
                        position: Qt.vector3d(modelData.dx * axisLength,
                                              modelData.dy * axisLength,
                                              modelData.dz * axisLength)
                        rotation: app.axisBillboardRotation()
                        scale: Qt.vector3d(clipPanel.clipHandleScale,
                                           clipPanel.clipHandleScale,
                                           clipPanel.clipHandleScale)
                        materials: PrincipledMaterial {
                            lighting: PrincipledMaterial.NoLighting
                            baseColor: "#ffffff"
                            baseColorMap: Texture {
                                sourceItem: Item {
                                    width: 256
                                    height: 256

                                    Rectangle {
                                        anchors.fill: parent
                                        anchors.margins: 6
                                        radius: width / 2
                                        color: hovered
                                               ? "#d5edf7"
                                               : count > 0
                                                 ? "#eef8fb"
                                                 : "#ffffff"
                                        border.width: hovered ? 16 : 12
                                        border.color: hovered ? "#3489a6" : modelData.color

                                        Column {
                                            anchors.centerIn: parent
                                            spacing: -8

                                            Text {
                                                text: modelData.axis
                                                width: 190
                                                horizontalAlignment: Text.AlignHCenter
                                                color: "#41515a"
                                                font.pixelSize: 46
                                                font.bold: true
                                            }

                                            Text {
                                                text: count
                                                width: 190
                                                horizontalAlignment: Text.AlignHCenter
                                                color: "#16212a"
                                                font.pixelSize: 82
                                                font.bold: true
                                            }
                                        }
                                    }
                                }
                            }
                            alphaMode: PrincipledMaterial.Mask
                            alphaCutoff: 0.04
                            cullMode: Material.NoCulling
                        }
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton

                function pickedAxis(x, y) {
                    var result = clipAxisView.pick(x, y)
                    var hit = result.objectHit
                    return hit && hit.clipHandle ? hit.clipAxisName : ""
                }

                onPositionChanged: function(mouse) {
                    if (mouse.buttons & Qt.LeftButton) {
                        var dx = mouse.x - clipPanel.lastMouseX
                        var dy = mouse.y - clipPanel.lastMouseY
                        if (Math.abs(dx) + Math.abs(dy) > 2)
                            clipPanel.dragMoved = true
                        app.rotateCameraByMouseDelta(dx, dy)
                        clipPanel.lastMouseX = mouse.x
                        clipPanel.lastMouseY = mouse.y
                    } else {
                        clipPanel.hoverClipAxis = pickedAxis(mouse.x, mouse.y)
                    }
                    mouse.accepted = true
                }

                onExited: {
                    clipPanel.hoverClipAxis = ""
                }

                onPressed: function(mouse) {
                    app.setViewNavigationKeysBlocked(true)
                    clipPanel.lastMouseX = mouse.x
                    clipPanel.lastMouseY = mouse.y
                    clipPanel.dragMoved = false
                    clipPanel.hoverClipAxis = pickedAxis(mouse.x, mouse.y)
                    mouse.accepted = true
                }

                onReleased: function(mouse) {
                    clipPanel.hoverClipAxis = pickedAxis(mouse.x, mouse.y)
                    mouse.accepted = true
                }

                onWheel: function(wheel) {
                    var axis = pickedAxis(wheel.x, wheel.y)
                    if (axis !== "") {
                        clipPanel.hoverClipAxis = axis
                        app.adjustClip(axis, wheel.angleDelta.y > 0 ? 1 : -1)
                    }
                    app.setViewNavigationKeysBlocked(true)
                    wheel.accepted = true
                }
            }
        }
    }
}
