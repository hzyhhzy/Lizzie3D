import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick3D

ApplicationWindow {
    id: root
    width: 1280
    height: 820
    visible: true
    color: "#d8e1e6"
    title: "Lizzie3D 7x7x7 Board Demo"

    property int boardSize: 7
    property real spacing: 72
    property real extent: (boardSize - 1) * spacing
    property real halfExtent: extent / 2

    property var points: []
    property var rods: []
    property var stones: ({})
    property var history: []
    property int boardRevision: 0
    property int currentPlayer: 1
    property int stoneCount: 0

    property string hoverKey: ""
    property int hoverX: -1
    property int hoverY: -1
    property int hoverZ: -1
    property string statusText: "Black to move"

    property real cameraYaw: 42
    property real cameraPitch: 28
    property real cameraDistance: 980
    property vector3d cameraTarget: Qt.vector3d(0, 0, 0)
    property real stoneScale: 0.38
    property real gridOpacity: 0.34
    property real hiddenLayerTransparency: 0.86
    property int clipRevision: 0
    property int clipPosX: 0
    property int clipNegX: 0
    property int clipPosY: 0
    property int clipNegY: 0
    property int clipPosZ: 0
    property int clipNegZ: 0
    property var clipAxes: [
        { "axis": "+X", "label": "+x", "dx": 1, "dy": 0, "dz": 0, "color": "#d84a43" },
        { "axis": "-X", "label": "-x", "dx": -1, "dy": 0, "dz": 0, "color": "#d84a43" },
        { "axis": "+Y", "label": "+y", "dx": 0, "dy": 1, "dz": 0, "color": "#39a66a" },
        { "axis": "-Y", "label": "-y", "dx": 0, "dy": -1, "dz": 0, "color": "#39a66a" },
        { "axis": "+Z", "label": "+z", "dx": 0, "dy": 0, "dz": 1, "color": "#3d73d8" },
        { "axis": "-Z", "label": "-z", "dx": 0, "dy": 0, "dz": -1, "color": "#3d73d8" }
    ]

    function clamp(value, low, high) {
        return Math.max(low, Math.min(high, value))
    }

    function keyFor(x, y, z) {
        return x + "," + y + "," + z
    }

    function pointPosition(x, y, z) {
        return Qt.vector3d((x - 3) * spacing, (y - 3) * spacing, (z - 3) * spacing)
    }

    function hiddenLayerOpacity() {
        return clamp(1 - hiddenLayerTransparency, 0.04, 1)
    }

    function hasActiveClip() {
        clipRevision
        return clipPosX + clipNegX + clipPosY + clipNegY + clipPosZ + clipNegZ > 0
    }

    function gridRodOpacity(x1, y1, z1, x2, y2, z2) {
        var clipped = isClipped(x1, y1, z1) || isClipped(x2, y2, z2)
        return clipped ? gridOpacity * hiddenLayerOpacity() : gridOpacity
    }

    function emptyPointOpacity(clipped, hovered) {
        if (hovered)
            return 0.82
        return clipped ? gridOpacity * hiddenLayerOpacity() : Math.max(0.08, gridOpacity * 0.36)
    }

    function isClipped(x, y, z) {
        clipRevision
        return x < clipNegX || x >= boardSize - clipPosX
               || y < clipNegY || y >= boardSize - clipPosY
               || z < clipNegZ || z >= boardSize - clipPosZ
    }

    function clipCount(axisName) {
        clipRevision
        if (axisName === "+X")
            return clipPosX
        if (axisName === "-X")
            return clipNegX
        if (axisName === "+Y")
            return clipPosY
        if (axisName === "-Y")
            return clipNegY
        if (axisName === "+Z")
            return clipPosZ
        if (axisName === "-Z")
            return clipNegZ
        return 0
    }

    function setClipCount(axisName, value) {
        var count = clamp(value, 0, boardSize)
        if (axisName === "+X")
            clipPosX = count
        else if (axisName === "-X")
            clipNegX = count
        else if (axisName === "+Y")
            clipPosY = count
        else if (axisName === "-Y")
            clipNegY = count
        else if (axisName === "+Z")
            clipPosZ = count
        else if (axisName === "-Z")
            clipNegZ = count
        clipRevision += 1
    }

    function adjustClip(axisName, direction) {
        setClipCount(axisName, clipCount(axisName) + direction)
    }

    function frontFacingClipAxis() {
        var yaw = cameraYaw * Math.PI / 180
        var pitch = cameraPitch * Math.PI / 180
        var cp = Math.cos(pitch)
        var x = Math.sin(yaw) * cp
        var y = Math.sin(pitch)
        var z = Math.cos(yaw) * cp
        var ax = Math.abs(x)
        var ay = Math.abs(y)
        var az = Math.abs(z)

        if (ax >= ay && ax >= az)
            return x >= 0 ? "+X" : "-X"
        if (ay >= ax && ay >= az)
            return y >= 0 ? "+Y" : "-Y"
        return z >= 0 ? "+Z" : "-Z"
    }

    function resetClipCounts() {
        clipPosX = 0
        clipNegX = 0
        clipPosY = 0
        clipNegY = 0
        clipPosZ = 0
        clipNegZ = 0
        clipRevision += 1
    }

    function buildPoints() {
        var data = []
        for (var y = 0; y < boardSize; ++y) {
            for (var z = 0; z < boardSize; ++z) {
                for (var x = 0; x < boardSize; ++x) {
                    data.push({
                        "x": x,
                        "y": y,
                        "z": z,
                        "key": keyFor(x, y, z),
                        "position": pointPosition(x, y, z)
                    })
                }
            }
        }
        return data
    }

    function buildRods() {
        var data = []
        for (var xy = 0; xy < boardSize; ++xy) {
            for (var xz = 0; xz < boardSize; ++xz) {
                for (var xx = 0; xx < boardSize - 1; ++xx) {
                    data.push({
                        "axis": 0,
                        "x": xx + 0.5,
                        "y": xy,
                        "z": xz,
                        "x1": xx,
                        "y1": xy,
                        "z1": xz,
                        "x2": xx + 1,
                        "y2": xy,
                        "z2": xz
                    })
                }
            }
        }
        for (var yx = 0; yx < boardSize; ++yx) {
            for (var yz = 0; yz < boardSize; ++yz) {
                for (var yy = 0; yy < boardSize - 1; ++yy) {
                    data.push({
                        "axis": 1,
                        "x": yx,
                        "y": yy + 0.5,
                        "z": yz,
                        "x1": yx,
                        "y1": yy,
                        "z1": yz,
                        "x2": yx,
                        "y2": yy + 1,
                        "z2": yz
                    })
                }
            }
        }
        for (var zx = 0; zx < boardSize; ++zx) {
            for (var zy = 0; zy < boardSize; ++zy) {
                for (var zz = 0; zz < boardSize - 1; ++zz) {
                    data.push({
                        "axis": 2,
                        "x": zx,
                        "y": zy,
                        "z": zz + 0.5,
                        "x1": zx,
                        "y1": zy,
                        "z1": zz,
                        "x2": zx,
                        "y2": zy,
                        "z2": zz + 1
                    })
                }
            }
        }
        return data
    }

    function stoneAt(x, y, z) {
        boardRevision
        var value = stones[keyFor(x, y, z)]
        return value === undefined ? 0 : value
    }

    function playerName(player) {
        return player === 1 ? "Black" : "White"
    }

    function placeStone(x, y, z) {
        var key = keyFor(x, y, z)
        if (stones[key] !== undefined) {
            statusText = "Occupied: " + coordinateText(x, y, z)
            return
        }

        stones[key] = currentPlayer
        history.push({ "x": x, "y": y, "z": z, "player": currentPlayer, "key": key })
        stoneCount += 1
        currentPlayer = currentPlayer === 1 ? 2 : 1
        boardRevision += 1
        statusText = playerName(currentPlayer) + " to move"
    }

    function undoMove() {
        if (history.length === 0)
            return

        var move = history.pop()
        delete stones[move.key]
        currentPlayer = move.player
        stoneCount -= 1
        boardRevision += 1
        statusText = playerName(currentPlayer) + " to move"
    }

    function clearBoard() {
        stones = ({})
        history = []
        stoneCount = 0
        currentPlayer = 1
        boardRevision += 1
        statusText = "Black to move"
    }

    function coordinateText(x, y, z) {
        return "(" + (x + 1) + ", " + (y + 1) + ", " + (z + 1) + ")"
    }

    function mainAxisOrigin() {
        return pointPosition(-1, -1, -1)
    }

    function mainAxisLabelPoint(axisName) {
        cameraYaw
        cameraPitch
        cameraDistance
        cameraTarget
        if (!boardView.camera)
            return Qt.point(-1000, -1000)

        var origin = mainAxisOrigin()
        var end = origin
        if (axisName === "x")
            end = Qt.vector3d(origin.x + spacing * 0.95, origin.y, origin.z)
        else if (axisName === "y")
            end = Qt.vector3d(origin.x, origin.y + spacing * 0.95, origin.z)
        else
            end = Qt.vector3d(origin.x, origin.y, origin.z + spacing * 0.95)
        return boardView.mapFrom3DScene(end)
    }

    function projectedAxisVector(dx, dy, dz) {
        cameraYaw
        cameraPitch

        var yaw = cameraYaw * Math.PI / 180
        var pitch = cameraPitch * Math.PI / 180
        var rightX = Math.cos(yaw)
        var rightZ = -Math.sin(yaw)
        var upX = -Math.sin(pitch) * Math.sin(yaw)
        var upY = Math.cos(pitch)
        var upZ = -Math.sin(pitch) * Math.cos(yaw)
        var sx = dx * rightX + dz * rightZ
        var sy = -(dx * upX + dy * upY + dz * upZ)
        return Qt.point(sx, sy)
    }

    function projectedAxisPoint(dx, dy, dz, center, radius) {
        var v = projectedAxisVector(dx, dy, dz)
        return Qt.point(center + v.x * radius, center + v.y * radius)
    }

    function projectedAxisAngle(dx, dy, dz) {
        var v = projectedAxisVector(dx, dy, dz)
        return Math.atan2(v.y, v.x) * 180 / Math.PI
    }

    function axisGizmoLabelPoint(dx, dy, dz) {
        cameraYaw
        cameraPitch
        if (!axisView.camera)
            return Qt.point(-1000, -1000)
        return axisView.mapFrom3DScene(Qt.vector3d(dx * 86, dy * 86, dz * 86))
    }

    function refreshCamera() {
        var yaw = cameraYaw * Math.PI / 180
        var pitch = cameraPitch * Math.PI / 180
        var cp = Math.cos(pitch)
        boardCamera.position = Qt.vector3d(
            cameraTarget.x + cameraDistance * Math.sin(yaw) * cp,
            cameraTarget.y + cameraDistance * Math.sin(pitch),
            cameraTarget.z + cameraDistance * Math.cos(yaw) * cp)
        boardCamera.lookAt(cameraTarget)
        refreshAxisCamera()
    }

    function refreshAxisCamera() {
        if (!axisCamera)
            return

        var yaw = cameraYaw * Math.PI / 180
        var pitch = cameraPitch * Math.PI / 180
        var cp = Math.cos(pitch)
        var distance = 320
        axisCamera.position = Qt.vector3d(
            distance * Math.sin(yaw) * cp,
            distance * Math.sin(pitch),
            distance * Math.cos(yaw) * cp)
        axisCamera.lookAt(Qt.vector3d(0, 0, 0))
    }

    function alignCameraToAxis(axisName) {
        if (axisName === "+X") {
            cameraYaw = 90
            cameraPitch = 0
        } else if (axisName === "-X") {
            cameraYaw = -90
            cameraPitch = 0
        } else if (axisName === "+Y") {
            cameraYaw = 0
            cameraPitch = 88
        } else if (axisName === "-Y") {
            cameraYaw = 0
            cameraPitch = -88
        } else if (axisName === "+Z") {
            cameraYaw = 0
            cameraPitch = 0
        } else if (axisName === "-Z") {
            cameraYaw = 180
            cameraPitch = 0
        }
        refreshCamera()
    }

    function resetCamera() {
        cameraYaw = 42
        cameraPitch = 28
        cameraDistance = 980
        cameraTarget = Qt.vector3d(0, 0, 0)
        refreshCamera()
    }

    function moveTarget(forward, right, up, amountOverride) {
        var yaw = cameraYaw * Math.PI / 180
        var forwardX = Math.sin(yaw)
        var forwardZ = Math.cos(yaw)
        var rightX = Math.cos(yaw)
        var rightZ = -Math.sin(yaw)
        var amount = amountOverride === undefined ? 36 : amountOverride

        cameraTarget = Qt.vector3d(
            cameraTarget.x + amount * (forward * forwardX + right * rightX),
            cameraTarget.y + amount * up,
            cameraTarget.z + amount * (forward * forwardZ + right * rightZ))
        refreshCamera()
    }

    function panCamera(deltaX, deltaY) {
        var yaw = cameraYaw * Math.PI / 180
        var rightX = Math.cos(yaw)
        var rightZ = -Math.sin(yaw)
        var forwardX = Math.sin(yaw)
        var forwardZ = Math.cos(yaw)
        var amount = cameraDistance / 760

        cameraTarget = Qt.vector3d(
            cameraTarget.x - deltaX * amount * rightX + deltaY * amount * forwardX,
            cameraTarget.y,
            cameraTarget.z - deltaX * amount * rightZ + deltaY * amount * forwardZ)
        refreshCamera()
    }

    function modelIsGridPoint(model) {
        return model && model.gridPoint === true
    }

    function updateHover(x, y) {
        var result = boardView.pick(x, y)
        var hit = result.objectHit
        if (modelIsGridPoint(hit)) {
            hoverX = hit.gx
            hoverY = hit.gy
            hoverZ = hit.gz
            hoverKey = keyFor(hoverX, hoverY, hoverZ)
        } else {
            hoverX = -1
            hoverY = -1
            hoverZ = -1
            hoverKey = ""
        }
    }

    function placeFromMouse(x, y) {
        var result = boardView.pick(x, y)
        var hit = result.objectHit
        if (modelIsGridPoint(hit) && !isClipped(hit.gx, hit.gy, hit.gz))
            placeStone(hit.gx, hit.gy, hit.gz)
    }

    onClipRevisionChanged: {
        if (hoverKey !== "" && isClipped(hoverX, hoverY, hoverZ)) {
            hoverX = -1
            hoverY = -1
            hoverZ = -1
            hoverKey = ""
        }
    }

    Component.onCompleted: {
        points = buildPoints()
        rods = buildRods()
        resetCamera()
    }

    View3D {
        id: boardView
        anchors.fill: parent
        camera: boardCamera

        environment: SceneEnvironment {
            backgroundMode: SceneEnvironment.Color
            clearColor: "#d8e1e6"
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
            eulerRotation.x: -46
            eulerRotation.y: 34
            brightness: 1.55
            castsShadow: true
        }

        PointLight {
            position: Qt.vector3d(-360, 460, -420)
            brightness: 165
            color: "#ffffff"
        }

        Node {
            id: boardRoot

            Repeater3D {
                model: root.rods
                delegate: Model {
                    readonly property int axis: modelData.axis
                    readonly property real gx: modelData.x
                    readonly property real gy: modelData.y
                    readonly property real gz: modelData.z
                    readonly property int x1: modelData.x1
                    readonly property int y1: modelData.y1
                    readonly property int z1: modelData.z1
                    readonly property int x2: modelData.x2
                    readonly property int y2: modelData.y2
                    readonly property int z2: modelData.z2

                    source: "#Cube"
                    pickable: false
                    opacity: root.gridRodOpacity(x1, y1, z1, x2, y2, z2)
                    position: root.pointPosition(gx, gy, gz)
                    scale: axis === 0
                           ? Qt.vector3d(root.spacing / 100, 0.012, 0.012)
                           : axis === 1
                             ? Qt.vector3d(0.012, root.spacing / 100, 0.012)
                             : Qt.vector3d(0.012, 0.012, root.spacing / 100)
                    materials: PrincipledMaterial {
                        baseColor: axis === 1 ? "#3f5968" : "#7b5f36"
                        alphaMode: PrincipledMaterial.Blend
                        roughness: 0.72
                    }
                }
            }

            Repeater3D {
                model: [
                    { "axis": "x", "dx": 1, "dy": 0, "dz": 0, "color": "#d84a43" },
                    { "axis": "y", "dx": 0, "dy": 1, "dz": 0, "color": "#39a66a" },
                    { "axis": "z", "dx": 0, "dy": 0, "dz": 1, "color": "#3d73d8" }
                ]

                delegate: Model {
                    readonly property vector3d origin: root.mainAxisOrigin()
                    readonly property real axisLength: root.spacing * 0.95
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
                    { "axis": "x", "dx": 1, "dy": 0, "dz": 0, "color": "#d84a43" },
                    { "axis": "y", "dx": 0, "dy": 1, "dz": 0, "color": "#39a66a" },
                    { "axis": "z", "dx": 0, "dy": 0, "dz": 1, "color": "#3d73d8" }
                ]

                delegate: Model {
                    readonly property vector3d origin: root.mainAxisOrigin()
                    readonly property real axisLength: root.spacing * 0.95

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
                model: root.points
                delegate: Model {
                    readonly property int gx: modelData.x
                    readonly property int gy: modelData.y
                    readonly property int gz: modelData.z
                    readonly property bool gridPoint: true
                    property int occupant: root.stoneAt(gx, gy, gz)
                    property bool clipped: root.isClipped(gx, gy, gz)

                    source: "#Sphere"
                    pickable: !clipped
                    visible: occupant === 0
                    position: modelData.position
                    scale: Qt.vector3d(0.14, 0.14, 0.14)
                    opacity: root.emptyPointOpacity(clipped, root.hoverKey === modelData.key)
                    materials: PrincipledMaterial {
                        baseColor: root.hoverKey === modelData.key ? "#2fb97f" : "#6e8794"
                        alphaMode: PrincipledMaterial.Blend
                        roughness: 0.54
                    }
                }
            }

            Repeater3D {
                model: root.points
                delegate: Model {
                    readonly property int gx: modelData.x
                    readonly property int gy: modelData.y
                    readonly property int gz: modelData.z
                    readonly property bool gridPoint: true
                    property int occupant: root.stoneAt(gx, gy, gz)
                    property bool clipped: root.isClipped(gx, gy, gz)

                    source: "#Sphere"
                    pickable: !clipped
                    visible: occupant !== 0
                    position: modelData.position
                    scale: Qt.vector3d(root.stoneScale, root.stoneScale, root.stoneScale)
                    opacity: clipped ? root.hiddenLayerOpacity() : 1
                    materials: PrincipledMaterial {
                        baseColor: occupant === 1 ? "#06080b" : "#fff8e8"
                        alphaMode: PrincipledMaterial.Blend
                        metalness: 0
                        roughness: occupant === 1 ? 0.28 : 0.22
                    }
                }
            }
        }
    }

    Repeater {
        model: [
            { "axis": "x", "color": "#d84a43" },
            { "axis": "y", "color": "#39a66a" },
            { "axis": "z", "color": "#3d73d8" }
        ]

        delegate: Text {
            property var screenPoint: root.mainAxisLabelPoint(modelData.axis)

            x: screenPoint.x - width / 2
            y: screenPoint.y - height / 2
            z: 6
            text: modelData.axis
            color: modelData.color
            font.pixelSize: 18
            font.bold: true
            style: Text.Outline
            styleColor: "#eef4f7"
        }
    }

    Item {
        id: inputLayer
        anchors.fill: parent
        focus: true

        property real lastX: 0
        property real lastY: 0
        property bool moved: false
        property int pressedButton: 0
        property bool forwardHeld: false
        property bool backHeld: false
        property bool leftHeld: false
        property bool rightHeld: false
        property bool upHeld: false
        property bool downHeld: false
        property bool turnLeftHeld: false
        property bool turnRightHeld: false

        function hasHeldNavigationKey() {
            return forwardHeld || backHeld || leftHeld || rightHeld
                   || upHeld || downHeld || turnLeftHeld || turnRightHeld
        }

        function clearHeldNavigationKeys() {
            forwardHeld = false
            backHeld = false
            leftHeld = false
            rightHeld = false
            upHeld = false
            downHeld = false
            turnLeftHeld = false
            turnRightHeld = false
        }

        onActiveFocusChanged: {
            if (!activeFocus)
                clearHeldNavigationKeys()
        }

        Timer {
            interval: 16
            repeat: true
            running: inputLayer.hasHeldNavigationKey()

            onTriggered: {
                var forward = (inputLayer.forwardHeld ? 1 : 0) - (inputLayer.backHeld ? 1 : 0)
                var right = (inputLayer.rightHeld ? 1 : 0) - (inputLayer.leftHeld ? 1 : 0)
                var up = (inputLayer.upHeld ? 1 : 0) - (inputLayer.downHeld ? 1 : 0)
                var length = Math.sqrt(forward * forward + right * right + up * up)

                if (length > 0) {
                    var step = Math.max(3.6, root.cameraDistance * 0.006)
                    root.moveTarget(forward / length, right / length, up / length, step)
                }

                var turn = (inputLayer.turnRightHeld ? 1 : 0) - (inputLayer.turnLeftHeld ? 1 : 0)
                if (turn !== 0) {
                    root.cameraYaw += turn * 1.15
                    root.refreshCamera()
                }
            }
        }

        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_W) {
                inputLayer.forwardHeld = true
                event.accepted = true
            } else if (event.key === Qt.Key_S) {
                inputLayer.backHeld = true
                event.accepted = true
            } else if (event.key === Qt.Key_A) {
                inputLayer.leftHeld = true
                event.accepted = true
            } else if (event.key === Qt.Key_D) {
                inputLayer.rightHeld = true
                event.accepted = true
            } else if (event.key === Qt.Key_Q) {
                root.adjustClip(root.frontFacingClipAxis(), -1)
                event.accepted = true
            } else if (event.key === Qt.Key_E) {
                root.adjustClip(root.frontFacingClipAxis(), 1)
                event.accepted = true
            } else if (event.key === Qt.Key_Left) {
                inputLayer.turnLeftHeld = true
                event.accepted = true
            } else if (event.key === Qt.Key_Right) {
                inputLayer.turnRightHeld = true
                event.accepted = true
            } else if (event.key === Qt.Key_R) {
                inputLayer.upHeld = true
                event.accepted = true
            } else if (event.key === Qt.Key_F) {
                inputLayer.downHeld = true
                event.accepted = true
            } else if (event.key === Qt.Key_Space) {
                if (!event.isAutoRepeat)
                    root.resetCamera()
                event.accepted = true
            } else if (event.key === Qt.Key_Backspace) {
                if (!event.isAutoRepeat)
                    root.undoMove()
                event.accepted = true
            }
        }

        Keys.onReleased: function(event) {
            if (event.key === Qt.Key_W) {
                inputLayer.forwardHeld = false
                event.accepted = true
            } else if (event.key === Qt.Key_S) {
                inputLayer.backHeld = false
                event.accepted = true
            } else if (event.key === Qt.Key_A) {
                inputLayer.leftHeld = false
                event.accepted = true
            } else if (event.key === Qt.Key_D) {
                inputLayer.rightHeld = false
                event.accepted = true
            } else if (event.key === Qt.Key_Left) {
                inputLayer.turnLeftHeld = false
                event.accepted = true
            } else if (event.key === Qt.Key_Right) {
                inputLayer.turnRightHeld = false
                event.accepted = true
            } else if (event.key === Qt.Key_R) {
                inputLayer.upHeld = false
                event.accepted = true
            } else if (event.key === Qt.Key_F) {
                inputLayer.downHeld = false
                event.accepted = true
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

            onPressed: function(mouse) {
                inputLayer.forceActiveFocus()
                inputLayer.lastX = mouse.x
                inputLayer.lastY = mouse.y
                inputLayer.moved = false
                inputLayer.pressedButton = mouse.button
                mouse.accepted = true
            }

            onPositionChanged: function(mouse) {
                var dx = mouse.x - inputLayer.lastX
                var dy = mouse.y - inputLayer.lastY

                if (mouse.buttons & Qt.LeftButton) {
                    if (Math.abs(dx) + Math.abs(dy) > 2)
                        inputLayer.moved = true
                    root.cameraYaw -= dx * 0.32
                    root.cameraPitch = root.clamp(root.cameraPitch + dy * 0.22, -62, 78)
                    root.refreshCamera()
                } else if ((mouse.buttons & Qt.RightButton) || (mouse.buttons & Qt.MiddleButton)) {
                    if (Math.abs(dx) + Math.abs(dy) > 2)
                        inputLayer.moved = true
                    root.panCamera(dx, dy)
                } else {
                    root.updateHover(mouse.x, mouse.y)
                }

                inputLayer.lastX = mouse.x
                inputLayer.lastY = mouse.y
            }

            onReleased: function(mouse) {
                if (inputLayer.pressedButton === Qt.LeftButton && !inputLayer.moved)
                    root.placeFromMouse(mouse.x, mouse.y)
                inputLayer.pressedButton = 0
                root.updateHover(mouse.x, mouse.y)
                mouse.accepted = true
            }

            onWheel: function(wheel) {
                var factor = wheel.angleDelta.y > 0 ? 0.9 : 1.12
                root.cameraDistance = root.clamp(root.cameraDistance * factor, 360, 1900)
                root.refreshCamera()
                wheel.accepted = true
            }
        }
    }

    Rectangle {
        id: axisGizmoPanel
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 18
        width: 174
        height: 174
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
            model: root.clipAxes

            delegate: Text {
                property var screenPoint: root.axisGizmoLabelPoint(modelData.dx, modelData.dy, modelData.dz)

                x: axisView.x + screenPoint.x - width / 2
                y: axisView.y + screenPoint.y - height / 2
                z: 2
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
            text: "click axis"
            color: "#41515a"
            font.pixelSize: 12
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton

            onClicked: function(mouse) {
                inputLayer.forceActiveFocus()
                var result = axisView.pick(mouse.x - axisView.x, mouse.y - axisView.y)
                var hit = result.objectHit
                if (hit && hit.axisHandle)
                    root.alignCameraToAxis(hit.axisName)
                mouse.accepted = true
            }
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 18
        width: 314
        height: 166
        radius: 8
        color: "#e7eef2"
        border.color: "#bcc9d0"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 8

            Label {
                text: "7x7x7 Board Demo"
                color: "#17212a"
                font.pixelSize: 20
                font.bold: true
                Layout.fillWidth: true
            }

            Label {
                text: root.statusText
                color: root.currentPlayer === 1 ? "#111318" : "#697178"
                font.pixelSize: 15
                font.bold: true
                Layout.fillWidth: true
            }

            Label {
                text: "Stones: " + root.stoneCount + " / " + (root.boardSize * root.boardSize * root.boardSize)
                color: "#33424d"
                font.pixelSize: 14
                Layout.fillWidth: true
            }

            Label {
                text: root.hoverKey === "" ? "Hover: none" : "Hover: " + root.coordinateText(root.hoverX, root.hoverY, root.hoverZ)
                color: "#33424d"
                font.pixelSize: 14
                Layout.fillWidth: true
            }

            RowLayout {
                spacing: 8

                Button {
                    text: "Undo"
                    enabled: root.stoneCount > 0
                    onClicked: root.undoMove()
                }

                Button {
                    text: "Clear"
                    enabled: root.stoneCount > 0
                    onClicked: root.clearBoard()
                }
            }
        }
    }

    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 18
        width: 300
        height: 172
        visible: false
        radius: 8
        color: "#f3f7f9"
        border.color: "#b9c8d0"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 10

            Label {
                text: "视觉设置"
                color: "#17212a"
                font.pixelSize: 18
                font.bold: true
                Layout.fillWidth: true
            }

            Label {
                text: "棋子大小  " + Math.round(root.stoneScale * 100) + "%"
                color: "#2f414c"
                font.pixelSize: 14
                Layout.fillWidth: true
            }

            Slider {
                from: 0.26
                to: 0.56
                value: root.stoneScale
                stepSize: 0.01
                Layout.fillWidth: true
                onMoved: root.stoneScale = value
            }

            Label {
                text: "网格透明度  " + Math.round(root.gridOpacity * 100) + "%"
                color: "#2f414c"
                font.pixelSize: 14
                Layout.fillWidth: true
            }

            Slider {
                from: 0.12
                to: 0.9
                value: root.gridOpacity
                stepSize: 0.01
                Layout.fillWidth: true
                onMoved: root.gridOpacity = value
            }
        }
    }

    Rectangle {
        id: visualPanel
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 18
        width: 300
        height: 238
        radius: 8
        color: "#f3f7f9"
        border.color: "#b9c8d0"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 8

            Label {
                text: "Visual settings"
                color: "#17212a"
                font.pixelSize: 18
                font.bold: true
                Layout.fillWidth: true
            }

            Label {
                text: "Stone size  " + Math.round(root.stoneScale * 100) + "%"
                color: "#2f414c"
                font.pixelSize: 14
                Layout.fillWidth: true
            }

            Slider {
                from: 0.26
                to: 0.56
                value: root.stoneScale
                stepSize: 0.01
                Layout.fillWidth: true
                onMoved: root.stoneScale = value
            }

            Label {
                text: "Grid opacity  " + Math.round(root.gridOpacity * 100) + "%"
                color: "#2f414c"
                font.pixelSize: 14
                Layout.fillWidth: true
            }

            Slider {
                from: 0.12
                to: 0.9
                value: root.gridOpacity
                stepSize: 0.01
                Layout.fillWidth: true
                onMoved: root.gridOpacity = value
            }

            Label {
                text: "Hidden transparency  " + Math.round(root.hiddenLayerTransparency * 100) + "%"
                color: "#2f414c"
                font.pixelSize: 14
                Layout.fillWidth: true
            }

            Slider {
                from: 0.2
                to: 0.98
                value: root.hiddenLayerTransparency
                stepSize: 0.01
                Layout.fillWidth: true
                onMoved: root.hiddenLayerTransparency = value
            }
        }
    }

    Rectangle {
        id: clipPanel
        anchors.right: parent.right
        anchors.rightMargin: 18
        anchors.top: visualPanel.bottom
        anchors.topMargin: 14
        width: 300
        height: 526
        radius: 8
        color: "#f3f7f9"
        border.color: "#b9c8d0"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 8

            RowLayout {
                Layout.fillWidth: true

                Label {
                    text: "Clip layers"
                    color: "#17212a"
                    font.pixelSize: 18
                    font.bold: true
                    Layout.fillWidth: true
                }

                Button {
                    text: "Reset"
                    onClicked: {
                        inputLayer.forceActiveFocus()
                        root.resetClipCounts()
                    }
                }
            }

            Label {
                text: "Active axis: " + root.frontFacingClipAxis()
                color: "#52636d"
                font.pixelSize: 12
                Layout.fillWidth: true
            }

            Item {
                id: clipCross
                property real center: width / 2
                property real axisRadius: 74

                width: 204
                height: 204
                Layout.alignment: Qt.AlignHCenter

                Repeater {
                    model: [
                        { "dx": 1, "dy": 0, "dz": 0, "color": "#d84a43" },
                        { "dx": 0, "dy": 1, "dz": 0, "color": "#39a66a" },
                        { "dx": 0, "dy": 0, "dz": 1, "color": "#3d73d8" }
                    ]

                    delegate: Rectangle {
                        x: clipCross.center - width / 2
                        y: clipCross.center - height / 2
                        width: clipCross.axisRadius * 2
                        height: 3
                        radius: 2
                        rotation: root.projectedAxisAngle(modelData.dx, modelData.dy, modelData.dz)
                        transformOrigin: Item.Center
                        color: modelData.color
                        opacity: 0.56
                    }
                }

                Rectangle {
                    x: clipCross.center - width / 2
                    y: clipCross.center - height / 2
                    width: 10
                    height: 10
                    radius: 5
                    color: "#52636d"
                    opacity: 0.7
                }

                Repeater {
                    model: root.clipAxes

                    delegate: Rectangle {
                        id: clipBubble
                        property var bubbleCenter: root.projectedAxisPoint(modelData.dx,
                                                                           modelData.dy,
                                                                           modelData.dz,
                                                                           clipCross.center,
                                                                           clipCross.axisRadius)

                        x: bubbleCenter.x - width / 2
                        y: bubbleCenter.y - height / 2
                        width: 44
                        height: 44
                        radius: 22
                        color: clipMouse.containsMouse
                               ? "#d5edf7"
                               : root.clipCount(modelData.axis) > 0
                                 ? "#eef8fb"
                                 : "#ffffff"
                        border.width: 2
                        border.color: clipMouse.containsMouse ? "#3489a6" : modelData.color

                        Column {
                            anchors.centerIn: parent
                            spacing: -2

                            Text {
                                text: modelData.axis
                                color: "#41515a"
                                font.pixelSize: 10
                                horizontalAlignment: Text.AlignHCenter
                                width: clipBubble.width
                            }

                            Text {
                                text: root.clipCount(modelData.axis)
                                color: "#16212a"
                                font.pixelSize: 17
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                                width: clipBubble.width
                            }
                        }

                        MouseArea {
                            id: clipMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.LeftButton

                            onClicked: {
                                inputLayer.forceActiveFocus()
                            }

                            onWheel: function(wheel) {
                                inputLayer.forceActiveFocus()
                                root.adjustClip(modelData.axis, wheel.angleDelta.y > 0 ? 1 : -1)
                                wheel.accepted = true
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6

                    Label {
                        text: "Axis"
                        color: "#52636d"
                        font.pixelSize: 12
                        Layout.preferredWidth: 42
                    }

                    Label {
                        text: "Layers"
                        color: "#52636d"
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                    }

                    Label {
                        text: "Edit"
                        color: "#52636d"
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        Layout.preferredWidth: 76
                    }
                }

                Repeater {
                    model: root.clipAxes

                    delegate: RowLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        Label {
                            text: modelData.axis
                            color: modelData.color
                            font.pixelSize: 13
                            font.bold: true
                            Layout.preferredWidth: 42
                        }

                        Label {
                            text: root.clipCount(modelData.axis)
                            color: "#16212a"
                            font.pixelSize: 15
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            Layout.fillWidth: true
                        }

                        RowLayout {
                            spacing: 4
                            Layout.preferredWidth: 76

                            Button {
                                text: "-"
                                enabled: root.clipCount(modelData.axis) > 0
                                Layout.preferredWidth: 34
                                Layout.preferredHeight: 28
                                onClicked: {
                                    inputLayer.forceActiveFocus()
                                    root.adjustClip(modelData.axis, -1)
                                }
                            }

                            Button {
                                text: "+"
                                enabled: root.clipCount(modelData.axis) < root.boardSize
                                Layout.preferredWidth: 34
                                Layout.preferredHeight: 28
                                onClicked: {
                                    inputLayer.forceActiveFocus()
                                    root.adjustClip(modelData.axis, 1)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
