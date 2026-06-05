import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtQuick3D

ApplicationWindow {
    id: root
    width: Math.min(1600, Screen.desktopAvailableWidth > 0 ? Screen.desktopAvailableWidth : 1600)
    height: Math.min(900, Screen.desktopAvailableHeight > 0 ? Screen.desktopAvailableHeight : 900)
    minimumWidth: 1024
    minimumHeight: 640
    visible: true
    color: "#bcc8cf"
    property string language: "zh"
    property var translations: ({
        "zh": {
            "windowTitle": "Lizzie3D",
            "menuFile": "文件",
            "menuEdit": "编辑",
            "menuView": "视图",
            "menuSettings": "设置",
            "menuSaveSgf": "保存 SGF...",
            "menuExit": "退出",
            "menuUndo": "撤销",
            "menuDeleteNode": "删除当前节点",
            "menuClearBoard": "清空棋盘",
            "menuResetCamera": "重置镜头",
            "menuResetClip": "重置裁剪层",
            "menuResetVisual": "重置视觉设置",
            "menuLanguage": "语言",
            "languageChinese": "中文",
            "languageEnglish": "English",
            "black": "黑方",
            "white": "白方",
            "toMove": "落子",
            "occupied": "已有棋子",
            "stones": "棋子",
            "hoverNone": "悬停：无",
            "hover": "悬停",
            "undo": "撤销",
            "clear": "清空",
            "axisHint": "点击轴",
            "visualSettings": "视觉设置",
            "boardSize": "棋盘大小",
            "stoneSize": "棋子大小",
            "gridPointOpacity": "框线/交叉点透明度",
            "hideLines": "隐藏框线",
            "hidePoints": "隐藏交叉点",
            "hiddenTransparency": "隐藏层透明度",
            "reset": "重置",
            "clipLayers": "裁剪层",
            "activeAxis": "当前轴",
            "axis": "方向",
            "layers": "层数",
            "edit": "操作",
            "gameTree": "分支树",
            "currentMove": "当前",
            "rootMove": "起点",
            "moveNumber": "手数",
            "deleteNodeTitle": "删除节点",
            "confirmDeleteBranch": "当前节点存在后续分支，是否删除？",
            "sgfFileFilter": "SGF 文件 (*.sgf)",
            "allFileFilter": "所有文件 (*)",
            "sgfSaveTitle": "保存 SGF",
            "sgfSaved": "SGF 已保存",
            "sgfSaveFailed": "SGF 保存失败",
            "moveNumberDisplay": "手数显示",
            "moveNumberAll": "全部手数",
            "moveNumberLastOnly": "仅最后一手",
            "moveNumberHidden": "隐藏数字",
            "stoneLighting": "棋子打光",
            "lightFollowsCamera": "灯光跟随镜头"
        },
        "en": {
            "windowTitle": "Lizzie3D",
            "menuFile": "File",
            "menuEdit": "Edit",
            "menuView": "View",
            "menuSettings": "Settings",
            "menuSaveSgf": "Save SGF...",
            "menuExit": "Exit",
            "menuUndo": "Undo",
            "menuDeleteNode": "Delete current node",
            "menuClearBoard": "Clear board",
            "menuResetCamera": "Reset camera",
            "menuResetClip": "Reset clip layers",
            "menuResetVisual": "Reset visual settings",
            "menuLanguage": "Language",
            "languageChinese": "中文",
            "languageEnglish": "English",
            "black": "Black",
            "white": "White",
            "toMove": "to move",
            "occupied": "Occupied",
            "stones": "Stones",
            "hoverNone": "Hover: none",
            "hover": "Hover",
            "undo": "Undo",
            "clear": "Clear",
            "axisHint": "click axis",
            "visualSettings": "Visual settings",
            "boardSize": "Board size",
            "stoneSize": "Stone size",
            "gridPointOpacity": "Grid/point opacity",
            "hideLines": "Hide lines",
            "hidePoints": "Hide points",
            "hiddenTransparency": "Hidden transparency",
            "reset": "Reset",
            "clipLayers": "Clip layers",
            "activeAxis": "Active axis",
            "axis": "Axis",
            "layers": "Layers",
            "edit": "Edit",
            "gameTree": "Game tree",
            "currentMove": "Current",
            "rootMove": "Start",
            "moveNumber": "Move",
            "deleteNodeTitle": "Delete node",
            "confirmDeleteBranch": "The current node has following branches. Delete it?",
            "sgfFileFilter": "SGF files (*.sgf)",
            "allFileFilter": "All files (*)",
            "sgfSaveTitle": "Save SGF",
            "sgfSaved": "SGF saved",
            "sgfSaveFailed": "Failed to save SGF",
            "moveNumberDisplay": "Move labels",
            "moveNumberAll": "All move numbers",
            "moveNumberLastOnly": "Last move only",
            "moveNumberHidden": "No numbers",
            "stoneLighting": "Light stones",
            "lightFollowsCamera": "Light follows camera"
        }
    })

    title: root.windowTitleText()

    menuBar: MenuBar {
        Menu {
            title: root.trText("menuFile")

            Action {
                text: root.trText("menuSaveSgf")
                onTriggered: root.openSaveSgfDialog()
            }

            Action {
                text: root.trText("menuExit")
                onTriggered: Qt.quit()
            }
        }

        Menu {
            title: root.trText("menuEdit")

            Action {
                text: root.trText("menuUndo")
                enabled: root.currentNodeId !== 0
                onTriggered: root.undoMove()
            }

            Action {
                text: root.trText("menuDeleteNode")
                enabled: root.currentNodeId !== 0
                onTriggered: root.requestDeleteCurrentNode()
            }

            Action {
                text: root.trText("menuClearBoard")
                enabled: root.treeNodes.length > 1
                onTriggered: root.clearBoard()
            }
        }

        Menu {
            title: root.trText("menuView")

            Action {
                text: root.trText("menuResetCamera")
                onTriggered: root.resetCamera()
            }

            Action {
                text: root.trText("menuResetClip")
                onTriggered: root.resetClipCounts()
            }
        }

        Menu {
            title: root.trText("menuSettings")

            Action {
                text: root.trText("menuResetVisual")
                onTriggered: root.resetVisualSettings()
            }

            MenuSeparator {}

            Menu {
                title: root.trText("menuLanguage")

                Action {
                    text: root.trText("languageChinese")
                    checkable: true
                    checked: root.language === "zh"
                    onTriggered: root.language = "zh"
                }

                Action {
                    text: root.trText("languageEnglish")
                    checkable: true
                    checked: root.language === "en"
                    onTriggered: root.language = "en"
                }
            }
        }
    }

    FileDialog {
        id: saveSgfDialog
        title: root.trText("sgfSaveTitle")
        fileMode: FileDialog.SaveFile
        defaultSuffix: "sgf"
        nameFilters: [root.trText("sgfFileFilter"), root.trText("allFileFilter")]
        onAccepted: root.saveSgfToFile(selectedFile)
    }

    Dialog {
        id: confirmDeleteNodeDialog
        modal: true
        title: root.trText("deleteNodeTitle")
        standardButtons: Dialog.Yes | Dialog.No
        width: Math.min(420, root.width - 80)
        x: Math.round((root.width - width) / 2)
        y: Math.round((root.height - height) / 2)

        Label {
            text: root.trText("confirmDeleteBranch")
            color: "#17212a"
            wrapMode: Text.WordWrap
            width: parent.width
        }

        onAccepted: {
            root.deleteCurrentNode(true)
            inputLayer.forceActiveFocus()
        }

        onRejected: inputLayer.forceActiveFocus()
    }

    readonly property int minBoardSize: 1
    readonly property int maxBoardSize: 19
    readonly property int defaultBoardSize: 7
    property int boardSize: defaultBoardSize
    property real spacing: 100
    property real extent: (boardSize - 1) * spacing
    property real halfExtent: extent / 2
    readonly property bool compactLayout: width < 1500 || height < 820
    readonly property real commandToolbarHeight: compactLayout ? 34 : 38
    readonly property real panelMargin: compactLayout ? 10 : 18
    readonly property real panelGap: compactLayout ? 8 : 14
    readonly property real panelInnerMargin: compactLayout ? 10 : 14
    readonly property real topContentMargin: panelMargin
    readonly property real bottomContentMargin: panelMargin + commandToolbarHeight + panelGap
    readonly property real infoPanelWidth: compactLayout ? 260 : 314
    readonly property real axisGizmoPanelSize: compactLayout ? 142 : 174
    readonly property real controlPanelWidth: compactLayout ? 270 : 300
    readonly property real branchPanelWidth: compactLayout ? 180 : 240
    readonly property real visualPanelHeight: compactLayout
                                             ? Math.max(210, Math.min(312, height * 0.38))
                                             : 336
    readonly property int minimumTreeCanvasWidth: compactLayout ? 164 : 220
    readonly property int minimumTreeCanvasHeight: compactLayout ? 210 : 260
    readonly property real boardStageLeftReserve: panelMargin + Math.max(infoPanelWidth, axisGizmoPanelSize)
    readonly property real boardStageRightReserve: panelMargin + branchPanelWidth + panelGap + controlPanelWidth
    readonly property real boardStageCenterX: boardStageLeftReserve
                                                + (width - boardStageLeftReserve - boardStageRightReserve) / 2
    readonly property real boardViewOffsetX: boardStageCenterX - width / 2
    readonly property var commandToolbarItems: [
        { "type": "button", "action": "candidates", "zh": "选点列表", "en": "Candidates", "width": 76 },
        { "type": "button", "action": "refresh", "zh": "刷新", "en": "Refresh", "width": 52 },
        { "type": "button", "action": "setMainBranch", "zh": "设为主分支", "en": "Set main", "width": 90 },
        { "type": "button", "action": "clearBoard", "zh": "清空棋盘", "en": "Clear board", "width": 76 },
        { "type": "button", "action": "delete", "zh": "删除", "en": "Delete", "width": 52 },
        { "type": "button", "action": "firstMove", "zh": "|<", "en": "|<", "width": 40 },
        { "type": "button", "action": "back10", "zh": "<<", "en": "<<", "width": 40 },
        { "type": "button", "action": "back1", "zh": "<", "en": "<", "width": 38 },
        { "type": "moveInput", "width": 56 },
        { "type": "button", "action": "forward1", "zh": ">", "en": ">", "width": 38 },
        { "type": "button", "action": "forward10", "zh": ">>", "en": ">>", "width": 40 },
        { "type": "button", "action": "lastMove", "zh": ">|", "en": ">|", "width": 40 }
    ]

    onCompactLayoutChanged: rebuildTreeLayout()

    property var points: []
    property var rods: []
    property var mainAxisLabels: []
    property var stones: ({})
    property var gameNodes: []
    property var treeNodes: []
    property var treeEdges: []
    property int treeCanvasWidth: 220
    property int treeCanvasHeight: 260
    property int currentNodeId: 0
    property int nextNodeId: 1
    property int boardRevision: 0
    property int treeRevision: 0
    property int currentPlayer: 1
    property int stoneCount: 0

    property string hoverKey: ""
    property int hoverX: -1
    property int hoverY: -1
    property int hoverZ: -1
    property string statusMode: "turn"
    property string statusMessage: ""
    property int statusX: -1
    property int statusY: -1
    property int statusZ: -1

    property real cameraYaw: 42
    property real cameraPitch: 28
    property real cameraDistance: 560
    property vector3d cameraTarget: Qt.vector3d(0, 0, 0)
    readonly property real quick3DPrimitiveDiameter: 100
    readonly property real gridPointSphereScale: 0.25
    readonly property real defaultStoneModelScale: 0.70
    readonly property real minStoneModelScale: 0.30
    readonly property real defaultStoneScale: defaultStoneModelScale * quick3DPrimitiveDiameter / spacing
    readonly property real minStoneScale: minStoneModelScale * quick3DPrimitiveDiameter / spacing
    readonly property real defaultGridOpacity: 0.25
    readonly property real selectionSphereScale: gridPointSphereScale
    readonly property real defaultHiddenLayerTransparency: 0.86
    readonly property bool defaultHideGridLines: false
    readonly property bool defaultHideGridPoints: true
    readonly property bool defaultStoneLightingEnabled: true
    readonly property bool defaultLightFollowsCamera: true
    readonly property int moveNumberModeAll: 0
    readonly property int moveNumberModeLastOnly: 1
    readonly property int moveNumberModeHidden: 2
    readonly property int defaultMoveNumberDisplayMode: moveNumberModeAll
    property real stoneScale: defaultStoneScale
    property real gridOpacity: defaultGridOpacity
    property real hiddenLayerTransparency: defaultHiddenLayerTransparency
    property bool hideGridLines: defaultHideGridLines
    property bool hideGridPoints: defaultHideGridPoints
    property bool stoneLightingEnabled: defaultStoneLightingEnabled
    property bool lightFollowsCamera: defaultLightFollowsCamera
    property int moveNumberDisplayMode: defaultMoveNumberDisplayMode
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

    function trText(key) {
        language
        var table = translations[language] || translations.zh
        return table[key] || key
    }

    function windowTitleText() {
        return trText("windowTitle") + " " + boardSize + "x" + boardSize + "x" + boardSize
    }

    function keyFor(x, y, z) {
        return x + "," + y + "," + z
    }

    function pointPosition(x, y, z) {
        var center = (boardSize - 1) / 2
        return Qt.vector3d((x - center) * spacing, (y - center) * spacing, (z - center) * spacing)
    }

    function hiddenLayerOpacity() {
        return clamp(1 - hiddenLayerTransparency, 0, 1)
    }

    function resetVisualSettings() {
        stoneScale = defaultStoneScale
        gridOpacity = defaultGridOpacity
        hiddenLayerTransparency = defaultHiddenLayerTransparency
        hideGridLines = defaultHideGridLines
        hideGridPoints = defaultHideGridPoints
        stoneLightingEnabled = defaultStoneLightingEnabled
        lightFollowsCamera = defaultLightFollowsCamera
        moveNumberDisplayMode = defaultMoveNumberDisplayMode
    }

    function rebuildBoardGeometry() {
        points = buildPoints()
        rods = buildRods()
        mainAxisLabels = buildMainAxisLabels()
    }

    function setBoardSize(size) {
        var nextSize = Math.round(clamp(size, minBoardSize, maxBoardSize))
        if (nextSize === boardSize)
            return

        boardSize = nextSize
        resetClipCounts()
        clearHover()
        resetGameTree()
        rebuildBoardGeometry()
        resetCamera()
    }

    function hasActiveClip() {
        clipRevision
        return clipPosX + clipNegX + clipPosY + clipNegY + clipPosZ + clipNegZ > 0
    }

    function gridRodHighlighted(axis, x1, y1, z1) {
        hoverKey
        if (hoverKey === "")
            return false
        if (axis === 0)
            return y1 === hoverY && z1 === hoverZ
        if (axis === 1)
            return x1 === hoverX && z1 === hoverZ
        return x1 === hoverX && y1 === hoverY
    }

    function gridRodColor(axis, x1, y1, z1) {
        if (gridRodHighlighted(axis, x1, y1, z1))
            return "#2fb97f"
        if (axis === 0)
            return "#3e2729"
        if (axis === 1)
            return "#29392c"
        return "#283544"
    }

    function gridRodOpacity(axis, x1, y1, z1, x2, y2, z2) {
        if (hideGridLines)
            return 0
        var baseOpacity = gridRodHighlighted(axis, x1, y1, z1) ? Math.max(0.9, gridOpacity) : gridOpacity
        var clipped = isClipped(x1, y1, z1) || isClipped(x2, y2, z2)
        return clipped ? baseOpacity * hiddenLayerOpacity() : baseOpacity
    }

    function emptyPointOpacity(clipped, hovered) {
        if (hovered)
            return 0.42
        if (hideGridPoints)
            return 0
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

    function stoneDataAt(x, y, z) {
        boardRevision
        var value = stones[keyFor(x, y, z)]
        return value === undefined ? null : value
    }

    function stoneAt(x, y, z) {
        var value = stoneDataAt(x, y, z)
        if (!value)
            return 0
        return value.player === undefined ? value : value.player
    }

    function stoneMoveNumberAt(x, y, z) {
        var value = stoneDataAt(x, y, z)
        return value && value.moveNumber !== undefined ? value.moveNumber : 0
    }

    function isLastMoveAt(x, y, z) {
        boardRevision
        var node = currentNode()
        return !!node && node.key === keyFor(x, y, z)
    }

    function nodeById(id) {
        return gameNodes[id] === undefined ? null : gameNodes[id]
    }

    function currentNode() {
        return nodeById(currentNodeId)
    }

    function nodePath(id) {
        var path = []
        var node = nodeById(id)
        while (node && node.parent >= 0) {
            path.unshift(node)
            node = nodeById(node.parent)
        }
        return path
    }

    function rebuildPositionFromNode(id) {
        var path = nodePath(id)
        var nextStones = ({})
        for (var i = 0; i < path.length; ++i) {
            nextStones[path[i].key] = {
                "player": path[i].player,
                "moveNumber": path[i].moveNumber,
                "nodeId": path[i].id
            }
        }

        stones = nextStones
        stoneCount = path.length
        currentPlayer = stoneCount % 2 === 0 ? 1 : 2
        boardRevision += 1
        statusMode = "turn"
    }

    function resetGameTree() {
        stones = ({})
        gameNodes = [{ "id": 0, "parent": -1, "children": [], "x": -1, "y": -1, "z": -1,
                       "key": "", "player": 0, "moveNumber": 0 }]
        currentNodeId = 0
        nextNodeId = 1
        stoneCount = 0
        currentPlayer = 1
        boardRevision += 1
        statusMode = "turn"
        rebuildTreeLayout()
    }

    function currentNodeText() {
        var node = currentNode()
        if (!node || node.id === 0)
            return trText("rootMove")
        return coordinateText(node.x, node.y, node.z) + " · " + trText("moveNumber") + " " + node.moveNumber
    }

    function playerName(player) {
        return player === 1 ? trText("black") : trText("white")
    }

    function statusLabelText() {
        if (statusMode === "message")
            return statusMessage
        if (statusMode === "occupied")
            return trText("occupied") + ": " + coordinateText(statusX, statusY, statusZ)
        return language === "zh"
               ? playerName(currentPlayer) + trText("toMove")
               : playerName(currentPlayer) + " " + trText("toMove")
    }

    function placeStone(x, y, z) {
        var key = keyFor(x, y, z)
        if (stones[key] !== undefined) {
            statusMode = "occupied"
            statusX = x
            statusY = y
            statusZ = z
            return
        }

        var parent = currentNode()
        if (!parent)
            return

        for (var i = 0; i < parent.children.length; ++i) {
            var child = nodeById(parent.children[i])
            if (child && child.key === key) {
                gotoNode(child.id)
                return
            }
        }

        var node = {
            "id": nextNodeId,
            "parent": currentNodeId,
            "children": [],
            "x": x,
            "y": y,
            "z": z,
            "key": key,
            "player": currentPlayer,
            "moveNumber": parent.moveNumber + 1
        }

        parent.children.push(node.id)
        gameNodes.push(node)
        gameNodes = gameNodes.slice()
        nextNodeId += 1
        currentNodeId = node.id
        rebuildPositionFromNode(currentNodeId)
        rebuildTreeLayout()
    }

    function undoMove() {
        var node = currentNode()
        if (!node || node.parent < 0)
            return

        gotoNode(node.parent)
    }

    function collectSubtreeIds(id, map) {
        var node = nodeById(id)
        if (!node)
            return

        map[id] = true
        var children = node.children || []
        for (var i = 0; i < children.length; ++i)
            collectSubtreeIds(children[i], map)
    }

    function requestDeleteCurrentNode() {
        var node = currentNode()
        if (!node || node.parent < 0)
            return

        if ((node.children || []).length > 0) {
            confirmDeleteNodeDialog.open()
            return
        }

        deleteCurrentNode(true)
    }

    function deleteCurrentNode(confirmed) {
        var node = currentNode()
        if (!node || node.parent < 0)
            return

        if (!confirmed && (node.children || []).length > 0) {
            confirmDeleteNodeDialog.open()
            return
        }

        var parent = nodeById(node.parent)
        if (!parent)
            return

        var removeMap = ({})
        collectSubtreeIds(node.id, removeMap)

        var nextNodes = gameNodes.slice()
        for (var id in removeMap)
            nextNodes[Number(id)] = null

        var nextChildren = []
        for (var i = 0; i < parent.children.length; ++i) {
            if (parent.children[i] !== node.id)
                nextChildren.push(parent.children[i])
        }
        parent.children = nextChildren

        gameNodes = nextNodes
        currentNodeId = parent.id
        clearHover()
        rebuildPositionFromNode(currentNodeId)
        rebuildTreeLayout()
    }

    function clearBoard() {
        resetGameTree()
    }

    function gotoNode(id) {
        if (!nodeById(id))
            return
        currentNodeId = id
        rebuildPositionFromNode(currentNodeId)
        rebuildTreeLayout()
    }

    function hasAnyMoves() {
        var rootNode = nodeById(0)
        return !!rootNode && (rootNode.children || []).length > 0
    }

    function currentMoveNumberValue() {
        var node = currentNode()
        return node ? node.moveNumber : 0
    }

    function currentMoveNumberText() {
        return String(currentMoveNumberValue())
    }

    function mainChildOf(node) {
        var children = node ? (node.children || []) : []
        return children.length > 0 ? nodeById(children[0]) : null
    }

    function gotoMoveNumber(value) {
        var target = Math.round(clamp(isNaN(value) ? 0 : value, 0, boardSize * boardSize * boardSize))
        var node = currentNode() || nodeById(0)
        if (!node)
            return

        while (node && node.moveNumber > target)
            node = nodeById(node.parent)

        while (node && node.moveNumber < target) {
            var child = mainChildOf(node)
            if (!child)
                break
            node = child
        }

        if (node)
            gotoNode(node.id)
    }

    function gotoFirstMove() {
        var child = mainChildOf(nodeById(0))
        gotoNode(child ? child.id : 0)
    }

    function gotoLastMove() {
        var node = currentNode() || nodeById(0)
        while (node) {
            var child = mainChildOf(node)
            if (!child)
                break
            node = child
        }
        if (node)
            gotoNode(node.id)
    }

    function stepMove(delta) {
        gotoMoveNumber(currentMoveNumberValue() + delta)
    }

    function promoteCurrentNodeToMainBranch() {
        var path = nodePath(currentNodeId)
        var changed = false

        for (var i = 0; i < path.length; ++i) {
            var child = path[i]
            var parent = nodeById(child.parent)
            if (!parent)
                continue

            var children = (parent.children || []).slice()
            var index = children.indexOf(child.id)
            if (index > 0) {
                children.splice(index, 1)
                children.unshift(child.id)
                parent.children = children
                changed = true
            }
        }

        if (changed) {
            gameNodes = gameNodes.slice()
            rebuildTreeLayout()
        }
    }

    function toolbarActionEnabled(action) {
        if (action === "candidates" || action === "refresh")
            return false
        if (action === "setMainBranch" || action === "delete")
            return currentNodeId !== 0
        if (action === "clearBoard")
            return hasAnyMoves()
        if (action === "firstMove")
            return hasAnyMoves() && currentMoveNumberValue() !== 1
        if (action === "back10" || action === "back1")
            return currentMoveNumberValue() > 0
        if (action === "forward1" || action === "forward10" || action === "lastMove")
            return !!mainChildOf(currentNode())
        return true
    }

    function runToolbarAction(action) {
        if (action === "setMainBranch")
            promoteCurrentNodeToMainBranch()
        else if (action === "clearBoard")
            clearBoard()
        else if (action === "delete")
            deleteCurrentNode(true)
        else if (action === "firstMove")
            gotoFirstMove()
        else if (action === "back10")
            stepMove(-10)
        else if (action === "back1")
            stepMove(-1)
        else if (action === "forward1")
            stepMove(1)
        else if (action === "forward10")
            stepMove(10)
        else if (action === "lastMove")
            gotoLastMove()

        inputLayer.forceActiveFocus()
    }

    function moveNumberDisplayText() {
        if (moveNumberDisplayMode === moveNumberModeLastOnly)
            return trText("moveNumberLastOnly")
        if (moveNumberDisplayMode === moveNumberModeHidden)
            return trText("moveNumberHidden")
        return trText("moveNumberAll")
    }

    function cycleMoveNumberDisplayMode() {
        moveNumberDisplayMode = (moveNumberDisplayMode + 1) % 3
    }

    function stoneNumberVisible(moveNumber, lastMove) {
        if (moveNumber <= 0 || moveNumberDisplayMode === moveNumberModeHidden)
            return false
        if (moveNumberDisplayMode === moveNumberModeLastOnly)
            return lastMove
        return true
    }

    function stoneOverlayVisible(moveNumber, lastMove) {
        return lastMove || stoneNumberVisible(moveNumber, lastMove)
    }

    function stoneNumberColor(player, lastMove) {
        if (lastMove)
            return "#e3342f"
        return player === 1 ? "#f6fbff" : "#11161b"
    }

    function cameraUpVector() {
        cameraYaw
        cameraPitch
        var yaw = cameraYaw * Math.PI / 180
        var pitch = cameraPitch * Math.PI / 180
        return Qt.vector3d(-Math.sin(pitch) * Math.sin(yaw),
                           Math.cos(pitch),
                           -Math.sin(pitch) * Math.cos(yaw))
    }

    function cameraBackVector() {
        cameraYaw
        cameraPitch
        var yaw = cameraYaw * Math.PI / 180
        var pitch = cameraPitch * Math.PI / 180
        var cp = Math.cos(pitch)
        return Qt.vector3d(Math.sin(yaw) * cp,
                           Math.sin(pitch),
                           Math.cos(yaw) * cp)
    }

    function cameraRightVector() {
        cameraYaw
        var yaw = cameraYaw * Math.PI / 180
        return Qt.vector3d(Math.cos(yaw), 0, -Math.sin(yaw))
    }

    function dotVector(a, b) {
        return a.x * b.x + a.y * b.y + a.z * b.z
    }

    function crossVector(a, b) {
        return Qt.vector3d(a.y * b.z - a.z * b.y,
                           a.z * b.x - a.x * b.z,
                           a.x * b.y - a.y * b.x)
    }

    function normalizedVector(v, fallback) {
        var length = Math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
        if (length < 0.0001)
            return fallback
        return Qt.vector3d(v.x / length, v.y / length, v.z / length)
    }

    function quaternionFromBasis(xAxis, yAxis, zAxis) {
        var m00 = xAxis.x
        var m01 = yAxis.x
        var m02 = zAxis.x
        var m10 = xAxis.y
        var m11 = yAxis.y
        var m12 = zAxis.y
        var m20 = xAxis.z
        var m21 = yAxis.z
        var m22 = zAxis.z
        var trace = m00 + m11 + m22
        var s = 0

        if (trace > 0) {
            s = Math.sqrt(trace + 1) * 2
            return Qt.quaternion(0.25 * s,
                                 (m21 - m12) / s,
                                 (m02 - m20) / s,
                                 (m10 - m01) / s)
        }

        if (m00 > m11 && m00 > m22) {
            s = Math.sqrt(1 + m00 - m11 - m22) * 2
            return Qt.quaternion((m21 - m12) / s,
                                 0.25 * s,
                                 (m01 + m10) / s,
                                 (m02 + m20) / s)
        }

        if (m11 > m22) {
            s = Math.sqrt(1 + m11 - m00 - m22) * 2
            return Qt.quaternion((m02 - m20) / s,
                                 (m01 + m10) / s,
                                 0.25 * s,
                                 (m12 + m21) / s)
        }

        s = Math.sqrt(1 + m22 - m00 - m11) * 2
        return Qt.quaternion((m10 - m01) / s,
                             (m02 + m20) / s,
                             (m12 + m21) / s,
                             0.25 * s)
    }

    function stoneBillboardPosition(basePosition) {
        cameraYaw
        cameraPitch
        cameraDistance
        cameraTarget
        var dx = boardCamera.position.x - basePosition.x
        var dy = boardCamera.position.y - basePosition.y
        var dz = boardCamera.position.z - basePosition.z
        var length = Math.sqrt(dx * dx + dy * dy + dz * dz)
        var direction = length < 0.001
                        ? cameraBackVector()
                        : Qt.vector3d(dx / length, dy / length, dz / length)
        var radius = quick3DPrimitiveDiameter * stoneModelScale() * 0.5 * 1.05
        return Qt.vector3d(basePosition.x + direction.x * radius,
                           basePosition.y + direction.y * radius,
                           basePosition.z + direction.z * radius)
    }

    function stoneBillboardRotation(labelPosition) {
        cameraYaw
        cameraPitch
        cameraDistance
        cameraTarget
        var normal = normalizedVector(Qt.vector3d(boardCamera.position.x - labelPosition.x,
                                                  boardCamera.position.y - labelPosition.y,
                                                  boardCamera.position.z - labelPosition.z),
                                      cameraBackVector())
        var cameraUp = cameraUpVector()
        var cameraRight = cameraRightVector()
        var upProjection = Qt.vector3d(cameraUp.x - normal.x * dotVector(cameraUp, normal),
                                       cameraUp.y - normal.y * dotVector(cameraUp, normal),
                                       cameraUp.z - normal.z * dotVector(cameraUp, normal))
        var rightProjection = Qt.vector3d(cameraRight.x - normal.x * dotVector(cameraRight, normal),
                                          cameraRight.y - normal.y * dotVector(cameraRight, normal),
                                          cameraRight.z - normal.z * dotVector(cameraRight, normal))
        var up = normalizedVector(upProjection, normalizedVector(crossVector(normal, cameraRight), cameraUp))
        var right = normalizedVector(crossVector(up, normal), normalizedVector(rightProjection, cameraRight))
        up = normalizedVector(crossVector(normal, right), up)
        return quaternionFromBasis(right, up, normal)
    }

    function stoneBillboardScale() {
        return stoneModelScale() * 0.78
    }

    function stoneModelScale() {
        return stoneScale * spacing / quick3DPrimitiveDiameter
    }

    function scenePointLightPosition() {
        cameraYaw
        cameraPitch
        cameraDistance
        cameraTarget
        lightFollowsCamera

        if (!lightFollowsCamera)
            return Qt.vector3d(-360, 460, -420)

        var back = cameraBackVector()
        var up = cameraUpVector()
        var right = cameraRightVector()
        var distance = Math.max(280, cameraDistance * 0.46)
        return Qt.vector3d(cameraTarget.x + back.x * distance + up.x * 220 - right.x * 160,
                           cameraTarget.y + back.y * distance + up.y * 220 - right.y * 160,
                           cameraTarget.z + back.z * distance + up.z * 220 - right.z * 160)
    }

    function sceneDirectionalLightPitch() {
        cameraPitch
        lightFollowsCamera
        return lightFollowsCamera ? -cameraPitch - 20 : -46
    }

    function sceneDirectionalLightYaw() {
        cameraYaw
        lightFollowsCamera
        return lightFollowsCamera ? cameraYaw + 22 : 34
    }

    function xCoordinateText(x) {
        return String.fromCharCode("A".charCodeAt(0) + x)
    }

    function yCoordinateText(y) {
        return String.fromCharCode("a".charCodeAt(0) + y)
    }

    function zCoordinateText(z) {
        return String(z + 1)
    }

    function coordinateText(x, y, z) {
        return xCoordinateText(x) + yCoordinateText(y) + zCoordinateText(z)
    }

    function sgfEscape(value) {
        return String(value)
            .replace(/\\/g, "\\\\")
            .replace(/\]/g, "\\]")
            .replace(/\r?\n/g, "\\n")
    }

    function sgfCoordinateText(x, y, z) {
        var base = "a".charCodeAt(0)
        return String.fromCharCode(base + x)
               + String.fromCharCode(base + y)
               + String.fromCharCode(base + z)
    }

    function sgfMoveNode(node) {
        var color = node.player === 1 ? "B" : "W"
        return color + "[" + sgfCoordinateText(node.x, node.y, node.z) + "]"
               + "MN[" + node.moveNumber + "]"
    }

    function sgfSubtree(id) {
        var node = nodeById(id)
        if (!node)
            return ""

        var text = "(;" + sgfMoveNode(node)
        var children = node.children || []
        for (var i = 0; i < children.length; ++i)
            text += sgfSubtree(children[i])
        return text + ")"
    }

    function buildSgf() {
        var description = "Lizzie3D 3D Gomoku. Coordinates use SGF letters: aaa = (0,0,0), cde = (2,3,4)."
        var text = "(;FF[4]GM[4]CA[UTF-8]AP[Lizzie3D]SZ["
                   + boardSize + ":" + boardSize + ":" + boardSize + "]"
                   + "C[" + sgfEscape(description) + "]"
        var rootNode = nodeById(0)
        var children = rootNode ? (rootNode.children || []) : []
        for (var i = 0; i < children.length; ++i)
            text += sgfSubtree(children[i])
        return text + ")\n"
    }

    function openSaveSgfDialog() {
        saveSgfDialog.currentFile = "lizzie3d-" + boardSize + "x" + boardSize + "x" + boardSize + ".sgf"
        saveSgfDialog.open()
    }

    function saveSgfToFile(url) {
        if (fileIo.writeTextFile(url, buildSgf())) {
            statusMode = "message"
            statusMessage = trText("sgfSaved") + ": " + url
        } else {
            statusMode = "message"
            statusMessage = trText("sgfSaveFailed") + ": " + fileIo.lastError
        }
        inputLayer.forceActiveFocus()
    }

    function mainAxisOrigin() {
        return pointPosition(-1, -1, -1)
    }

    function mainAxisLength() {
        return spacing * (boardSize + 1.15)
    }

    function buildMainAxisLabels() {
        var labels = []
        for (var i = 0; i < boardSize; ++i) {
            labels.push({ "label": xCoordinateText(i), "x": i, "y": -1.34, "z": -1, "color": "#d84a43", "size": 0.48, "fontSize": 144 })
            labels.push({ "label": yCoordinateText(i), "x": -1.34, "y": i, "z": -1, "color": "#39a66a", "size": 0.48, "fontSize": 144 })
            labels.push({ "label": zCoordinateText(i), "x": -1.34, "y": -1, "z": i, "color": "#3d73d8", "size": 0.48, "fontSize": 144 })
        }

        var axisEnd = boardSize + 0.42
        labels.push({ "label": "X", "x": axisEnd, "y": -1, "z": -1, "color": "#d84a43", "size": 0.68, "fontSize": 164 })
        labels.push({ "label": "Y", "x": -1, "y": axisEnd, "z": -1, "color": "#39a66a", "size": 0.68, "fontSize": 164 })
        labels.push({ "label": "Z", "x": -1, "y": -1, "z": axisEnd, "color": "#3d73d8", "size": 0.68, "fontSize": 164 })
        return labels
    }

    function rebuildTreeLayout() {
        var rowHeight = 38
        var columnWidth = 42
        var margin = compactLayout ? 32 : 36
        var radius = 12
        var laneById = ({})
        var nextLane = 0

        function assignLane(id) {
            var node = nodeById(id)
            if (!node)
                return 0

            var children = node.children || []
            if (children.length === 0) {
                laneById[id] = nextLane
                nextLane += 1
                return laneById[id]
            }

            var firstLane = -1
            for (var i = 0; i < children.length; ++i) {
                var childLane = assignLane(children[i])
                if (firstLane < 0)
                    firstLane = childLane
            }
            laneById[id] = firstLane < 0 ? 0 : firstLane
            return laneById[id]
        }

        assignLane(0)
        if (nextLane === 0)
            nextLane = 1

        var currentPathMap = ({})
        currentPathMap[0] = true
        var currentPath = nodePath(currentNodeId)
        for (var p = 0; p < currentPath.length; ++p)
            currentPathMap[currentPath[p].id] = true

        var nodes = []
        var nodeMap = ({})
        var maxMove = 0
        for (var n = 0; n < gameNodes.length; ++n) {
            var node = gameNodes[n]
            if (!node)
                continue

            var lane = laneById[node.id] === undefined ? 0 : laneById[node.id]
            var treeNode = {
                "id": node.id,
                "parent": node.parent,
                "x": margin + lane * columnWidth,
                "y": margin + node.moveNumber * rowHeight,
                "radius": radius,
                "player": node.player,
                "moveNumber": node.moveNumber,
                "coordinate": node.id === 0 ? trText("rootMove") : coordinateText(node.x, node.y, node.z),
                "current": node.id === currentNodeId,
                "currentPath": currentPathMap[node.id] === true,
                "label": node.moveNumber === 0 ? "0" : String(node.moveNumber)
            }
            nodes.push(treeNode)
            nodeMap[node.id] = treeNode
            maxMove = Math.max(maxMove, node.moveNumber)
        }

        var edges = []
        for (var e = 0; e < nodes.length; ++e) {
            var child = nodes[e]
            var parent = nodeMap[child.parent]
            if (parent) {
                edges.push({ "x1": parent.x, "y1": parent.y,
                             "x2": child.x, "y2": child.y,
                             "current": child.currentPath })
            }
        }

        treeNodes = nodes
        treeEdges = edges
        treeCanvasWidth = Math.max(minimumTreeCanvasWidth, margin * 2 + Math.max(0, nextLane - 1) * columnWidth + radius * 2)
        treeCanvasHeight = Math.max(minimumTreeCanvasHeight, margin * 2 + maxMove * rowHeight + radius * 2)
        treeRevision += 1
    }

    function treeNodeAt(x, y) {
        for (var i = treeNodes.length - 1; i >= 0; --i) {
            var node = treeNodes[i]
            var dx = x - node.x
            var dy = y - node.y
            if (Math.sqrt(dx * dx + dy * dy) <= node.radius + 5)
                return node.id
        }
        return -1
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
        axisView.width
        axisView.height

        var size = Math.min(axisView.width, axisView.height)
        if (size <= 0)
            return Qt.point(-1000, -1000)

        return projectedAxisPoint(dx, dy, dz, axisView.width / 2, Math.max(32, size * 0.36))
    }

    function hoverLabelPoint() {
        cameraYaw
        cameraPitch
        cameraDistance
        cameraTarget
        hoverKey
        if (hoverKey === "" || !boardView.camera)
            return Qt.point(-1000, -1000)

        var hoverPoint = pointPosition(hoverX, hoverY, hoverZ)
        var mapped = boardView.mapFrom3DScene(Qt.vector3d(hoverPoint.x,
                                                         hoverPoint.y + spacing * 0.42,
                                                         hoverPoint.z))
        return Qt.point(boardView.x + mapped.x, boardView.y + mapped.y)
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

    function defaultCameraDistance() {
        return Math.max(560, extent * 1.28)
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
        cameraDistance = defaultCameraDistance()
        cameraTarget = Qt.vector3d(0, 0, 0)
        refreshCamera()
    }

    function moveTarget(depthForward, screenRight, screenUp, amountOverride) {
        var yaw = cameraYaw * Math.PI / 180
        var pitch = cameraPitch * Math.PI / 180
        var cp = Math.cos(pitch)
        var viewForwardX = -Math.sin(yaw) * cp
        var viewForwardY = -Math.sin(pitch)
        var viewForwardZ = -Math.cos(yaw) * cp
        var rightX = Math.cos(yaw)
        var rightZ = -Math.sin(yaw)
        var upX = -Math.sin(pitch) * Math.sin(yaw)
        var upY = Math.cos(pitch)
        var upZ = -Math.sin(pitch) * Math.cos(yaw)
        var amount = amountOverride === undefined ? 36 : amountOverride

        cameraTarget = Qt.vector3d(
            cameraTarget.x + amount * (depthForward * viewForwardX + screenRight * rightX + screenUp * upX),
            cameraTarget.y + amount * (depthForward * viewForwardY + screenUp * upY),
            cameraTarget.z + amount * (depthForward * viewForwardZ + screenRight * rightZ + screenUp * upZ))
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
        return model && model.selectionPoint === true
    }

    function pointFromMouse(x, y) {
        var result = boardView.pick(x, y)
        var hit = result.objectHit
        if (!modelIsGridPoint(hit) || isClipped(hit.gx, hit.gy, hit.gz))
            return null

        return { "x": hit.gx, "y": hit.gy, "z": hit.gz }
    }

    function clearHover() {
        hoverX = -1
        hoverY = -1
        hoverZ = -1
        hoverKey = ""
    }

    function updateHover(x, y) {
        var point = pointFromMouse(x, y)
        if (point) {
            hoverX = point.x
            hoverY = point.y
            hoverZ = point.z
            hoverKey = keyFor(hoverX, hoverY, hoverZ)
        } else {
            clearHover()
        }
    }

    function placeFromMouse(x, y) {
        var point = pointFromMouse(x, y)
        if (point)
            placeStone(point.x, point.y, point.z)
    }

    onClipRevisionChanged: {
        if (hoverKey !== "" && isClipped(hoverX, hoverY, hoverZ))
            clearHover()
    }

    Component.onCompleted: {
        resetGameTree()
        rebuildBoardGeometry()
        resetCamera()
    }

    Rectangle {
        id: commandToolbar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: root.commandToolbarHeight
        z: 40
        clip: true
        color: "#edf2f5"
        border.color: "#b8c5cc"

        Flickable {
            id: commandToolbarFlick
            anchors.fill: parent
            anchors.leftMargin: 6
            anchors.rightMargin: 6
            contentWidth: commandToolbarRow.implicitWidth
            contentHeight: height
            interactive: contentWidth > width
            flickableDirection: Flickable.HorizontalFlick
            boundsBehavior: Flickable.StopAtBounds

            Row {
                id: commandToolbarRow
                height: commandToolbarFlick.height
                spacing: root.compactLayout ? 3 : 4

                Repeater {
                    model: root.commandToolbarItems

                    delegate: Item {
                        width: Math.round((modelData.width || 52) * (root.compactLayout ? 0.94 : 1.0))
                        height: commandToolbarRow.height

                        Button {
                            visible: modelData.type === "button"
                            enabled: root.toolbarActionEnabled(modelData.action || "")
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height - (root.compactLayout ? 6 : 8)
                            text: root.language === "zh" ? modelData.zh : modelData.en
                            font.pixelSize: root.compactLayout ? 11 : 12
                            leftPadding: 4
                            rightPadding: 4
                            topPadding: 2
                            bottomPadding: 2
                            onClicked: root.runToolbarAction(modelData.action || "")
                        }

                        TextField {
                            id: moveNumberInput
                            visible: modelData.type === "moveInput"
                            property bool committingMoveNumber: false
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height - (root.compactLayout ? 6 : 8)
                            selectByMouse: true
                            horizontalAlignment: TextInput.AlignHCenter
                            verticalAlignment: TextInput.AlignVCenter
                            font.pixelSize: root.compactLayout ? 11 : 12
                            validator: IntValidator {
                                bottom: 0
                                top: root.boardSize * root.boardSize * root.boardSize
                            }
                            function commitMoveNumber() {
                                if (committingMoveNumber)
                                    return

                                committingMoveNumber = true
                                root.gotoMoveNumber(parseInt(text, 10))
                                text = root.currentMoveNumberText()
                                committingMoveNumber = false
                            }
                            Component.onCompleted: text = root.currentMoveNumberText()
                            onActiveFocusChanged: {
                                if (activeFocus)
                                    selectAll()
                            }
                            onAccepted: {
                                commitMoveNumber()
                                inputLayer.forceActiveFocus()
                            }
                            onEditingFinished: commitMoveNumber()

                            Connections {
                                target: root

                                function onCurrentNodeIdChanged() {
                                    if (!moveNumberInput.activeFocus)
                                        moveNumberInput.text = root.currentMoveNumberText()
                                }

                                function onBoardRevisionChanged() {
                                    if (!moveNumberInput.activeFocus)
                                        moveNumberInput.text = root.currentMoveNumberText()
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    View3D {
        id: boardView
        x: root.boardViewOffsetX
        y: 0
        width: parent.width
        height: parent.height - root.commandToolbarHeight - root.panelGap
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
            eulerRotation.x: root.sceneDirectionalLightPitch()
            eulerRotation.y: root.sceneDirectionalLightYaw()
            brightness: 0.85
            castsShadow: false
        }

        PointLight {
            position: root.scenePointLightPosition()
            brightness: 80
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
                    opacity: root.gridRodOpacity(axis, x1, y1, z1, x2, y2, z2)
                    position: root.pointPosition(gx, gy, gz)
                    scale: axis === 0
                           ? Qt.vector3d(root.spacing / 100, 0.012, 0.012)
                           : axis === 1
                             ? Qt.vector3d(0.012, root.spacing / 100, 0.012)
                             : Qt.vector3d(0.012, 0.012, root.spacing / 100)
                    materials: PrincipledMaterial {
                        baseColor: root.gridRodColor(axis, x1, y1, z1)
                        alphaMode: PrincipledMaterial.Blend
                        roughness: 0.72
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
                    readonly property vector3d origin: root.mainAxisOrigin()
                    readonly property real axisLength: root.mainAxisLength()
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
                    readonly property vector3d origin: root.mainAxisOrigin()
                    readonly property real axisLength: root.mainAxisLength()

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
                model: root.mainAxisLabels

                delegate: Model {
                    readonly property vector3d labelPosition: root.pointPosition(modelData.x, modelData.y, modelData.z)

                    source: "#Rectangle"
                    pickable: false
                    position: labelPosition
                    rotation: root.stoneBillboardRotation(labelPosition)
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
                model: root.points
                delegate: Model {
                    readonly property int gx: modelData.x
                    readonly property int gy: modelData.y
                    readonly property int gz: modelData.z
                    readonly property bool selectionPoint: true
                    property bool clipped: root.isClipped(gx, gy, gz)

                    source: "#Sphere"
                    pickable: !clipped
                    visible: !clipped
                    position: modelData.position
                    scale: Qt.vector3d(root.selectionSphereScale,
                                       root.selectionSphereScale,
                                       root.selectionSphereScale)
                    opacity: 0.001
                    materials: PrincipledMaterial {
                        lighting: PrincipledMaterial.NoLighting
                        baseColor: "#ffffff"
                        alphaMode: PrincipledMaterial.Blend
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
                    property bool hovered: root.hoverKey === modelData.key
                    readonly property real pointScale: hovered ? root.stoneModelScale() : root.gridPointSphereScale

                    source: "#Sphere"
                    pickable: false
                    visible: occupant === 0
                    position: modelData.position
                    scale: Qt.vector3d(pointScale, pointScale, pointScale)
                    opacity: root.emptyPointOpacity(clipped, hovered)
                    materials: PrincipledMaterial {
                        baseColor: hovered ? "#2fb97f" : "#6e8794"
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
                    pickable: false
                    visible: occupant !== 0
                    position: modelData.position
                    scale: Qt.vector3d(root.stoneModelScale(),
                                       root.stoneModelScale(),
                                       root.stoneModelScale())
                    opacity: clipped ? root.hiddenLayerOpacity() : 1
                    materials: PrincipledMaterial {
                        lighting: root.stoneLightingEnabled
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
                model: root.points
                delegate: Model {
                    readonly property int gx: modelData.x
                    readonly property int gy: modelData.y
                    readonly property int gz: modelData.z
                    property int occupant: root.stoneAt(gx, gy, gz)
                    property int moveNumber: root.stoneMoveNumberAt(gx, gy, gz)
                    property bool lastMove: root.isLastMoveAt(gx, gy, gz)
                    property bool clipped: root.isClipped(gx, gy, gz)
                    readonly property vector3d labelPosition: root.stoneBillboardPosition(modelData.position)
                    readonly property real labelScale: root.stoneBillboardScale()

                    source: "#Rectangle"
                    pickable: false
                    visible: occupant !== 0 && root.stoneOverlayVisible(moveNumber, lastMove)
                    position: labelPosition
                    rotation: root.stoneBillboardRotation(labelPosition)
                    scale: Qt.vector3d(labelScale, labelScale, labelScale)
                    opacity: clipped ? root.hiddenLayerOpacity() : 1
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
                                    visible: root.stoneNumberVisible(moveNumber, lastMove)
                                    anchors.centerIn: parent
                                    width: 108
                                    height: 108
                                    text: moveNumber
                                    color: root.stoneNumberColor(occupant, lastMove)
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

    Rectangle {
        id: hoverCoordinateBadge
        property var screenPoint: root.hoverLabelPoint()

        visible: root.hoverKey !== ""
        x: screenPoint.x - width / 2
        y: screenPoint.y - height - 6
        z: 5
        width: hoverCoordinateText.implicitWidth + 28
        height: 34
        radius: 8
        color: "#eaf8ef"
        border.color: "#2fb97f"
        border.width: 2

        Text {
            id: hoverCoordinateText
            anchors.centerIn: parent
            text: root.hoverKey === "" ? "" : root.coordinateText(root.hoverX, root.hoverY, root.hoverZ)
            color: "#12633e"
            font.pixelSize: 18
            font.bold: true
        }
    }

    Item {
        id: inputLayer
        anchors.fill: boardView
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
                var depthForward = (inputLayer.forwardHeld ? 1 : 0) - (inputLayer.backHeld ? 1 : 0)
                var screenRight = (inputLayer.rightHeld ? 1 : 0) - (inputLayer.leftHeld ? 1 : 0)
                var screenUp = (inputLayer.upHeld ? 1 : 0) - (inputLayer.downHeld ? 1 : 0)
                var length = Math.sqrt(depthForward * depthForward + screenRight * screenRight + screenUp * screenUp)

                if (length > 0) {
                    var step = Math.max(3.6, root.cameraDistance * 0.006)
                    root.moveTarget(depthForward / length, screenRight / length, screenUp / length, step)
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
                inputLayer.upHeld = true
                event.accepted = true
            } else if (event.key === Qt.Key_S) {
                inputLayer.downHeld = true
                event.accepted = true
            } else if (event.key === Qt.Key_A) {
                inputLayer.leftHeld = true
                event.accepted = true
            } else if (event.key === Qt.Key_D) {
                inputLayer.rightHeld = true
                event.accepted = true
            } else if (event.key === Qt.Key_Q) {
                inputLayer.forwardHeld = true
                event.accepted = true
            } else if (event.key === Qt.Key_E) {
                inputLayer.backHeld = true
                event.accepted = true
            } else if (event.key === Qt.Key_X) {
                root.adjustClip(root.frontFacingClipAxis(), -1)
                event.accepted = true
            } else if (event.key === Qt.Key_Z) {
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
                    root.requestDeleteCurrentNode()
                event.accepted = true
            } else if (event.key === Qt.Key_M) {
                if (!event.isAutoRepeat)
                    root.cycleMoveNumberDisplayMode()
                event.accepted = true
            }
        }

        Keys.onReleased: function(event) {
            if (event.key === Qt.Key_W) {
                inputLayer.upHeld = false
                event.accepted = true
            } else if (event.key === Qt.Key_S) {
                inputLayer.downHeld = false
                event.accepted = true
            } else if (event.key === Qt.Key_A) {
                inputLayer.leftHeld = false
                event.accepted = true
            } else if (event.key === Qt.Key_D) {
                inputLayer.rightHeld = false
                event.accepted = true
            } else if (event.key === Qt.Key_Q) {
                inputLayer.forwardHeld = false
                event.accepted = true
            } else if (event.key === Qt.Key_E) {
                inputLayer.backHeld = false
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

            onExited: root.clearHover()

            onWheel: function(wheel) {
                var factor = wheel.angleDelta.y > 0 ? 0.9 : 1.12
                root.cameraDistance = root.clamp(root.cameraDistance * factor, 220, Math.max(1900, root.defaultCameraDistance() * 2.2))
                root.refreshCamera()
                wheel.accepted = true
            }
        }
    }

    Rectangle {
        id: axisGizmoPanel
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: root.panelMargin + root.infoPanelWidth + root.panelGap
        anchors.topMargin: root.topContentMargin
        width: root.axisGizmoPanelSize
        height: root.axisGizmoPanelSize
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

                x: root.clamp(axisView.x + screenPoint.x - width / 2,
                              4,
                              axisGizmoPanel.width - width - 4)
                y: root.clamp(axisView.y + screenPoint.y - height / 2,
                              4,
                              axisGizmoPanel.height - height - (root.compactLayout ? 18 : 22))
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
            text: root.trText("axisHint")
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
        anchors.leftMargin: root.panelMargin
        anchors.topMargin: root.topContentMargin
        width: root.infoPanelWidth
        height: 166
        radius: 8
        color: "#e7eef2"
        border.color: "#bcc9d0"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: root.panelInnerMargin
            spacing: root.compactLayout ? 5 : 8

            Label {
                text: root.windowTitleText()
                color: "#17212a"
                font.pixelSize: 20
                font.bold: true
                Layout.fillWidth: true
            }

            Label {
                text: root.statusLabelText()
                color: root.currentPlayer === 1 ? "#111318" : "#697178"
                font.pixelSize: 15
                font.bold: true
                Layout.fillWidth: true
            }

            Label {
                text: root.trText("stones") + ": " + root.stoneCount + " / " + (root.boardSize * root.boardSize * root.boardSize)
                color: "#33424d"
                font.pixelSize: 14
                Layout.fillWidth: true
            }

            Label {
                text: root.hoverKey === ""
                      ? root.trText("hoverNone")
                      : root.trText("hover") + ": " + root.coordinateText(root.hoverX, root.hoverY, root.hoverZ)
                color: "#33424d"
                font.pixelSize: 14
                Layout.fillWidth: true
            }

            RowLayout {
                spacing: 8

                Button {
                    text: root.trText("undo")
                    enabled: root.currentNodeId !== 0
                    onClicked: root.undoMove()
                }

                Button {
                    text: root.trText("clear")
                    enabled: root.treeNodes.length > 1
                    onClicked: root.clearBoard()
                }
            }
        }
    }

    Rectangle {
        id: branchPanel
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: root.panelMargin
        anchors.topMargin: root.topContentMargin
        anchors.bottomMargin: root.bottomContentMargin
        width: root.branchPanelWidth
        radius: 8
        color: "#f3f7f9"
        border.color: "#b9c8d0"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: root.panelInnerMargin
            spacing: root.compactLayout ? 6 : 8

            Label {
                text: root.trText("gameTree")
                color: "#17212a"
                font.pixelSize: root.compactLayout ? 16 : 18
                font.bold: true
                Layout.fillWidth: true
            }

            Label {
                text: root.trText("currentMove") + ": " + root.currentNodeText()
                color: "#52636d"
                font.pixelSize: 12
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Rectangle {
                id: treeViewport
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 6
                color: "#e9f0f4"
                border.color: "#c5d1d8"
                clip: true

                Flickable {
                    id: treeFlick
                    anchors.fill: parent
                    anchors.margins: root.compactLayout ? 6 : 8
                    clip: true
                    contentWidth: Math.max(width, root.treeCanvasWidth)
                    contentHeight: Math.max(height, root.treeCanvasHeight)
                    boundsBehavior: Flickable.StopAtBounds

                    Canvas {
                        id: branchCanvas
                        width: treeFlick.contentWidth
                        height: treeFlick.contentHeight

                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.clearRect(0, 0, width, height)

                            var leftNodeByMove = ({})
                            for (var r = 0; r < root.treeNodes.length; ++r) {
                                var rowNode = root.treeNodes[r]
                                var currentLeft = leftNodeByMove[rowNode.moveNumber]
                                if (!currentLeft || rowNode.x < currentLeft.x)
                                    leftNodeByMove[rowNode.moveNumber] = rowNode
                            }

                            ctx.font = "9px sans-serif"
                            ctx.textAlign = "right"
                            ctx.textBaseline = "middle"
                            ctx.fillStyle = "#6f7f88"
                            for (var moveNumber in leftNodeByMove) {
                                var leftNode = leftNodeByMove[moveNumber]
                                ctx.fillText(String(leftNode.moveNumber),
                                             Math.max(10, leftNode.x - leftNode.radius - 7),
                                             leftNode.y)
                            }

                            ctx.lineCap = "round"
                            ctx.lineJoin = "round"
                            for (var e = 0; e < root.treeEdges.length; ++e) {
                                var edge = root.treeEdges[e]
                                ctx.beginPath()
                                ctx.moveTo(edge.x1, edge.y1)
                                ctx.lineTo(edge.x2, edge.y2)
                                ctx.lineWidth = edge.current ? 3 : 2
                                ctx.strokeStyle = edge.current ? "#2b83c6" : "#afbdc5"
                                ctx.stroke()
                            }

                            for (var i = 0; i < root.treeNodes.length; ++i) {
                                var node = root.treeNodes[i]
                                ctx.beginPath()
                                ctx.arc(node.x, node.y, node.radius, 0, Math.PI * 2)
                                if (node.player === 1) {
                                    ctx.fillStyle = "#101418"
                                } else if (node.player === 2) {
                                    ctx.fillStyle = "#fff8e8"
                                } else {
                                    ctx.fillStyle = "#d9e3e9"
                                }
                                ctx.fill()
                                ctx.lineWidth = node.current ? 3 : 1.5
                                ctx.strokeStyle = node.current ? "#2b83c6" : (node.player === 2 ? "#65747d" : "#41515a")
                                ctx.stroke()

                                ctx.fillStyle = node.player === 1 ? "#f7fbfd" : "#1a252d"
                                ctx.font = node.current ? "bold 10px sans-serif" : "10px sans-serif"
                                ctx.textAlign = "center"
                                ctx.textBaseline = "middle"
                                ctx.fillText(node.label, node.x, node.y)
                            }
                        }

                        onWidthChanged: requestPaint()
                        onHeightChanged: requestPaint()

                        Connections {
                            target: root
                            function onTreeRevisionChanged() {
                                branchCanvas.requestPaint()
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: branchCanvas
                        acceptedButtons: Qt.LeftButton
                        hoverEnabled: true

                        onClicked: function(mouse) {
                            var nodeId = root.treeNodeAt(mouse.x, mouse.y)
                            if (nodeId >= 0) {
                                inputLayer.forceActiveFocus()
                                root.gotoNode(nodeId)
                            }
                            mouse.accepted = true
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: visualPanel
        anchors.right: branchPanel.left
        anchors.rightMargin: root.panelGap
        anchors.top: parent.top
        anchors.topMargin: root.topContentMargin
        width: root.controlPanelWidth
        height: root.visualPanelHeight
        radius: 8
        color: "#f3f7f9"
        border.color: "#b9c8d0"
        clip: true

        Flickable {
            id: visualPanelFlick
            anchors.fill: parent
            anchors.margins: root.panelInnerMargin
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
            spacing: root.compactLayout ? 5 : 8

            Label {
                text: root.trText("boardSize") + " / " + root.trText("visualSettings")
                color: "#17212a"
                font.pixelSize: root.compactLayout ? 16 : 18
                font.bold: true
                Layout.fillWidth: true
            }

            Label {
                text: root.trText("boardSize") + "  " + root.boardSize + "x" + root.boardSize + "x" + root.boardSize
                color: "#2f414c"
                font.pixelSize: root.compactLayout ? 12 : 14
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.fillWidth: true

                SpinBox {
                    from: root.minBoardSize
                    to: root.maxBoardSize
                    value: root.boardSize
                    editable: true
                    Layout.fillWidth: true
                    onValueModified: {
                        inputLayer.forceActiveFocus()
                        root.setBoardSize(value)
                    }
                }

                Button {
                    text: root.trText("reset")
                    Layout.preferredWidth: root.compactLayout ? 56 : 62
                    onClicked: {
                        inputLayer.forceActiveFocus()
                        root.setBoardSize(root.defaultBoardSize)
                    }
                }
            }

            Label {
                text: root.trText("stoneSize") + "  " + Math.round(root.stoneScale * 100) + "%"
                color: "#2f414c"
                font.pixelSize: root.compactLayout ? 12 : 14
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.fillWidth: true

                Slider {
                    from: root.minStoneScale
                    to: 1.00
                    value: root.stoneScale
                    stepSize: 0.01
                    Layout.fillWidth: true
                    onMoved: root.stoneScale = value
                }

                Button {
                    text: root.trText("reset")
                    Layout.preferredWidth: root.compactLayout ? 56 : 62
                    onClicked: {
                        inputLayer.forceActiveFocus()
                        root.stoneScale = root.defaultStoneScale
                    }
                }
            }

            Label {
                text: root.trText("moveNumberDisplay") + "  " + root.moveNumberDisplayText()
                color: "#2f414c"
                font.pixelSize: root.compactLayout ? 12 : 14
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.fillWidth: true

                ComboBox {
                    model: [
                        root.trText("moveNumberAll"),
                        root.trText("moveNumberLastOnly"),
                        root.trText("moveNumberHidden")
                    ]
                    currentIndex: root.moveNumberDisplayMode
                    Layout.fillWidth: true
                    onActivated: function(index) {
                        inputLayer.forceActiveFocus()
                        root.moveNumberDisplayMode = index
                    }
                }

                Button {
                    text: root.trText("reset")
                    Layout.preferredWidth: root.compactLayout ? 56 : 62
                    onClicked: {
                        inputLayer.forceActiveFocus()
                        root.moveNumberDisplayMode = root.defaultMoveNumberDisplayMode
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: root.compactLayout ? 4 : 8

                CheckBox {
                    text: root.trText("stoneLighting")
                    checked: root.stoneLightingEnabled
                    font.pixelSize: root.compactLayout ? 11 : 13
                    Layout.fillWidth: true
                    onToggled: {
                        inputLayer.forceActiveFocus()
                        root.stoneLightingEnabled = checked
                    }
                }

                CheckBox {
                    text: root.trText("lightFollowsCamera")
                    checked: root.lightFollowsCamera
                    font.pixelSize: root.compactLayout ? 11 : 13
                    Layout.fillWidth: true
                    onToggled: {
                        inputLayer.forceActiveFocus()
                        root.lightFollowsCamera = checked
                    }
                }
            }

            Label {
                text: root.trText("gridPointOpacity") + "  " + Math.round(root.gridOpacity * 100) + "%"
                color: "#2f414c"
                font.pixelSize: root.compactLayout ? 12 : 14
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.fillWidth: true

                Slider {
                    from: 0.12
                    to: 0.9
                    value: root.gridOpacity
                    stepSize: 0.01
                    Layout.fillWidth: true
                    onMoved: root.gridOpacity = value
                }

                Button {
                    text: root.trText("reset")
                    Layout.preferredWidth: root.compactLayout ? 56 : 62
                    onClicked: {
                        inputLayer.forceActiveFocus()
                        root.gridOpacity = root.defaultGridOpacity
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: root.compactLayout ? 4 : 8

                CheckBox {
                    text: root.trText("hideLines")
                    checked: root.hideGridLines
                    font.pixelSize: root.compactLayout ? 11 : 13
                    Layout.fillWidth: true
                    onToggled: {
                        inputLayer.forceActiveFocus()
                        root.hideGridLines = checked
                    }
                }

                CheckBox {
                    text: root.trText("hidePoints")
                    checked: root.hideGridPoints
                    font.pixelSize: root.compactLayout ? 11 : 13
                    Layout.fillWidth: true
                    onToggled: {
                        inputLayer.forceActiveFocus()
                        root.hideGridPoints = checked
                    }
                }
            }

            Label {
                text: root.trText("hiddenTransparency") + "  " + Math.round(root.hiddenLayerTransparency * 100) + "%"
                color: "#2f414c"
                font.pixelSize: root.compactLayout ? 12 : 14
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.fillWidth: true

                Slider {
                    from: 0.2
                    to: 1.0
                    value: root.hiddenLayerTransparency
                    stepSize: 0.01
                    Layout.fillWidth: true
                    onMoved: root.hiddenLayerTransparency = value
                }

                Button {
                    text: root.trText("reset")
                    Layout.preferredWidth: root.compactLayout ? 56 : 62
                    onClicked: {
                        inputLayer.forceActiveFocus()
                        root.hiddenLayerTransparency = root.defaultHiddenLayerTransparency
                    }
                }
            }
            }
        }
    }

    Rectangle {
        id: clipPanel
        anchors.right: branchPanel.left
        anchors.rightMargin: root.panelGap
        anchors.top: visualPanel.bottom
        anchors.topMargin: root.panelGap
        anchors.bottom: parent.bottom
        anchors.bottomMargin: root.bottomContentMargin
        width: root.controlPanelWidth
        radius: 8
        color: "#f3f7f9"
        border.color: "#b9c8d0"
        clip: true

        Flickable {
            id: clipPanelFlick
            anchors.fill: parent
            anchors.margins: root.panelInnerMargin
            clip: true
            interactive: contentHeight > height
            contentWidth: width
            contentHeight: clipPanelContent.implicitHeight
            boundsBehavior: Flickable.StopAtBounds

            ScrollBar.vertical: ScrollBar {
                policy: clipPanelFlick.contentHeight > clipPanelFlick.height
                        ? ScrollBar.AsNeeded
                        : ScrollBar.AlwaysOff
            }

            ColumnLayout {
            id: clipPanelContent
            width: clipPanelFlick.width
            spacing: root.compactLayout ? 5 : 8

            RowLayout {
                Layout.fillWidth: true

                Label {
                    text: root.trText("clipLayers")
                    color: "#17212a"
                    font.pixelSize: root.compactLayout ? 16 : 18
                    font.bold: true
                    Layout.fillWidth: true
                }

                Button {
                    text: root.trText("reset")
                    Layout.preferredWidth: root.compactLayout ? 56 : 62
                    onClicked: {
                        inputLayer.forceActiveFocus()
                        root.resetClipCounts()
                    }
                }
            }

            Label {
                text: root.trText("activeAxis") + ": " + root.frontFacingClipAxis()
                color: "#52636d"
                font.pixelSize: 12
                Layout.fillWidth: true
            }

            Item {
                id: clipCross
                property real center: width / 2
                property real crossSize: Math.max(root.compactLayout ? 138 : 170,
                                                  Math.min(root.compactLayout ? 176 : 204,
                                                           clipPanel.height * (root.compactLayout ? 0.34 : 0.42)))
                property real axisRadius: crossSize * 0.34

                width: crossSize
                height: crossSize
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

            Flickable {
                id: clipRowsFlick
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(clipRowsContent.implicitHeight,
                                                 root.compactLayout ? 176 : 214)
                Layout.minimumHeight: root.compactLayout ? 88 : 150
                clip: true
                contentWidth: width
                contentHeight: clipRowsContent.implicitHeight
                boundsBehavior: Flickable.StopAtBounds

                ScrollBar.vertical: ScrollBar {
                    policy: clipRowsFlick.contentHeight > clipRowsFlick.height
                            ? ScrollBar.AsNeeded
                            : ScrollBar.AlwaysOff
                }

                ColumnLayout {
                    id: clipRowsContent
                    width: clipRowsFlick.width
                    spacing: root.compactLayout ? 3 : 6

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: root.compactLayout ? 4 : 6

                        Label {
                            text: root.trText("axis")
                            color: "#52636d"
                            font.pixelSize: root.compactLayout ? 11 : 12
                            Layout.preferredWidth: root.compactLayout ? 36 : 42
                        }

                        Label {
                            text: root.trText("layers")
                            color: "#52636d"
                            font.pixelSize: root.compactLayout ? 11 : 12
                            horizontalAlignment: Text.AlignHCenter
                            Layout.fillWidth: true
                        }

                        Label {
                            text: root.trText("edit")
                            color: "#52636d"
                            font.pixelSize: root.compactLayout ? 11 : 12
                            horizontalAlignment: Text.AlignHCenter
                            Layout.preferredWidth: root.compactLayout ? 68 : 76
                        }
                    }

                    Repeater {
                        model: root.clipAxes

                        delegate: RowLayout {
                            Layout.fillWidth: true
                            spacing: root.compactLayout ? 4 : 6

                            Label {
                                text: modelData.axis
                                color: modelData.color
                                font.pixelSize: root.compactLayout ? 12 : 13
                                font.bold: true
                                Layout.preferredWidth: root.compactLayout ? 36 : 42
                            }

                            Label {
                                text: root.clipCount(modelData.axis)
                                color: "#16212a"
                                font.pixelSize: root.compactLayout ? 14 : 15
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                                Layout.fillWidth: true
                            }

                            RowLayout {
                                spacing: root.compactLayout ? 3 : 4
                                Layout.preferredWidth: root.compactLayout ? 68 : 76

                                Button {
                                    text: "-"
                                    enabled: root.clipCount(modelData.axis) > 0
                                    Layout.preferredWidth: root.compactLayout ? 31 : 34
                                    Layout.preferredHeight: root.compactLayout ? 24 : 28
                                    onClicked: {
                                        inputLayer.forceActiveFocus()
                                        root.adjustClip(modelData.axis, -1)
                                    }
                                }

                                Button {
                                    text: "+"
                                    enabled: root.clipCount(modelData.axis) < root.boardSize
                                    Layout.preferredWidth: root.compactLayout ? 31 : 34
                                    Layout.preferredHeight: root.compactLayout ? 24 : 28
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
    }
}
