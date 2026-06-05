import QtQuick
import QtQuick.Controls
import QtQuick3D

Rectangle {
    id: axisGizmoPanel
    required property var app
    property alias axisCamera: axisCamera
    property alias axisView: axisView
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.leftMargin: app.panelMargin + app.infoPanelWidth + app.panelGap
    anchors.topMargin: app.topContentMargin
    width: app.axisGizmoPanelSize
    height: app.axisGizmoPanelSize
    radius: 8
    color: "#eef4f7"
    opacity: 0.92
    border.color: "#b8c7cf"

    View3D {
        id: axisView
        anchors.fill: parent
        anchors.margins: 6
        camera: axisCamera

        environment: SceneEnvironment {
            backgroundMode: SceneEnvironment.Transparent
            antialiasingMode: SceneEnvironment.MSAA
            antialiasingQuality: SceneEnvironment.High
        }

        PerspectiveCamera {
            id: axisCamera
            clipNear: 4
            clipFar: 1000
        }

        DirectionalLight {
            eulerRotation.x: -35
            eulerRotation.y: 30
            brightness: 1.6
        }

        Repeater3D {
            model: [
                { "axis": "+X", "dx": 1, "dy": 0, "dz": 0, "color": "#d84a43" },
                { "axis": "-X", "dx": -1, "dy": 0, "dz": 0, "color": "#d84a43" },
                { "axis": "+Y", "dx": 0, "dy": 1, "dz": 0, "color": "#39a66a" },
                { "axis": "-Y", "dx": 0, "dy": -1, "dz": 0, "color": "#39a66a" },
                { "axis": "+Z", "dx": 0, "dy": 0, "dz": 1, "color": "#3d73d8" },
                { "axis": "-Z", "dx": 0, "dy": 0, "dz": -1, "color": "#3d73d8" }
            ]

            delegate: Model {
                readonly property real axisLength: 72
                readonly property int dx: modelData.dx
                readonly property int dy: modelData.dy
                readonly property int dz: modelData.dz

                source: "#Cube"
                pickable: false
                position: Qt.vector3d(dx * axisLength * 0.5,
                                      dy * axisLength * 0.5,
                                      dz * axisLength * 0.5)
                scale: dx !== 0
                       ? Qt.vector3d(axisLength / 100, 0.026, 0.026)
                       : dy !== 0
                         ? Qt.vector3d(0.026, axisLength / 100, 0.026)
                         : Qt.vector3d(0.026, 0.026, axisLength / 100)
                materials: PrincipledMaterial {
                    baseColor: modelData.color
                    roughness: 0.45
                }
            }
        }

        Repeater3D {
            model: [
                { "axis": "+X", "dx": 1, "dy": 0, "dz": 0, "color": "#d84a43" },
                { "axis": "-X", "dx": -1, "dy": 0, "dz": 0, "color": "#d84a43" },
                { "axis": "+Y", "dx": 0, "dy": 1, "dz": 0, "color": "#39a66a" },
                { "axis": "-Y", "dx": 0, "dy": -1, "dz": 0, "color": "#39a66a" },
                { "axis": "+Z", "dx": 0, "dy": 0, "dz": 1, "color": "#3d73d8" },
                { "axis": "-Z", "dx": 0, "dy": 0, "dz": -1, "color": "#3d73d8" }
            ]

            delegate: Model {
                readonly property bool axisHandle: true
                readonly property string axisName: modelData.axis
                readonly property real axisLength: 72

                source: "#Sphere"
                pickable: true
                position: Qt.vector3d(modelData.dx * axisLength,
                                      modelData.dy * axisLength,
                                      modelData.dz * axisLength)
                scale: Qt.vector3d(0.18, 0.18, 0.18)
                materials: PrincipledMaterial {
                    baseColor: modelData.color
                    roughness: 0.22
                }
            }
        }
    }

    Repeater {
        model: app.clipAxes

        delegate: Text {
            property var screenPoint: app.axisGizmoLabelPoint(modelData.dx, modelData.dy, modelData.dz)

            x: app.clamp(axisView.x + screenPoint.x - width / 2,
                          4,
                          axisGizmoPanel.width - width - 4)
            y: app.clamp(axisView.y + screenPoint.y - height / 2,
                          4,
                          axisGizmoPanel.height - height - (app.compactLayout ? 18 : 22))
            z: 2
            visible: screenPoint.x > -900 && screenPoint.y > -900
            text: modelData.label
            color: modelData.color
            font.pixelSize: 12
            font.bold: true
            style: Text.Outline
            styleColor: "#eef4f7"
        }
    }

    Text {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 6
        horizontalAlignment: Text.AlignHCenter
        text: app.trText("axisHint")
        color: "#41515a"
        font.pixelSize: 12
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton

        onClicked: function(mouse) {
            app.focusBoardInput()
            var result = axisView.pick(mouse.x - axisView.x, mouse.y - axisView.y)
            var hit = result.objectHit
            if (hit && hit.axisHandle)
                app.alignCameraToAxis(hit.axisName)
            mouse.accepted = true
        }
    }
}
