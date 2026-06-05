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
                    fieldOfView: 38
                    clipNear: 4
                    clipFar: 1000
                }

                DirectionalLight {
                    eulerRotation.x: -34
                    eulerRotation.y: 28
                    brightness: 1.45
                }

                PointLight {
                    position: Qt.vector3d(0, 120, 170)
                    brightness: 28
                }

                Repeater3D {
                    model: [
                        { "dx": 1, "dy": 0, "dz": 0, "color": "#d84a43" },
                        { "dx": 0, "dy": 1, "dz": 0, "color": "#39a66a" },
                        { "dx": 0, "dy": 0, "dz": 1, "color": "#3d73d8" }
                    ]

                    delegate: Model {
                        readonly property real axisLength: 68
                        readonly property int dx: modelData.dx
                        readonly property int dy: modelData.dy
                        readonly property int dz: modelData.dz

                        source: "#Cube"
                        pickable: false
                        position: Qt.vector3d(0, 0, 0)
                        scale: dx !== 0
                               ? Qt.vector3d(axisLength * 2 / 100, 0.03, 0.03)
                               : dy !== 0
                                 ? Qt.vector3d(0.03, axisLength * 2 / 100, 0.03)
                                 : Qt.vector3d(0.03, 0.03, axisLength * 2 / 100)
                        materials: PrincipledMaterial {
                            baseColor: modelData.color
                            roughness: 0.42
                        }
                    }
                }

                Repeater3D {
                    model: app.clipAxes

                    delegate: Model {
                        readonly property real axisLength: 68
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
                        scale: Qt.vector3d(0.44, 0.44, 0.44)
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
                    clipPanel.hoverClipAxis = pickedAxis(mouse.x, mouse.y)
                }

                onExited: clipPanel.hoverClipAxis = ""

                onClicked: function(mouse) {
                    clipPanel.hoverClipAxis = pickedAxis(mouse.x, mouse.y)
                    app.focusBoardInput()
                    mouse.accepted = true
                }

                onWheel: function(wheel) {
                    var axis = pickedAxis(wheel.x, wheel.y)
                    if (axis !== "") {
                        clipPanel.hoverClipAxis = axis
                        app.adjustClip(axis, wheel.angleDelta.y > 0 ? 1 : -1)
                    }
                    app.focusBoardInput()
                    wheel.accepted = true
                }
            }
        }
    }
}
