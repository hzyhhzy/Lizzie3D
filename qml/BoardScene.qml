import QtQuick
import QtQuick3D
import QtQuick3D.Helpers

View3D {
    id: boardView
    required property var app
    property alias sceneCamera: boardCamera
    x: app.boardViewOffsetX
    y: app.analysisToolbarHeight
    width: parent.width
    height: parent.height - app.analysisToolbarHeight - app.commandToolbarHeight - app.panelGap
    camera: boardCamera

    environment: SceneEnvironment {
        backgroundMode: SceneEnvironment.Color
        clearColor: "#bcc8cf"
        antialiasingMode: SceneEnvironment.MSAA
        antialiasingQuality: SceneEnvironment.High
    }

    PerspectiveCamera {
        id: boardCamera
        fieldOfView: 90
        clipNear: 8
        clipFar: 4000
    }

    DirectionalLight {
        eulerRotation.x: app.sceneDirectionalLightPitch()
        eulerRotation.y: app.sceneDirectionalLightYaw()
        brightness: 0.85
        castsShadow: false
    }

    PointLight {
        position: app.scenePointLightPosition()
        brightness: 80
        color: "#ffffff"
    }

    Node {
        id: boardRoot

        Repeater3D {
            model: [0, 1, 2]

            delegate: Model {
                readonly property int axis: modelData

                pickable: false
                geometry: ProceduralMesh {
                    positions: app.gridLinePositions(axis)
                    colors: app.gridLineColors(axis)
                    primitiveMode: ProceduralMesh.Lines
                }
                materials: PrincipledMaterial {
                    lighting: PrincipledMaterial.NoLighting
                    baseColor: "#ffffff"
                    vertexColorsEnabled: true
                    alphaMode: PrincipledMaterial.Blend
                    lineWidth: 1.25
                }
            }
        }

        Repeater3D {
            model: app.hoverGridRods()

            delegate: Model {
                source: "#Cube"
                visible: modelData.opacity > 0
                pickable: false
                position: modelData.position
                scale: modelData.scale
                opacity: modelData.opacity
                materials: PrincipledMaterial {
                    lighting: PrincipledMaterial.NoLighting
                    baseColor: modelData.color
                    alphaMode: PrincipledMaterial.Blend
                }
            }
        }

        Repeater3D {
            model: [
                { "axis": "X", "dx": 1, "dy": 0, "dz": 0, "color": "#d84a43" },
                { "axis": "Y", "dx": 0, "dy": 1, "dz": 0, "color": "#39a66a" },
                { "axis": "Z", "dx": 0, "dy": 0, "dz": 1, "color": "#3d73d8" }
            ]

            delegate: Model {
                readonly property vector3d origin: app.mainAxisOrigin()
                readonly property real axisLength: app.mainAxisLength(modelData.axis)
                readonly property int dx: modelData.dx
                readonly property int dy: modelData.dy
                readonly property int dz: modelData.dz

                source: "#Cube"
                pickable: false
                position: Qt.vector3d(origin.x + dx * axisLength * 0.5,
                                      origin.y + dy * axisLength * 0.5,
                                      origin.z + dz * axisLength * 0.5)
                scale: dx !== 0
                       ? Qt.vector3d(axisLength / 100, 0.02, 0.02)
                       : dy !== 0
                         ? Qt.vector3d(0.02, axisLength / 100, 0.02)
                         : Qt.vector3d(0.02, 0.02, axisLength / 100)
                materials: PrincipledMaterial {
                    baseColor: modelData.color
                    roughness: 0.36
                }
            }
        }

        Repeater3D {
            model: [
                { "axis": "X", "dx": 1, "dy": 0, "dz": 0, "color": "#d84a43" },
                { "axis": "Y", "dx": 0, "dy": 1, "dz": 0, "color": "#39a66a" },
                { "axis": "Z", "dx": 0, "dy": 0, "dz": 1, "color": "#3d73d8" }
            ]

            delegate: Model {
                readonly property vector3d origin: app.mainAxisOrigin()
                readonly property real axisLength: app.mainAxisLength(modelData.axis)

                source: "#Sphere"
                pickable: false
                position: Qt.vector3d(origin.x + modelData.dx * axisLength,
                                      origin.y + modelData.dy * axisLength,
                                      origin.z + modelData.dz * axisLength)
                scale: Qt.vector3d(0.075, 0.075, 0.075)
                materials: PrincipledMaterial {
                    baseColor: modelData.color
                    roughness: 0.26
                }
            }
        }

        Repeater3D {
            model: app.mainAxisLabels

            delegate: Model {
                readonly property vector3d labelPosition: app.pointPosition(modelData.x, modelData.y, modelData.z)

                source: "#Rectangle"
                pickable: false
                position: labelPosition
                rotation: app.stoneBillboardRotation(labelPosition)
                scale: Qt.vector3d(modelData.size, modelData.size, modelData.size)
                materials: PrincipledMaterial {
                    lighting: PrincipledMaterial.NoLighting
                    baseColor: "#ffffff"
                    baseColorMap: Texture {
                        sourceItem: Item {
                            width: 256
                            height: 256

                            Text {
                                anchors.centerIn: parent
                                text: modelData.label
                                color: modelData.color
                                font.pixelSize: modelData.fontSize
                                font.bold: true
                            }
                        }
                    }
                    alphaMode: PrincipledMaterial.Mask
                    alphaCutoff: 0.04
                    cullMode: Material.NoCulling
                }
            }
        }

        Repeater3D {
            model: app.hideGridPoints ? [] : app.points
            delegate: Model {
                readonly property int gx: modelData.x
                readonly property int gy: modelData.y
                readonly property int gz: modelData.z
                readonly property bool gridPoint: true
                property int occupant: app.stoneAt(gx, gy, gz)
                property bool clipped: app.isClipped(gx, gy, gz)
                property bool hovered: app.hoverKey === modelData.key
                readonly property real pointScale: hovered ? app.stoneModelScale() : app.gridPointSphereScale

                source: "#Sphere"
                pickable: false
                visible: occupant === 0
                position: modelData.position
                scale: Qt.vector3d(pointScale, pointScale, pointScale)
                opacity: app.emptyPointOpacity(clipped, hovered)
                materials: PrincipledMaterial {
                    baseColor: hovered ? app.selectedPointColor() : "#6e8794"
                    alphaMode: PrincipledMaterial.Blend
                    roughness: 0.54
                }
            }
        }

        Model {
            readonly property bool hasHover: app.hoverKey !== ""
            readonly property bool clipped: hasHover && app.isClipped(app.hoverX, app.hoverY, app.hoverZ)
            readonly property real pointScale: app.stoneModelScale()

            source: "#Sphere"
            pickable: false
            visible: hasHover && !clipped
            position: app.pointPosition(app.hoverX, app.hoverY, app.hoverZ)
            scale: Qt.vector3d(pointScale, pointScale, pointScale)
            opacity: app.selectedPointLegal() ? 0.42 : 0.50
            materials: PrincipledMaterial {
                baseColor: app.selectedPointColor()
                alphaMode: PrincipledMaterial.Blend
                roughness: 0.54
            }
        }

        Repeater3D {
            model: app.engineCandidateItems

            delegate: Model {
                readonly property bool clipped: app.isClipped(modelData.x, modelData.y, modelData.z)
                readonly property real candidateScale: app.stoneModelScale()

                source: "#Sphere"
                pickable: false
                visible: app.stoneAt(modelData.x, modelData.y, modelData.z) === 0
                position: modelData.position
                scale: Qt.vector3d(candidateScale, candidateScale, candidateScale)
                opacity: clipped ? modelData.opacity * app.hiddenLayerOpacity() : modelData.opacity
                materials: PrincipledMaterial {
                    lighting: PrincipledMaterial.NoLighting
                    baseColor: modelData.color
                    alphaMode: PrincipledMaterial.Blend
                    roughness: 0.42
                }
            }
        }

        Model {
            readonly property bool clipped: app.bestCandidateRingVisible
                                            && app.isClipped(app.bestCandidateRingX,
                                                            app.bestCandidateRingY,
                                                            app.bestCandidateRingZ)
            readonly property vector3d ringPosition: app.candidateRingBillboardPosition(app.bestCandidateRingBasePosition())
            readonly property real ringScale: app.stoneBillboardScale() * 1.62

            source: "#Rectangle"
            pickable: false
            visible: app.bestCandidateRingVisible
                     && app.stoneAt(app.bestCandidateRingX,
                                    app.bestCandidateRingY,
                                    app.bestCandidateRingZ) === 0
            position: ringPosition
            rotation: app.stoneBillboardRotation(ringPosition)
            scale: Qt.vector3d(ringScale, ringScale, ringScale)
            opacity: clipped ? app.hiddenLayerOpacity() : 0.98
            materials: PrincipledMaterial {
                lighting: PrincipledMaterial.NoLighting
                baseColor: "#ffffff"
                baseColorMap: Texture {
                    sourceItem: Item {
                        width: 220
                        height: 220

                        Canvas {
                            anchors.fill: parent
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.clearRect(0, 0, width, height)
                                ctx.strokeStyle = "#ff1616"
                                ctx.lineWidth = 24
                                ctx.beginPath()
                                ctx.arc(width / 2, height / 2, 85, 0, Math.PI * 2)
                                ctx.stroke()
                            }
                            Component.onCompleted: requestPaint()
                        }
                    }
                }
                alphaMode: PrincipledMaterial.Mask
                alphaCutoff: 0.04
                cullMode: Material.NoCulling
            }
        }

        Repeater3D {
            model: app.engineCandidateItems

            delegate: Model {
                readonly property bool clipped: app.isClipped(modelData.x, modelData.y, modelData.z)
                readonly property vector3d labelPosition: app.stoneBillboardPosition(modelData.position)
                readonly property real labelScale: app.stoneBillboardScale() * 0.82

                source: "#Rectangle"
                pickable: false
                visible: app.stoneAt(modelData.x, modelData.y, modelData.z) === 0
                position: labelPosition
                rotation: app.stoneBillboardRotation(labelPosition)
                scale: Qt.vector3d(labelScale, labelScale, labelScale)
                opacity: clipped ? app.hiddenLayerOpacity() : 1
                materials: PrincipledMaterial {
                    lighting: PrincipledMaterial.NoLighting
                    baseColor: "#ffffff"
                    baseColorMap: Texture {
                        sourceItem: Item {
                            width: 128
                            height: 128

                            Text {
                                visible: modelData.winrateText.length > 0
                                anchors.centerIn: parent
                                width: 112
                                height: 112
                                text: modelData.winrateText
                                color: "#12445e"
                                font.bold: true
                                font.pixelSize: 52
                                fontSizeMode: Text.Fit
                                minimumPixelSize: 16
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                        }
                    }
                    alphaMode: PrincipledMaterial.Mask
                    alphaCutoff: 0.04
                    cullMode: Material.NoCulling
                }
            }
        }

        Repeater3D {
            model: app.engineCandidateItems

            delegate: Model {
                readonly property bool clipped: app.isClipped(modelData.x, modelData.y, modelData.z)
                readonly property real indexOffset: (modelData.displayIndex === 1 ? 0.70 : 0.54) * 0.75
                readonly property vector3d indexPosition: app.stoneBillboardOffsetPosition(modelData.position,
                                                                                           indexOffset,
                                                                                           indexOffset)
                readonly property real indexScale: app.stoneBillboardScale() * (modelData.displayIndex === 1 ? 0.42 : 0.34)

                source: "#Rectangle"
                pickable: false
                visible: app.stoneAt(modelData.x, modelData.y, modelData.z) === 0
                position: indexPosition
                rotation: app.stoneBillboardRotation(indexPosition)
                scale: Qt.vector3d(indexScale, indexScale, indexScale)
                opacity: clipped ? app.hiddenLayerOpacity() : 1
                materials: PrincipledMaterial {
                    lighting: PrincipledMaterial.NoLighting
                    baseColor: "#ffffff"
                    baseColorMap: Texture {
                        sourceItem: Item {
                            width: 96
                            height: 96

                            Text {
                                anchors.centerIn: parent
                                width: 88
                                height: 88
                                text: modelData.displayIndex
                                color: "#ff1717"
                                font.bold: true
                                font.pixelSize: 148
                                fontSizeMode: Text.Fit
                                minimumPixelSize: 18
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                    alphaMode: PrincipledMaterial.Mask
                    alphaCutoff: 0.04
                    cullMode: Material.NoCulling
                }
            }
        }

        Repeater3D {
            model: app.stoneItems
            delegate: Model {
                readonly property int gx: modelData.x
                readonly property int gy: modelData.y
                readonly property int gz: modelData.z
                readonly property bool gridPoint: true
                property int occupant: modelData.player
                property bool clipped: app.isClipped(gx, gy, gz)

                source: "#Sphere"
                pickable: false
                visible: true
                position: modelData.position
                scale: Qt.vector3d(app.stoneModelScale(),
                                   app.stoneModelScale(),
                                   app.stoneModelScale())
                opacity: clipped ? app.hiddenLayerOpacity() : 1
                materials: PrincipledMaterial {
                    lighting: app.stoneLightingEnabled
                              ? PrincipledMaterial.FragmentLighting
                              : PrincipledMaterial.NoLighting
                    baseColor: occupant === 1 ? "#06080b" : "#fff8e8"
                    alphaMode: PrincipledMaterial.Blend
                    metalness: 0
                    roughness: occupant === 1 ? 0.46 : 0.62
                }
            }
        }

        Repeater3D {
            model: app.gomokuWinLineItems

            delegate: Model {
                readonly property bool clipped: app.isClipped(modelData.startX, modelData.startY, modelData.startZ)
                                                || app.isClipped(modelData.endX, modelData.endY, modelData.endZ)

                source: "#Cylinder"
                pickable: false
                visible: app.gameRuleMode === app.gameRuleGomoku
                position: modelData.position
                rotation: modelData.rotation
                scale: modelData.scale
                opacity: clipped ? app.hiddenLayerOpacity() : 0.82
                materials: PrincipledMaterial {
                    lighting: PrincipledMaterial.NoLighting
                    baseColor: "#f01818"
                    alphaMode: PrincipledMaterial.Blend
                    cullMode: Material.NoCulling
                }
            }
        }

        Repeater3D {
            model: app.stoneItems
            delegate: Model {
                readonly property int gx: modelData.x
                readonly property int gy: modelData.y
                readonly property int gz: modelData.z
                property int occupant: modelData.player
                property int moveNumber: modelData.moveNumber
                property bool lastMove: app.isLastMoveAt(gx, gy, gz)
                property bool clipped: app.isClipped(gx, gy, gz)
                readonly property vector3d labelPosition: app.stoneBillboardPosition(modelData.position)
                readonly property real labelScale: app.stoneBillboardScale()

                source: "#Rectangle"
                pickable: false
                visible: app.stoneOverlayVisible(moveNumber, lastMove)
                position: labelPosition
                rotation: app.stoneBillboardRotation(labelPosition)
                scale: Qt.vector3d(labelScale, labelScale, labelScale)
                opacity: clipped ? app.hiddenLayerOpacity() : 1
                materials: PrincipledMaterial {
                    lighting: PrincipledMaterial.NoLighting
                    baseColor: "#ffffff"
                    baseColorMap: Texture {
                        sourceItem: Item {
                            width: 128
                            height: 128

                            Canvas {
                                id: lastMoveMarker3d
                                visible: lastMove
                                anchors.fill: parent
                                onVisibleChanged: requestPaint()
                                onPaint: {
                                    var ctx = getContext("2d")
                                    ctx.clearRect(0, 0, width, height)
                                    if (!lastMove)
                                        return

                                    ctx.fillStyle = "#e3342f"
                                    ctx.beginPath()
                                    ctx.moveTo(10, 10)
                                    ctx.lineTo(56, 10)
                                    ctx.lineTo(10, 56)
                                    ctx.closePath()
                                    ctx.fill()
                                }
                                Component.onCompleted: requestPaint()
                            }

                            Text {
                                visible: app.stoneNumberVisible(moveNumber, lastMove)
                                anchors.centerIn: parent
                                width: 108
                                height: 108
                                text: moveNumber
                                color: app.stoneNumberColor(occupant, lastMove)
                                font.bold: true
                                font.pixelSize: 72
                                fontSizeMode: Text.Fit
                                minimumPixelSize: 18
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
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
}
