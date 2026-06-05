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
            "menuHelp": "帮助",
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
            "lightFollowsCamera": "灯光跟随镜头",
            "helpKeyMoveLateral": "W/S：沿当前视角上下移动",
            "helpKeyMoveSide": "A/D：沿当前视角左右移动",
            "helpKeyMoveDepth": "Q/E：沿当前视角前后移动",
            "helpKeyClip": "X/Z：减少/增加当前面向方向的裁剪层",
            "helpKeyRotate": "←/→：水平旋转镜头",
            "helpKeyResetCamera": "Space：重置镜头",
            "helpKeyDelete": "Backspace：删除当前节点",
            "helpKeyMoveLabels": "M：切换棋子手数显示"
        },
        "en": {
            "windowTitle": "Lizzie3D",
            "menuFile": "File",
            "menuEdit": "Edit",
            "menuView": "View",
            "menuSettings": "Settings",
            "menuHelp": "Help",
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
            "lightFollowsCamera": "Light follows camera",
            "helpKeyMoveLateral": "W/S: move up/down relative to the camera",
            "helpKeyMoveSide": "A/D: move left/right relative to the camera",
            "helpKeyMoveDepth": "Q/E: move forward/back relative to the camera",
            "helpKeyClip": "X/Z: decrease/increase clip layers on the facing axis",
            "helpKeyRotate": "Left/Right: rotate the camera horizontally",
            "helpKeyResetCamera": "Space: reset camera",
            "helpKeyDelete": "Backspace: delete current node",
            "helpKeyMoveLabels": "M: switch move-number display"
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

        Menu {
            title: root.trText("menuHelp")

            Action { text: root.trText("helpKeyMoveLateral"); enabled: false }
            Action { text: root.trText("helpKeyMoveSide"); enabled: false }
            Action { text: root.trText("helpKeyMoveDepth"); enabled: false }
            Action { text: root.trText("helpKeyClip"); enabled: false }
            Action { text: root.trText("helpKeyRotate"); enabled: false }
            Action { text: root.trText("helpKeyResetCamera"); enabled: false }
            Action { text: root.trText("helpKeyDelete"); enabled: false }
            Action { text: root.trText("helpKeyMoveLabels"); enabled: false }
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
            focusBoardInput()
        }

        onRejected: focusBoardInput()
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
    property var mainAxisLabels: []
    property var stones: ({})
    property var stoneItems: []
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

    function focusBoardInput() {
        if (inputLayer)
            inputLayer.forceActiveFocus()
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

    function gridLineRgb(axis) {
        if (axis === 0)
            return Qt.vector3d(0x3e / 255, 0x27 / 255, 0x29 / 255)
        if (axis === 1)
            return Qt.vector3d(0x29 / 255, 0x39 / 255, 0x2c / 255)
        return Qt.vector3d(0x28 / 255, 0x35 / 255, 0x44 / 255)
    }

    function appendGridLineSegment(data, axis, a, b, fixed1, fixed2) {
        if (axis === 0) {
            data.push(pointPosition(a, fixed1, fixed2))
            data.push(pointPosition(b, fixed1, fixed2))
        } else if (axis === 1) {
            data.push(pointPosition(fixed1, a, fixed2))
            data.push(pointPosition(fixed1, b, fixed2))
        } else {
            data.push(pointPosition(fixed1, fixed2, a))
            data.push(pointPosition(fixed1, fixed2, b))
        }
    }

    function appendGridLineColor(data, rgb, alpha) {
        data.push(Qt.vector4d(rgb.x, rgb.y, rgb.z, alpha))
        data.push(Qt.vector4d(rgb.x, rgb.y, rgb.z, alpha))
    }

    function gridLineSegmentOpacity(axis, a, b, fixed1, fixed2, highlighted) {
        if (hideGridLines)
            return 0

        var x1 = axis === 0 ? a : fixed1
        var y1 = axis === 1 ? a : (axis === 0 ? fixed1 : fixed2)
        var z1 = axis === 2 ? a : fixed2
        var x2 = axis === 0 ? b : fixed1
        var y2 = axis === 1 ? b : (axis === 0 ? fixed1 : fixed2)
        var z2 = axis === 2 ? b : fixed2
        var baseOpacity = highlighted ? Math.max(0.9, gridOpacity) : gridOpacity
        var clipped = isClipped(x1, y1, z1) || isClipped(x2, y2, z2)
        return clipped ? baseOpacity * hiddenLayerOpacity() : baseOpacity
    }

    function gridLinePositions(axis) {
        var data = []
        for (var fixed1 = 0; fixed1 < boardSize; ++fixed1) {
            for (var fixed2 = 0; fixed2 < boardSize; ++fixed2) {
                for (var i = 0; i < boardSize - 1; ++i)
                    appendGridLineSegment(data, axis, i, i + 1, fixed1, fixed2)
            }
        }
        return data
    }

    function gridLineColors(axis) {
        var data = []
        var rgb = gridLineRgb(axis)
        for (var fixed1 = 0; fixed1 < boardSize; ++fixed1) {
            for (var fixed2 = 0; fixed2 < boardSize; ++fixed2) {
                for (var i = 0; i < boardSize - 1; ++i)
                    appendGridLineColor(data, rgb, gridLineSegmentOpacity(axis, i, i + 1, fixed1, fixed2, false))
            }
        }
        return data
    }

    function hoverGridLinePositions(axis) {
        var data = []
        if (hoverKey === "")
            return data

        var fixed1 = axis === 0 ? hoverY : hoverX
        var fixed2 = axis === 2 ? hoverY : hoverZ
        for (var i = 0; i < boardSize - 1; ++i)
            appendGridLineSegment(data, axis, i, i + 1, fixed1, fixed2)
        return data
    }

    function hoverGridLineColors(axis) {
        var data = []
        if (hoverKey === "")
            return data

        var rgb = Qt.vector3d(0x2f / 255, 0xb9 / 255, 0x7f / 255)
        var fixed1 = axis === 0 ? hoverY : hoverX
        var fixed2 = axis === 2 ? hoverY : hoverZ
        for (var i = 0; i < boardSize - 1; ++i)
            appendGridLineColor(data, rgb, gridLineSegmentOpacity(axis, i, i + 1, fixed1, fixed2, true))
        return data
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
        var nextStoneItems = []
        for (var i = 0; i < path.length; ++i) {
            var stoneItem = {
                "x": path[i].x,
                "y": path[i].y,
                "z": path[i].z,
                "key": path[i].key,
                "player": path[i].player,
                "moveNumber": path[i].moveNumber,
                "nodeId": path[i].id,
                "position": pointPosition(path[i].x, path[i].y, path[i].z)
            }
            nextStones[path[i].key] = stoneItem
            nextStoneItems.push(stoneItem)
        }

        stones = nextStones
        stoneItems = nextStoneItems
        stoneCount = path.length
        currentPlayer = stoneCount % 2 === 0 ? 1 : 2
        boardRevision += 1
        statusMode = "turn"
    }

    function resetGameTree() {
        stones = ({})
        stoneItems = []
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

        focusBoardInput()
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
        var dx = boardScene.sceneCamera.position.x - basePosition.x
        var dy = boardScene.sceneCamera.position.y - basePosition.y
        var dz = boardScene.sceneCamera.position.z - basePosition.z
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
        var normal = normalizedVector(Qt.vector3d(boardScene.sceneCamera.position.x - labelPosition.x,
                                                  boardScene.sceneCamera.position.y - labelPosition.y,
                                                  boardScene.sceneCamera.position.z - labelPosition.z),
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
        focusBoardInput()
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
        axisGizmo.axisView.width
        axisGizmo.axisView.height

        var size = Math.min(axisGizmo.axisView.width, axisGizmo.axisView.height)
        if (size <= 0)
            return Qt.point(-1000, -1000)

        return projectedAxisPoint(dx, dy, dz, axisGizmo.axisView.width / 2, Math.max(32, size * 0.36))
    }

    function hoverLabelPoint() {
        cameraYaw
        cameraPitch
        cameraDistance
        cameraTarget
        hoverKey
        if (hoverKey === "" || !boardScene.sceneCamera)
            return Qt.point(-1000, -1000)

        var hoverPoint = pointPosition(hoverX, hoverY, hoverZ)
        var mapped = boardScene.mapFrom3DScene(Qt.vector3d(hoverPoint.x,
                                                         hoverPoint.y + spacing * 0.42,
                                                         hoverPoint.z))
        return Qt.point(boardScene.x + mapped.x, boardScene.y + mapped.y)
    }

    function refreshCamera() {
        var yaw = cameraYaw * Math.PI / 180
        var pitch = cameraPitch * Math.PI / 180
        var cp = Math.cos(pitch)
        boardScene.sceneCamera.position = Qt.vector3d(
            cameraTarget.x + cameraDistance * Math.sin(yaw) * cp,
            cameraTarget.y + cameraDistance * Math.sin(pitch),
            cameraTarget.z + cameraDistance * Math.cos(yaw) * cp)
        boardScene.sceneCamera.lookAt(cameraTarget)
        refreshAxisCamera()
    }

    function refreshAxisCamera() {
        if (!axisGizmo.axisCamera)
            return

        var yaw = cameraYaw * Math.PI / 180
        var pitch = cameraPitch * Math.PI / 180
        var cp = Math.cos(pitch)
        var distance = 320
        axisGizmo.axisCamera.position = Qt.vector3d(
            distance * Math.sin(yaw) * cp,
            distance * Math.sin(pitch),
            distance * Math.cos(yaw) * cp)
        axisGizmo.axisCamera.lookAt(Qt.vector3d(0, 0, 0))
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

    function pointFromMouse(x, y) {
        if (!boardScene || !boardScene.sceneCamera || boardScene.width <= 0 || boardScene.height <= 0)
            return null

        var aspect = boardScene.width / boardScene.height
        var fieldOfView = boardScene.sceneCamera.fieldOfView * Math.PI / 180
        var halfHeight = Math.tan(fieldOfView * 0.5)
        var nx = (x / boardScene.width) * 2 - 1
        var ny = 1 - (y / boardScene.height) * 2
        var back = cameraBackVector()
        var forward = Qt.vector3d(-back.x, -back.y, -back.z)
        var right = cameraRightVector()
        var up = cameraUpVector()
        var ray = normalizedVector(Qt.vector3d(forward.x + right.x * nx * aspect * halfHeight + up.x * ny * halfHeight,
                                               forward.y + right.y * nx * aspect * halfHeight + up.y * ny * halfHeight,
                                               forward.z + right.z * nx * aspect * halfHeight + up.z * ny * halfHeight),
                                   forward)
        var origin = boardScene.sceneCamera.position
        var hitRadius = quick3DPrimitiveDiameter * gridPointSphereScale * 0.5
        var hitRadiusSquared = hitRadius * hitRadius
        var bestPoint = null
        var bestDistance = Number.POSITIVE_INFINITY

        for (var i = 0; i < points.length; ++i) {
            var point = points[i]
            if (isClipped(point.x, point.y, point.z))
                continue

            var p = point.position
            var ox = p.x - origin.x
            var oy = p.y - origin.y
            var oz = p.z - origin.z
            var alongRay = ox * ray.x + oy * ray.y + oz * ray.z
            if (alongRay < 0)
                continue

            var distanceSquared = ox * ox + oy * oy + oz * oz - alongRay * alongRay
            if (distanceSquared <= hitRadiusSquared && alongRay < bestDistance) {
                bestDistance = alongRay
                bestPoint = point
            }
        }

        return bestPoint
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

    CommandToolbar {
        id: commandToolbar
        app: root
    }

    BoardScene {
        id: boardScene
        app: root
    }

    HoverCoordinateBadge {
        id: hoverCoordinateBadge
        app: root
    }

    BoardInputLayer {
        id: inputLayer
        app: root
        anchors.fill: boardScene
    }

    AxisGizmoPanel {
        id: axisGizmo
        app: root
    }

    InfoPanel {
        id: infoPanel
        app: root
    }

    BranchPanel {
        id: branchPanel
        app: root
    }

    VisualSettingsPanel {
        id: visualPanel
        app: root
        branchPanelItem: branchPanel
    }

    ClipPanel {
        id: clipPanel
        app: root
        branchPanelItem: branchPanel
        visualPanelItem: visualPanel
    }
}
