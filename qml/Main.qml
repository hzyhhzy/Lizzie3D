import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Basic as Basic
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
            "menuOpenSgf": "打开 SGF...",
            "menuSaveSgf": "保存 SGF...",
            "menuExit": "退出",
            "menuBoardSize": "设置棋盘大小...",
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
            "sgfOpenTitle": "打开 SGF",
            "sgfSaved": "SGF 已保存",
            "sgfSaveFailed": "SGF 保存失败",
            "sgfLoaded": "SGF 已读取",
            "sgfLoadFailed": "SGF 读取失败",
            "unsavedGameTitle": "保存棋谱",
            "confirmSaveGame": "是否保存棋谱",
            "save": "保存",
            "dontSave": "不保存",
            "cancel": "取消",
            "confirm": "确定",
            "custom": "其他",
            "boardSizeDialogTitle": "设置棋盘大小",
            "boardSizeX": "长",
            "boardSizeY": "宽",
            "boardSizeZ": "高",
            "moveNumberDisplay": "手数显示",
            "moveNumberAll": "全部手数",
            "moveNumberLastOnly": "仅最后一手",
            "moveNumberHidden": "隐藏数字",
            "stoneLighting": "棋子打光",
            "lightFollowsCamera": "灯光跟随镜头",
            "engine": "引擎",
            "engineCommand": "启动指令",
            "engineStart": "启动",
            "engineStop": "停止",
            "engineAnalyze": "分析",
            "engineStatus": "引擎状态",
            "engineNotStarted": "未启动",
            "engineRunning": "运行中",
            "engineCandidates": "选点",
            "engineUseFlattened2D": "使用二维换算坐标",
            "engineBestMove": "首选",
            "engineAnalyzeRequested": "已请求引擎分析",
            "engineNoCandidates": "暂无选点",
            "enginePaused": "分析暂停",
            "engineLoading": "引擎加载中",
            "engineAutoAnalyzing": "自动分析中",
            "komi": "贴目",
            "stoneColor": "落子",
            "stoneColorAuto": "黑白交替",
            "stoneColorBlack": "黑子",
            "stoneColorWhite": "白子",
            "captured": "提子",
            "coordinateShort": "坐标",
            "playMove": "落子",
            "coordinateInvalid": "坐标无效",
            "moveClickConfirm": "落子双击确认",
            "viewAndClipLayers": "视图与裁剪层",
            "resetView": "重置视图",
            "resetClip": "重置裁剪",
            "stoneColorAutoTip": "黑白交替",
            "stoneColorBlackTip": "黑子",
            "stoneColorWhiteTip": "白子",
            "gameRule": "规则",
            "gameRuleGo": "围棋",
            "gameRuleGomoku": "五子棋",
            "ruleChangeTitle": "切换规则",
            "confirmRuleChangeSave": "切换规则会清空当前棋盘。是否先保存棋谱？",
            "ruleChanged": "已切换规则",
            "suicideMove": "禁入点",
            "captureMessage": "提子",
            "helpKeyMoveLateral": "W/S：沿当前视角上下移动",
            "helpKeyMoveSide": "A/D：沿当前视角左右移动",
            "helpKeyMoveDepth": "Q/E：沿当前视角前后移动",
            "helpKeyClip": "X/Z：减少/增加当前面向方向的裁剪层",
            "helpKeyRotate": "←/→：水平旋转镜头",
            "helpKeyResetCamera": "菜单：重置镜头",
            "helpKeyPauseEngine": "Space：暂停/继续分析",
            "helpKeyPlayBest": ",：按引擎首选落子",
            "helpKeyDelete": "Backspace：删除当前节点",
            "helpKeyMoveLabels": "M：切换棋子手数显示",
            "helpKeyOpenSgf": "Ctrl+O：打开 SGF",
            "helpKeySaveSgf": "Ctrl+S：保存 SGF",
            "helpKeyBoardSize": "Ctrl+I：设置棋盘大小"
        },
        "en": {
            "windowTitle": "Lizzie3D",
            "menuFile": "File",
            "menuEdit": "Edit",
            "menuView": "View",
            "menuSettings": "Settings",
            "menuHelp": "Help",
            "menuOpenSgf": "Open SGF...",
            "menuSaveSgf": "Save SGF...",
            "menuExit": "Exit",
            "menuBoardSize": "Set board size...",
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
            "sgfOpenTitle": "Open SGF",
            "sgfSaved": "SGF saved",
            "sgfSaveFailed": "Failed to save SGF",
            "sgfLoaded": "SGF loaded",
            "sgfLoadFailed": "Failed to load SGF",
            "unsavedGameTitle": "Save game record",
            "confirmSaveGame": "Save game record?",
            "save": "Save",
            "dontSave": "Don't save",
            "cancel": "Cancel",
            "confirm": "OK",
            "custom": "Custom",
            "boardSizeDialogTitle": "Set board size",
            "boardSizeX": "Length",
            "boardSizeY": "Width",
            "boardSizeZ": "Height",
            "moveNumberDisplay": "Move labels",
            "moveNumberAll": "All move numbers",
            "moveNumberLastOnly": "Last move only",
            "moveNumberHidden": "No numbers",
            "stoneLighting": "Light stones",
            "lightFollowsCamera": "Light follows camera",
            "engine": "Engine",
            "engineCommand": "Command",
            "engineStart": "Start",
            "engineStop": "Stop",
            "engineAnalyze": "Analyze",
            "engineStatus": "Engine",
            "engineNotStarted": "Not started",
            "engineRunning": "Running",
            "engineCandidates": "Candidates",
            "engineUseFlattened2D": "Use 2D mapped coordinates",
            "engineBestMove": "Best",
            "engineAnalyzeRequested": "Engine analysis requested",
            "engineNoCandidates": "No candidates yet",
            "enginePaused": "Analysis paused",
            "engineLoading": "Loading engine",
            "engineAutoAnalyzing": "Auto analyzing",
            "komi": "Komi",
            "stoneColor": "Stone",
            "stoneColorAuto": "Alternate",
            "stoneColorBlack": "Black",
            "stoneColorWhite": "White",
            "captured": "Captures",
            "coordinateShort": "Coord",
            "playMove": "Play",
            "coordinateInvalid": "Invalid coordinate",
            "moveClickConfirm": "Click twice to play",
            "viewAndClipLayers": "View and clip",
            "resetView": "Reset view",
            "resetClip": "Reset clip",
            "stoneColorAutoTip": "Alternate colors",
            "stoneColorBlackTip": "Black",
            "stoneColorWhiteTip": "White",
            "gameRule": "Rule",
            "gameRuleGo": "Go",
            "gameRuleGomoku": "Gomoku",
            "ruleChangeTitle": "Change rule",
            "confirmRuleChangeSave": "Changing rules will clear the current board. Save the SGF first?",
            "ruleChanged": "Rule changed",
            "suicideMove": "Illegal self-capture",
            "captureMessage": "Captures",
            "helpKeyMoveLateral": "W/S: move up/down relative to the camera",
            "helpKeyMoveSide": "A/D: move left/right relative to the camera",
            "helpKeyMoveDepth": "Q/E: move forward/back relative to the camera",
            "helpKeyClip": "X/Z: decrease/increase clip layers on the facing axis",
            "helpKeyRotate": "Left/Right: rotate the camera horizontally",
            "helpKeyResetCamera": "Menu: reset camera",
            "helpKeyPauseEngine": "Space: pause/resume analysis",
            "helpKeyPlayBest": ",: play the engine best move",
            "helpKeyDelete": "Backspace: delete current node",
            "helpKeyMoveLabels": "M: switch move-number display",
            "helpKeyOpenSgf": "Ctrl+O: open SGF",
            "helpKeySaveSgf": "Ctrl+S: save SGF",
            "helpKeyBoardSize": "Ctrl+I: set board size"
        }
    })

    title: root.windowTitleText()
    property bool gameDirty: false
    property bool suppressUnsavedPrompt: false
    property bool saveDialogClosesApp: false
    property int pendingRuleMode: -1
    property bool viewNavigationKeysBlocked: false

    component SavePromptButton: Basic.Button {
        id: savePromptButton
        property bool primary: false
        implicitWidth: 104
        implicitHeight: 34
        padding: 0

        contentItem: Text {
            text: savePromptButton.text
            color: savePromptButton.primary ? "#ffffff" : "#22333d"
            font.pixelSize: 13
            font.bold: savePromptButton.primary
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle {
            radius: 6
            color: savePromptButton.primary
                   ? (savePromptButton.pressed ? "#1d6fa8" : savePromptButton.hovered ? "#2c8dcc" : "#267fbb")
                   : (savePromptButton.pressed ? "#d5e1e8" : savePromptButton.hovered ? "#edf4f8" : "#f8fbfd")
            border.color: savePromptButton.primary ? "#1d6fa8" : "#9fb2bd"
            border.width: 1
        }
    }

    onClosing: function(event) {
        if (gameDirty && !suppressUnsavedPrompt) {
            event.accepted = false
            unsavedSgfDialog.open()
        }
    }

    menuBar: MenuBar {
        Menu {
            title: root.trText("menuFile")

            Action {
                text: root.trText("menuOpenSgf")
                shortcut: "Ctrl+O"
                onTriggered: root.openLoadSgfDialog()
            }

            Action {
                text: root.trText("menuSaveSgf")
                shortcut: "Ctrl+S"
                onTriggered: root.openSaveSgfDialog()
            }

            Action {
                text: root.trText("menuExit")
                onTriggered: root.requestQuit()
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
                text: root.trText("menuBoardSize")
                shortcut: "Ctrl+I"
                onTriggered: root.openBoardSizeDialog()
            }

            MenuSeparator {}

            Action {
                text: root.trText("menuResetVisual")
                onTriggered: root.resetVisualSettings()
            }

            MenuSeparator {}

            Menu {
                title: root.trText("gameRule")

                Action {
                    text: root.trText("gameRuleGo")
                    checkable: true
                    checked: root.gameRuleMode === root.gameRuleGo
                    onTriggered: root.requestRuleModeChange(root.gameRuleGo)
                }

                Action {
                    text: root.trText("gameRuleGomoku")
                    checkable: true
                    checked: root.gameRuleMode === root.gameRuleGomoku
                    onTriggered: root.requestRuleModeChange(root.gameRuleGomoku)
                }
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
            title: root.trText("engine")

            Action {
                text: root.trText("engineStart")
                enabled: !engineController.running
                onTriggered: root.requestEngineAnalysis(true)
            }

            Action {
                text: root.trText("engineAnalyze")
                onTriggered: root.requestEngineAnalysis(true)
            }

            Action {
                text: root.trText("engineStop")
                enabled: engineController.running
                onTriggered: root.pauseEngineAnalysis()
            }

            MenuSeparator {}

            Action {
                text: root.trText("engineUseFlattened2D")
                checkable: true
                checked: root.useFlattened2DCoordinates
                onTriggered: root.useFlattened2DCoordinates = checked
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
            Action { text: root.trText("helpKeyPauseEngine"); enabled: false }
            Action { text: root.trText("helpKeyPlayBest"); enabled: false }
            Action { text: root.trText("helpKeyDelete"); enabled: false }
            Action { text: root.trText("helpKeyMoveLabels"); enabled: false }
            Action { text: root.trText("helpKeyOpenSgf"); enabled: false }
            Action { text: root.trText("helpKeySaveSgf"); enabled: false }
            Action { text: root.trText("helpKeyBoardSize"); enabled: false }
        }
    }

    FileDialog {
        id: saveSgfDialog
        title: root.trText("sgfSaveTitle")
        fileMode: FileDialog.SaveFile
        defaultSuffix: "sgf"
        nameFilters: [root.trText("sgfFileFilter"), root.trText("allFileFilter")]
        onAccepted: root.saveSgfToFile(selectedFile)
        onRejected: {
            root.saveDialogClosesApp = false
            root.pendingRuleMode = -1
            focusBoardInput()
        }
    }

    FileDialog {
        id: loadSgfDialog
        title: root.trText("sgfOpenTitle")
        fileMode: FileDialog.OpenFile
        nameFilters: [root.trText("sgfFileFilter"), root.trText("allFileFilter")]
        onAccepted: root.loadSgfFromFile(selectedFile)
        onRejected: focusBoardInput()
    }

    Timer {
        id: autoAnalyzeTimer
        interval: 280
        repeat: false
        onTriggered: root.requestEngineAnalysis(false)
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

    Basic.Dialog {
        id: unsavedSgfDialog
        modal: true
        title: root.trText("unsavedGameTitle")
        closePolicy: Popup.CloseOnEscape
        padding: 18
        width: Math.min(460, root.width - 80)
        x: Math.round((root.width - width) / 2)
        y: Math.round((root.height - height) / 2)

        background: Rectangle {
            radius: 10
            color: "#f8fbfd"
            border.color: "#8ea5b1"
            border.width: 1
        }

        header: Rectangle {
            height: 52
            color: "#e6eff4"
            radius: 10

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: parent.radius
                color: parent.color
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: "#c5d4dc"
            }

            Label {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 18
                anchors.rightMargin: 18
                text: unsavedSgfDialog.title
                color: "#14242e"
                font.pixelSize: 17
                font.bold: true
                elide: Text.ElideRight
            }
        }

        contentItem: ColumnLayout {
            implicitWidth: 424
            spacing: 18

            Label {
                text: root.trText("confirmSaveGame")
                color: "#17212a"
                wrapMode: Text.WordWrap
                font.pixelSize: 14
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Item { Layout.fillWidth: true }

                SavePromptButton {
                    text: root.trText("save")
                    primary: true
                    onClicked: {
                        unsavedSgfDialog.close()
                        root.openSaveSgfDialog(true)
                    }
                }

                SavePromptButton {
                    text: root.trText("dontSave")
                    onClicked: {
                        unsavedSgfDialog.close()
                        root.closeWithoutSaving()
                    }
                }

                SavePromptButton {
                    text: root.trText("cancel")
                    onClicked: {
                        unsavedSgfDialog.close()
                        focusBoardInput()
                    }
                }
            }
        }
    }

    Basic.Dialog {
        id: ruleChangeSaveDialog
        modal: true
        title: root.trText("ruleChangeTitle")
        closePolicy: Popup.CloseOnEscape
        padding: 18
        width: Math.min(480, root.width - 80)
        x: Math.round((root.width - width) / 2)
        y: Math.round((root.height - height) / 2)

        background: Rectangle {
            radius: 10
            color: "#f8fbfd"
            border.color: "#8ea5b1"
            border.width: 1
        }

        header: Rectangle {
            height: 52
            color: "#e6eff4"
            radius: 10

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: parent.radius
                color: parent.color
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: "#c5d4dc"
            }

            Label {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 18
                anchors.rightMargin: 18
                text: ruleChangeSaveDialog.title
                color: "#14242e"
                font.pixelSize: 17
                font.bold: true
                elide: Text.ElideRight
            }
        }

        contentItem: ColumnLayout {
            implicitWidth: 440
            spacing: 18

            Label {
                text: root.trText("confirmRuleChangeSave")
                color: "#17212a"
                wrapMode: Text.WordWrap
                font.pixelSize: 14
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Item { Layout.fillWidth: true }

                SavePromptButton {
                    text: root.trText("save")
                    primary: true
                    onClicked: {
                        ruleChangeSaveDialog.close()
                        root.openSaveSgfDialog(false)
                    }
                }

                SavePromptButton {
                    text: root.trText("dontSave")
                    onClicked: {
                        var mode = root.pendingRuleMode
                        ruleChangeSaveDialog.close()
                        root.pendingRuleMode = -1
                        root.applyRuleModeChange(mode)
                    }
                }

                SavePromptButton {
                    text: root.trText("cancel")
                    onClicked: {
                        ruleChangeSaveDialog.close()
                        root.pendingRuleMode = -1
                        focusBoardInput()
                    }
                }
            }
        }
    }

    Dialog {
        id: boardSizeDialog
        modal: true
        title: root.trText("boardSizeDialogTitle")
        closePolicy: Popup.CloseOnEscape
        width: Math.min(620, root.width - 80)
        x: Math.round((root.width - width) / 2)
        y: Math.round((root.height - height) / 2)

        property int selectedPreset: root.defaultBoardSize
        property string errorText: ""

        function showForCurrentBoard() {
            selectedPreset = (root.boardSizeX === root.boardSizeY
                              && root.boardSizeX === root.boardSizeZ
                              && (root.boardSizeX === 5 || root.boardSizeX === 7 || root.boardSizeX === 9))
                             ? root.boardSizeX
                             : 0
            sizeXSpin.value = root.boardSizeX
            sizeYSpin.value = root.boardSizeY
            sizeZSpin.value = root.boardSizeZ
            errorText = ""
            open()
        }

        function setPreset(size) {
            selectedPreset = size
            sizeXSpin.value = size
            sizeYSpin.value = size
            sizeZSpin.value = size
            errorText = ""
        }

        function applySize() {
            var xSize = sizeXSpin.value
            var ySize = sizeYSpin.value
            var zSize = sizeZSpin.value

            close()
            root.setBoardDimensions(xSize, ySize, zSize)
            focusBoardInput()
        }

        ButtonGroup { id: boardSizePresetGroup }

        ColumnLayout {
            width: parent.width
            spacing: 14

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                RadioButton {
                    text: "5x5x5"
                    checked: boardSizeDialog.selectedPreset === 5
                    ButtonGroup.group: boardSizePresetGroup
                    onClicked: boardSizeDialog.setPreset(5)
                }

                RadioButton {
                    text: "7x7x7"
                    checked: boardSizeDialog.selectedPreset === 7
                    ButtonGroup.group: boardSizePresetGroup
                    onClicked: boardSizeDialog.setPreset(7)
                }

                RadioButton {
                    text: "9x9x9"
                    checked: boardSizeDialog.selectedPreset === 9
                    ButtonGroup.group: boardSizePresetGroup
                    onClicked: boardSizeDialog.setPreset(9)
                }

                RadioButton {
                    text: root.trText("custom")
                    checked: boardSizeDialog.selectedPreset === 0
                    ButtonGroup.group: boardSizePresetGroup
                    onClicked: boardSizeDialog.selectedPreset = 0
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Label {
                    text: root.trText("boardSizeX")
                    color: "#24313a"
                }

                SpinBox {
                    id: sizeXSpin
                    from: root.minBoardSize
                    to: root.maxBoardSize
                    editable: true
                    Layout.preferredWidth: 92
                    onValueModified: boardSizeDialog.selectedPreset = 0
                }

                Label {
                    text: "x " + root.trText("boardSizeY")
                    color: "#24313a"
                }

                SpinBox {
                    id: sizeYSpin
                    from: root.minBoardSize
                    to: root.maxBoardSize
                    editable: true
                    Layout.preferredWidth: 92
                    onValueModified: boardSizeDialog.selectedPreset = 0
                }

                Label {
                    text: "x " + root.trText("boardSizeZ")
                    color: "#24313a"
                }

                SpinBox {
                    id: sizeZSpin
                    from: root.minBoardSize
                    to: root.maxBoardSize
                    editable: true
                    Layout.preferredWidth: 92
                    onValueModified: boardSizeDialog.selectedPreset = 0
                }

                Item { Layout.fillWidth: true }
            }

            Label {
                text: boardSizeDialog.errorText
                visible: boardSizeDialog.errorText !== ""
                color: "#b3261e"
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.fillWidth: true

                Item { Layout.fillWidth: true }

                Button {
                    text: root.trText("confirm")
                    highlighted: true
                    Layout.preferredWidth: 120
                    onClicked: boardSizeDialog.applySize()
                }

                Button {
                    text: root.trText("cancel")
                    Layout.preferredWidth: 96
                    onClicked: {
                        boardSizeDialog.close()
                        focusBoardInput()
                    }
                }
            }
        }
    }

    readonly property int minBoardSize: 1
    readonly property int maxBoardSize: 19
    readonly property int defaultBoardSize: 7
    readonly property int defaultBoardSizeX: defaultBoardSize
    readonly property int defaultBoardSizeY: defaultBoardSize
    readonly property int defaultBoardSizeZ: defaultBoardSize
    property int boardSizeX: defaultBoardSizeX
    property int boardSizeY: defaultBoardSizeY
    property int boardSizeZ: defaultBoardSizeZ
    readonly property int boardSize: Math.max(boardSizeX, boardSizeY, boardSizeZ)
    property real spacing: 100
    property real extentX: (boardSizeX - 1) * spacing
    property real extentY: (boardSizeY - 1) * spacing
    property real extentZ: (boardSizeZ - 1) * spacing
    property real extent: Math.max(extentX, extentY, extentZ)
    property real halfExtent: extent / 2
    readonly property bool compactLayout: width < 1500 || height < 820
    readonly property real analysisToolbarHeight: compactLayout ? 40 : 46
    readonly property real commandToolbarHeight: compactLayout ? 34 : 38
    readonly property real panelMargin: compactLayout ? 10 : 18
    readonly property real panelGap: compactLayout ? 8 : 14
    readonly property real panelInnerMargin: compactLayout ? 10 : 14
    readonly property real topContentMargin: analysisToolbarHeight + panelMargin
    readonly property real bottomContentMargin: panelMargin + commandToolbarHeight + panelGap
    readonly property real infoPanelWidth: compactLayout ? 260 : 314
    readonly property bool showAxisGizmoPanel: false
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
    readonly property int stoneColorModeAuto: 0
    readonly property int stoneColorModeBlack: 1
    readonly property int stoneColorModeWhite: 2
    readonly property int gameRuleGo: 0
    readonly property int gameRuleGomoku: 1
    property int gameRuleMode: gameRuleGo
    property int stoneColorMode: stoneColorModeAuto
    property real komi: 1.0
    property bool useFlattened2DCoordinates: true
    property bool appReady: false
    property bool engineAutoAnalyze: true
    property bool enginePaused: false
    property bool engineLoading: true
    property var engineCandidates: []
    property var engineCandidateItems: []
    property int engineCandidateRevision: 0
    property int blackCaptures: 0
    property int whiteCaptures: 0
    property var gomokuWinLineItems: []
    property var legalPointMap: ({})
    property int legalityRevision: 0
    property int coordinateInputX: 0
    property int coordinateInputY: 0
    property int coordinateInputZ: 0
    property string coordinateInputText: ""
    property bool moveClickConfirm: true
    property bool selectedPointLocked: false

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
    property int axisCameraRevision: 0
    property bool axisCameraRefreshPending: false
    readonly property real quick3DPrimitiveDiameter: 100
    readonly property real gridPointSphereScale: 0.25
    readonly property real defaultStoneModelScale: 0.70
    readonly property real minStoneModelScale: 0.30
    readonly property real defaultStoneScale: defaultStoneModelScale * quick3DPrimitiveDiameter / spacing
    readonly property real minStoneScale: minStoneModelScale * quick3DPrimitiveDiameter / spacing
    readonly property real defaultGridOpacity: 0.30
    readonly property real defaultHiddenLayerTransparency: 0.86
    readonly property bool defaultHideGridLines: false
    readonly property bool defaultHideGridPoints: false
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

    onUseFlattened2DCoordinatesChanged: {
        clearEngineCandidates()
        scheduleAutoAnalysis()
    }
    onKomiChanged: scheduleAutoAnalysis()
    onMoveClickConfirmChanged: {
        if (!moveClickConfirm)
            selectedPointLocked = false
    }
    onStoneColorModeChanged: {
        currentPlayer = nextPlayerFromMode()
        rebuildPointLegality()
        scheduleAutoAnalysis()
    }
    onCameraYawChanged: scheduleAxisCameraRefresh()
    onCameraPitchChanged: scheduleAxisCameraRefresh()

    function clamp(value, low, high) {
        return Math.max(low, Math.min(high, value))
    }

    function adjustKomi(delta) {
        komi = Math.round((komi + delta) * 2) / 2
    }

    function focusBoardInput() {
        if (inputLayer)
            inputLayer.forceActiveFocus()
    }

    function setViewNavigationKeysBlocked(blocked) {
        viewNavigationKeysBlocked = blocked
        if (blocked && inputLayer)
            inputLayer.clearHeldNavigationKeys()
    }

    function isViewNavigationKey(key) {
        return key === Qt.Key_W || key === Qt.Key_A || key === Qt.Key_S || key === Qt.Key_D
               || key === Qt.Key_Q || key === Qt.Key_E
               || key === Qt.Key_R || key === Qt.Key_F
               || key === Qt.Key_Left || key === Qt.Key_Right
               || key === Qt.Key_X || key === Qt.Key_Z
               || key === Qt.Key_Space
    }

    function requestQuit() {
        root.close()
    }

    function closeWithoutSaving() {
        suppressUnsavedPrompt = true
        root.close()
    }

    function openBoardSizeDialog() {
        boardSizeDialog.showForCurrentBoard()
    }

    function itemContainsInputPoint(item, sourceItem, x, y) {
        if (!item || !sourceItem || !item.visible || item.width <= 0 || item.height <= 0)
            return false

        var point = item.mapFromItem(sourceItem, x, y)
        return point.x >= 0 && point.x <= item.width && point.y >= 0 && point.y <= item.height
    }

    function boardInputBlocked(sourceItem, x, y) {
        return itemContainsInputPoint(analysisToolbar, sourceItem, x, y)
               || itemContainsInputPoint(coordinateInputPanel, sourceItem, x, y)
               || itemContainsInputPoint(axisGizmo, sourceItem, x, y)
               || itemContainsInputPoint(infoPanel, sourceItem, x, y)
               || itemContainsInputPoint(branchPanel, sourceItem, x, y)
               || itemContainsInputPoint(visualPanel, sourceItem, x, y)
               || itemContainsInputPoint(clipPanel, sourceItem, x, y)
               || itemContainsInputPoint(commandToolbar, sourceItem, x, y)
    }

    function trText(key) {
        language
        var table = translations[language] || translations.zh
        return table[key] || key
    }

    function windowTitleText() {
        return trText("windowTitle") + " " + boardDimensionsText()
    }

    function keyFor(x, y, z) {
        return x + "," + y + "," + z
    }

    function pointPosition(x, y, z) {
        var centerX = (boardSizeX - 1) / 2
        var centerY = (boardSizeY - 1) / 2
        var centerZ = (boardSizeZ - 1) / 2
        return Qt.vector3d((x - centerX) * spacing, (y - centerY) * spacing, (z - centerZ) * spacing)
    }

    function boardDimensionsText() {
        return boardSizeX + "x" + boardSizeY + "x" + boardSizeZ
    }

    function boardPointCount() {
        return boardSizeX * boardSizeY * boardSizeZ
    }

    function flattened2DBoardWidth() {
        return boardSizeX * Math.min(boardSizeZ, 4)
    }

    function flattened2DBoardHeight() {
        return boardSizeY * Math.ceil(boardSizeZ / 4)
    }

    function flattened2DCoordinate(x, y, z) {
        return {
            "x": x + (z % 4) * boardSizeX,
            "y": y + Math.floor(z / 4) * boardSizeY
        }
    }

    function unflattened3DCoordinate(x, y) {
        var layerColumn = Math.floor(x / boardSizeX)
        var layerRow = Math.floor(y / boardSizeY)
        var z = layerRow * 4 + layerColumn
        return {
            "x": x % boardSizeX,
            "y": y % boardSizeY,
            "z": z
        }
    }

    function gtpAlphabetIndex(text) {
        var alphabet = "ABCDEFGHJKLMNOPQRSTUVWXYZ"
        var value = 0
        for (var i = 0; i < text.length; ++i) {
            var digit = alphabet.indexOf(text.charAt(i).toUpperCase())
            if (digit < 0)
                return -1
            if (text.length === 2)
                value = i === 0 ? (digit + 1) * alphabet.length : value + digit
            else
                value = value * alphabet.length + digit
        }
        return value
    }

    function gtpCoordinateName(x, y, width, height) {
        if (width > 25 || height > 25)
            return "(" + x + "," + y + ")"
        var alphabet = "ABCDEFGHJKLMNOPQRSTUVWXYZ"
        return alphabet.charAt(x) + String(height - y)
    }

    function parseGtpCoordinateName(text, width, height) {
        var value = String(text).trim()
        if (value.toLowerCase() === "pass" || value.toLowerCase() === "resign")
            return null

        var numeric = value.match(/^\((\d+),(\d+)\)$/)
        if (numeric)
            return { "x": parseInt(numeric[1], 10), "y": parseInt(numeric[2], 10) }

        var named = value.match(/^([A-HJ-Z]+)(\d+)$/i)
        if (!named)
            return null

        var x = gtpAlphabetIndex(named[1])
        var y = height - parseInt(named[2], 10)
        if (x < 0 || y < 0 || x >= width || y >= height)
            return null
        return { "x": x, "y": y }
    }

    function engineCoordinateForNode(node) {
        if (!node)
            return ""
        if (useFlattened2DCoordinates) {
            var flat = flattened2DCoordinate(node.x, node.y, node.z)
            return gtpCoordinateName(flat.x, flat.y, flattened2DBoardWidth(), flattened2DBoardHeight())
        }
        return sgfCoordinateText(node.x, node.y, node.z)
    }

    function parseEngineCoordinate(text) {
        if (useFlattened2DCoordinates) {
            var flat = parseGtpCoordinateName(text, flattened2DBoardWidth(), flattened2DBoardHeight())
            if (!flat)
                return null
            var point = unflattened3DCoordinate(flat.x, flat.y)
            if (point.x < 0 || point.x >= boardSizeX
                    || point.y < 0 || point.y >= boardSizeY
                    || point.z < 0 || point.z >= boardSizeZ)
                return null
            return point
        }

        var value = String(text).trim()
        var sgf = value.match(/^([a-z])([a-z])([a-z])$/i)
        if (sgf) {
            var base = "a".charCodeAt(0)
            return {
                "x": sgf[1].toLowerCase().charCodeAt(0) - base,
                "y": sgf[2].toLowerCase().charCodeAt(0) - base,
                "z": sgf[3].toLowerCase().charCodeAt(0) - base
            }
        }

        var label = value.match(/^([A-Z])([a-z])(\d+)$/)
        if (!label)
            return null
        return {
            "x": label[1].charCodeAt(0) - "A".charCodeAt(0),
            "y": label[2].charCodeAt(0) - "a".charCodeAt(0),
            "z": parseInt(label[3], 10) - 1
        }
    }

    function candidateWinrateText(candidate) {
        if (!candidate || candidate.winrate === undefined)
            return ""
        return Math.round(candidate.winrate) + "%"
    }

    function rebuildEngineCandidateItems() {
        var items = []
        if (engineCandidates.length > 0) {
            var candidate = engineCandidates[0]
            var point = parseEngineCoordinate(candidate.move)
            if (point && stoneAt(point.x, point.y, point.z) === 0) {
                items.push({
                    "x": point.x,
                    "y": point.y,
                    "z": point.z,
                    "key": keyFor(point.x, point.y, point.z),
                    "position": pointPosition(point.x, point.y, point.z),
                    "move": candidate.move,
                    "order": candidate.order,
                    "winrate": candidate.winrate,
                    "winrateText": candidateWinrateText(candidate)
                })
            }
        }
        engineCandidateItems = items
    }

    function clearEngineCandidates() {
        engineCandidates = []
        engineCandidateItems = []
        engineCandidateRevision += 1
        if (engineController)
            engineController.clearCandidates()
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

    function gameRuleText() {
        return gameRuleMode === gameRuleGo ? trText("gameRuleGo") : trText("gameRuleGomoku")
    }

    function requestRuleModeChange(mode) {
        if (mode === gameRuleMode)
            return

        pendingRuleMode = mode
        if (gameDirty) {
            ruleChangeSaveDialog.open()
            return
        }

        pendingRuleMode = -1
        applyRuleModeChange(mode)
    }

    function applyRuleModeChange(mode) {
        if (mode !== gameRuleGo && mode !== gameRuleGomoku)
            return

        gameRuleMode = mode
        clearHover(true)
        resetGameTree()
        gameDirty = false
        statusMode = "message"
        statusMessage = trText("ruleChanged") + ": " + gameRuleText()
        focusBoardInput()
    }

    function rebuildBoardGeometry() {
        points = buildPoints()
        mainAxisLabels = buildMainAxisLabels()
    }

    function setBoardDimensions(xSize, ySize, zSize, markDirty) {
        var nextX = Math.round(clamp(xSize, minBoardSize, maxBoardSize))
        var nextY = Math.round(clamp(ySize, minBoardSize, maxBoardSize))
        var nextZ = Math.round(clamp(zSize, minBoardSize, maxBoardSize))
        if (nextX === boardSizeX && nextY === boardSizeY && nextZ === boardSizeZ)
            return

        boardSizeX = nextX
        boardSizeY = nextY
        boardSizeZ = nextZ
        resetClipCounts()
        clearHover()
        resetGameTree()
        rebuildBoardGeometry()
        resetCamera()
        setSelectedPoint(coordinateInputX, coordinateInputY, coordinateInputZ)
        if (markDirty !== false)
            gameDirty = true
    }

    function setBoardSize(size, markDirty) {
        setBoardDimensions(size, size, size, markDirty)
    }

    function resetBoardSize() {
        setBoardDimensions(defaultBoardSizeX, defaultBoardSizeY, defaultBoardSizeZ)
    }

    function boardSizeForAxis(axis) {
        if (axis === 0 || axis === "X" || axis === "+X" || axis === "-X")
            return boardSizeX
        if (axis === 1 || axis === "Y" || axis === "+Y" || axis === "-Y")
            return boardSizeY
        return boardSizeZ
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

    function gridFixed1Count(axis) {
        return axis === 0 ? boardSizeY : boardSizeX
    }

    function gridFixed2Count(axis) {
        return axis === 2 ? boardSizeY : boardSizeZ
    }

    function gridLinePositions(axis) {
        var data = []
        var axisSize = boardSizeForAxis(axis)
        for (var fixed1 = 0; fixed1 < gridFixed1Count(axis); ++fixed1) {
            for (var fixed2 = 0; fixed2 < gridFixed2Count(axis); ++fixed2) {
                for (var i = 0; i < axisSize - 1; ++i)
                    appendGridLineSegment(data, axis, i, i + 1, fixed1, fixed2)
            }
        }
        return data
    }

    function gridLineColors(axis) {
        var data = []
        var rgb = gridLineRgb(axis)
        var axisSize = boardSizeForAxis(axis)
        for (var fixed1 = 0; fixed1 < gridFixed1Count(axis); ++fixed1) {
            for (var fixed2 = 0; fixed2 < gridFixed2Count(axis); ++fixed2) {
                for (var i = 0; i < axisSize - 1; ++i)
                    appendGridLineColor(data, rgb, gridLineSegmentOpacity(axis, i, i + 1, fixed1, fixed2, false))
            }
        }
        return data
    }

    function appendHoverGridRod(data, axis, a, b, fixed1, fixed2) {
        var start = axis === 0 ? pointPosition(a, fixed1, fixed2)
                  : axis === 1 ? pointPosition(fixed1, a, fixed2)
                               : pointPosition(fixed1, fixed2, a)
        var end = axis === 0 ? pointPosition(b, fixed1, fixed2)
                : axis === 1 ? pointPosition(fixed1, b, fixed2)
                             : pointPosition(fixed1, fixed2, b)
        var lengthScale = spacing / quick3DPrimitiveDiameter
        var thicknessScale = spacing * 0.075 / quick3DPrimitiveDiameter
        data.push({
            "position": Qt.vector3d((start.x + end.x) * 0.5,
                                    (start.y + end.y) * 0.5,
                                    (start.z + end.z) * 0.5),
            "scale": axis === 0 ? Qt.vector3d(lengthScale, thicknessScale, thicknessScale)
                     : axis === 1 ? Qt.vector3d(thicknessScale, lengthScale, thicknessScale)
                                  : Qt.vector3d(thicknessScale, thicknessScale, lengthScale),
            "opacity": gridLineSegmentOpacity(axis, a, b, fixed1, fixed2, true),
            "color": selectedPointColor()
        })
    }

    function hoverGridRods() {
        legalityRevision
        var data = []
        if (hoverKey === "" || hideGridLines)
            return data

        for (var axis = 0; axis < 3; ++axis) {
            var fixed1 = axis === 0 ? hoverY : hoverX
            var fixed2 = axis === 2 ? hoverY : hoverZ
            for (var i = 0; i < boardSizeForAxis(axis) - 1; ++i)
                appendHoverGridRod(data, axis, i, i + 1, fixed1, fixed2)
        }
        return data
    }

    function emptyPointOpacity(clipped, hovered) {
        if (hovered)
            return 0.42
        if (hideGridPoints)
            return 0
        return clipped ? gridOpacity * hiddenLayerOpacity() : gridOpacity
    }

    function isClipped(x, y, z) {
        clipRevision
        return x < clipNegX || x >= boardSizeX - clipPosX
               || y < clipNegY || y >= boardSizeY - clipPosY
               || z < clipNegZ || z >= boardSizeZ - clipPosZ
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
        var count = clamp(value, 0, boardSizeForAxis(axisName))
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
        for (var y = 0; y < boardSizeY; ++y) {
            for (var z = 0; z < boardSizeZ; ++z) {
                for (var x = 0; x < boardSizeX; ++x) {
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

    function nextPlayerFromMode() {
        if (stoneColorMode === stoneColorModeBlack)
            return 1
        if (stoneColorMode === stoneColorModeWhite)
            return 2

        var node = currentNode()
        if (node && node.player === 1)
            return 2
        if (node && node.player === 2)
            return 1
        return 1
    }

    function neighborOffsets() {
        return [
            { "dx": 1, "dy": 0, "dz": 0 },
            { "dx": -1, "dy": 0, "dz": 0 },
            { "dx": 0, "dy": 1, "dz": 0 },
            { "dx": 0, "dy": -1, "dz": 0 },
            { "dx": 0, "dy": 0, "dz": 1 },
            { "dx": 0, "dy": 0, "dz": -1 }
        ]
    }

    function gomokuDirections() {
        return [
            { "dx": 1, "dy": 0, "dz": 0 },
            { "dx": 0, "dy": 1, "dz": 0 },
            { "dx": 0, "dy": 0, "dz": 1 },
            { "dx": 1, "dy": 1, "dz": 0 },
            { "dx": 1, "dy": -1, "dz": 0 },
            { "dx": 1, "dy": 0, "dz": 1 },
            { "dx": 1, "dy": 0, "dz": -1 },
            { "dx": 0, "dy": 1, "dz": 1 },
            { "dx": 0, "dy": 1, "dz": -1 },
            { "dx": 1, "dy": 1, "dz": 1 },
            { "dx": 1, "dy": 1, "dz": -1 },
            { "dx": 1, "dy": -1, "dz": 1 },
            { "dx": 1, "dy": -1, "dz": -1 }
        ]
    }

    function stoneMapDataAt(map, x, y, z) {
        var value = map[keyFor(x, y, z)]
        return value === undefined ? null : value
    }

    function stoneMapPlayerAt(map, x, y, z) {
        var value = stoneMapDataAt(map, x, y, z)
        return value ? value.player : 0
    }

    function pointLegalInMap(map, x, y, z, player) {
        if (!pointInBoard(x, y, z) || stoneMapPlayerAt(map, x, y, z) !== 0)
            return false

        if (gameRuleMode !== gameRuleGo)
            return true

        var item = {
            "x": x,
            "y": y,
            "z": z,
            "key": keyFor(x, y, z),
            "player": player,
            "moveNumber": 0,
            "nodeId": -1,
            "position": pointPosition(x, y, z)
        }
        return simulateGoMoveOnMap(cloneStoneMap(map), item).ok
    }

    function buildPointLegalityMap(map, player) {
        var result = ({})
        for (var y = 0; y < boardSizeY; ++y) {
            for (var z = 0; z < boardSizeZ; ++z) {
                for (var x = 0; x < boardSizeX; ++x)
                    result[keyFor(x, y, z)] = pointLegalInMap(map, x, y, z, player)
            }
        }
        return result
    }

    function rebuildPointLegality() {
        legalPointMap = buildPointLegalityMap(stones, currentPlayer)
        legalityRevision += 1
    }

    function pointIsLegal(x, y, z) {
        legalityRevision
        if (!pointInBoard(x, y, z))
            return false
        return legalPointMap[keyFor(x, y, z)] === true
    }

    function selectedPointLegal() {
        legalityRevision
        hoverKey
        if (hoverKey === "")
            return false
        return pointIsLegal(hoverX, hoverY, hoverZ)
    }

    function selectedPointPlayable() {
        return selectedPointLegal() && !isClipped(hoverX, hoverY, hoverZ)
    }

    function selectedPointColor() {
        return selectedPointLegal() ? "#2fb97f" : "#e3342f"
    }

    function cloneStoneMap(map) {
        var nextMap = ({})
        for (var key in map) {
            var value = map[key]
            nextMap[key] = {
                "x": value.x,
                "y": value.y,
                "z": value.z,
                "key": value.key,
                "player": value.player,
                "moveNumber": value.moveNumber,
                "nodeId": value.nodeId,
                "position": value.position
            }
        }
        return nextMap
    }

    function makeStoneItemFromNode(node) {
        return {
            "x": node.x,
            "y": node.y,
            "z": node.z,
            "key": node.key,
            "player": node.player,
            "moveNumber": node.moveNumber,
            "nodeId": node.id,
            "position": pointPosition(node.x, node.y, node.z)
        }
    }

    function collectGroupInMap(map, x, y, z, visited) {
        var start = stoneMapDataAt(map, x, y, z)
        if (!start)
            return []

        var group = []
        var stack = [start]
        var player = start.player
        var offsets = neighborOffsets()
        while (stack.length > 0) {
            var stone = stack.pop()
            if (visited[stone.key])
                continue

            visited[stone.key] = true
            group.push(stone)
            for (var i = 0; i < offsets.length; ++i) {
                var nx = stone.x + offsets[i].dx
                var ny = stone.y + offsets[i].dy
                var nz = stone.z + offsets[i].dz
                if (!pointInBoard(nx, ny, nz))
                    continue

                var neighbor = stoneMapDataAt(map, nx, ny, nz)
                if (neighbor && neighbor.player === player && !visited[neighbor.key])
                    stack.push(neighbor)
            }
        }
        return group
    }

    function groupHasLibertyInMap(map, group) {
        var offsets = neighborOffsets()
        for (var i = 0; i < group.length; ++i) {
            var stone = group[i]
            for (var n = 0; n < offsets.length; ++n) {
                var nx = stone.x + offsets[n].dx
                var ny = stone.y + offsets[n].dy
                var nz = stone.z + offsets[n].dz
                if (pointInBoard(nx, ny, nz) && stoneMapPlayerAt(map, nx, ny, nz) === 0)
                    return true
            }
        }
        return false
    }

    function removeGroupFromMap(map, group) {
        for (var i = 0; i < group.length; ++i)
            delete map[group[i].key]
    }

    function simulateGoMoveOnMap(map, stoneItem) {
        if (map[stoneItem.key] !== undefined)
            return { "ok": false, "captured": 0, "reason": "occupied" }

        map[stoneItem.key] = stoneItem

        var captured = 0
        var opponent = stoneItem.player === 1 ? 2 : 1
        var offsets = neighborOffsets()
        var checked = ({})
        for (var i = 0; i < offsets.length; ++i) {
            var nx = stoneItem.x + offsets[i].dx
            var ny = stoneItem.y + offsets[i].dy
            var nz = stoneItem.z + offsets[i].dz
            var neighbor = pointInBoard(nx, ny, nz) ? stoneMapDataAt(map, nx, ny, nz) : null
            if (!neighbor || neighbor.player !== opponent || checked[neighbor.key])
                continue

            var visited = ({})
            var group = collectGroupInMap(map, nx, ny, nz, visited)
            for (var g = 0; g < group.length; ++g)
                checked[group[g].key] = true
            if (!groupHasLibertyInMap(map, group)) {
                captured += group.length
                removeGroupFromMap(map, group)
            }
        }

        var ownGroup = collectGroupInMap(map, stoneItem.x, stoneItem.y, stoneItem.z, ({}))
        if (!groupHasLibertyInMap(map, ownGroup)) {
            removeGroupFromMap(map, ownGroup)
            return { "ok": false, "captured": captured, "reason": "suicide" }
        }

        return { "ok": true, "captured": captured, "reason": "" }
    }

    function previewRuleMove(x, y, z, player, moveNumber, nodeId) {
        var item = {
            "x": x,
            "y": y,
            "z": z,
            "key": keyFor(x, y, z),
            "player": player,
            "moveNumber": moveNumber,
            "nodeId": nodeId,
            "position": pointPosition(x, y, z)
        }

        if (gameRuleMode !== gameRuleGo)
            return { "ok": true, "captured": 0, "reason": "" }

        return simulateGoMoveOnMap(cloneStoneMap(stones), item)
    }

    function applyNodeToPositionMap(map, node) {
        var item = makeStoneItemFromNode(node)
        if (gameRuleMode === gameRuleGo)
            return simulateGoMoveOnMap(map, item)

        if (map[item.key] !== undefined)
            return { "ok": false, "captured": 0, "reason": "occupied" }

        map[item.key] = item
        return { "ok": true, "captured": 0, "reason": "" }
    }

    function stoneItemsFromMap(map) {
        var items = []
        for (var key in map)
            items.push(map[key])
        items.sort(function(a, b) { return a.moveNumber - b.moveNumber })
        return items
    }

    function gomokuWinLineRotation(dx, dy, dz) {
        var yAxis = normalizedVector(Qt.vector3d(dx, dy, dz), Qt.vector3d(0, 1, 0))
        var helper = Math.abs(yAxis.y) < 0.9 ? Qt.vector3d(0, 1, 0) : Qt.vector3d(1, 0, 0)
        var xAxis = normalizedVector(crossVector(helper, yAxis), Qt.vector3d(1, 0, 0))
        var zAxis = normalizedVector(crossVector(xAxis, yAxis), Qt.vector3d(0, 0, 1))
        return quaternionFromBasis(xAxis, yAxis, zAxis)
    }

    function buildGomokuWinLineItems(map) {
        if (gameRuleMode !== gameRuleGomoku)
            return []

        var lines = []
        var directions = gomokuDirections()
        for (var key in map) {
            var stone = map[key]
            for (var d = 0; d < directions.length; ++d) {
                var direction = directions[d]
                var px = stone.x - direction.dx
                var py = stone.y - direction.dy
                var pz = stone.z - direction.dz
                if (pointInBoard(px, py, pz) && stoneMapPlayerAt(map, px, py, pz) === stone.player)
                    continue

                var run = []
                var x = stone.x
                var y = stone.y
                var z = stone.z
                while (pointInBoard(x, y, z) && stoneMapPlayerAt(map, x, y, z) === stone.player) {
                    run.push(stoneMapDataAt(map, x, y, z))
                    x += direction.dx
                    y += direction.dy
                    z += direction.dz
                }

                if (run.length < 5)
                    continue

                var start = run[0]
                var end = run[run.length - 1]
                var startPos = pointPosition(start.x, start.y, start.z)
                var endPos = pointPosition(end.x, end.y, end.z)
                var dxWorld = endPos.x - startPos.x
                var dyWorld = endPos.y - startPos.y
                var dzWorld = endPos.z - startPos.z
                var length = Math.sqrt(dxWorld * dxWorld + dyWorld * dyWorld + dzWorld * dzWorld) + spacing * 0.62
                lines.push({
                    "position": Qt.vector3d((startPos.x + endPos.x) * 0.5,
                                            (startPos.y + endPos.y) * 0.5,
                                            (startPos.z + endPos.z) * 0.5),
                    "rotation": gomokuWinLineRotation(direction.dx, direction.dy, direction.dz),
                    "scale": Qt.vector3d(spacing * 0.16 / quick3DPrimitiveDiameter,
                                         length / quick3DPrimitiveDiameter,
                                         spacing * 0.16 / quick3DPrimitiveDiameter),
                    "startX": start.x,
                    "startY": start.y,
                    "startZ": start.z,
                    "endX": end.x,
                    "endY": end.y,
                    "endZ": end.z,
                    "player": stone.player
                })
            }
        }
        return lines
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
        var blackCaptureCount = 0
        var whiteCaptureCount = 0
        for (var i = 0; i < path.length; ++i) {
            var result = applyNodeToPositionMap(nextStones, path[i])
            if (result.ok && result.captured > 0) {
                if (path[i].player === 1)
                    blackCaptureCount += result.captured
                else
                    whiteCaptureCount += result.captured
            }
        }

        stones = nextStones
        stoneItems = stoneItemsFromMap(nextStones)
        blackCaptures = blackCaptureCount
        whiteCaptures = whiteCaptureCount
        gomokuWinLineItems = buildGomokuWinLineItems(nextStones)
        stoneCount = path.length
        currentPlayer = nextPlayerFromMode()
        legalPointMap = buildPointLegalityMap(nextStones, currentPlayer)
        legalityRevision += 1
        boardRevision += 1
        statusMode = "turn"
        clearEngineCandidates()
        scheduleAutoAnalysis()
    }

    function resetGameTree() {
        stones = ({})
        stoneItems = []
        blackCaptures = 0
        whiteCaptures = 0
        gomokuWinLineItems = []
        legalPointMap = ({})
        gameNodes = [{ "id": 0, "parent": -1, "children": [], "x": -1, "y": -1, "z": -1,
                       "key": "", "player": 0, "moveNumber": 0 }]
        currentNodeId = 0
        nextNodeId = 1
        stoneCount = 0
        currentPlayer = nextPlayerFromMode()
        legalPointMap = buildPointLegalityMap(stones, currentPlayer)
        legalityRevision += 1
        boardRevision += 1
        statusMode = "turn"
        clearEngineCandidates()
        rebuildTreeLayout()
        scheduleAutoAnalysis()
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

        var movePreview = previewRuleMove(x, y, z, currentPlayer, parent.moveNumber + 1, nextNodeId)
        if (!movePreview.ok) {
            statusMode = "message"
            statusMessage = movePreview.reason === "suicide"
                            ? trText("suicideMove") + ": " + coordinateText(x, y, z)
                            : trText("occupied") + ": " + coordinateText(x, y, z)
            return
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
        gameDirty = true
        clearHover(true)
        if (gameRuleMode === gameRuleGo && movePreview.captured > 0) {
            statusMode = "message"
            statusMessage = playerName(node.player) + " " + trText("captureMessage") + " " + movePreview.captured
        }
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
        gameDirty = true
    }

    function clearBoard() {
        var changed = hasAnyMoves()
        resetGameTree()
        if (changed)
            gameDirty = true
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
        var target = Math.round(clamp(isNaN(value) ? 0 : value, 0, boardPointCount()))
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
            gameDirty = true
        }
    }

    function engineBoardSizeCommands() {
        if (useFlattened2DCoordinates) {
            var flatWidth = flattened2DBoardWidth()
            var flatHeight = flattened2DBoardHeight()
            if (flatWidth === flatHeight)
                return [ "boardsize " + flatWidth ]
            return [ "rectangular_boardsize " + flatWidth + " " + flatHeight ]
        }
        return [ "boardsize3d " + boardSizeX + " " + boardSizeY + " " + boardSizeZ ]
    }

    function engineSyncCommands() {
        var commands = [ "stop" ]
        commands = commands.concat(engineBoardSizeCommands())
        commands.push("komi " + Number(komi).toFixed(1))
        commands.push("clear_board")

        var path = nodePath(currentNodeId)
        for (var i = 0; i < path.length; ++i) {
            var node = path[i]
            var color = node.player === 1 ? "B" : "W"
            var commandName = useFlattened2DCoordinates ? "play" : "play3d"
            commands.push(commandName + " " + color + " " + engineCoordinateForNode(node))
        }

        return commands
    }

    function scheduleAutoAnalysis() {
        if (!appReady || !engineAutoAnalyze || enginePaused)
            return
        autoAnalyzeTimer.restart()
    }

    function requestEngineAnalysis(force) {
        if (!engineController)
            return
        if (enginePaused && !force)
            return

        if (force)
            enginePaused = false
        engineLoading = !engineController.running

        engineController.requestAnalysis(
            engineSyncCommands(),
            useFlattened2DCoordinates ? "kata-analyze 50" : "kata-analyze3d 50")
        statusMode = "message"
        statusMessage = trText("engineAnalyzeRequested")
    }

    function pauseEngineAnalysis() {
        enginePaused = true
        engineLoading = false
        if (engineController && engineController.running)
            engineController.sendCommand("stop")
        statusMode = "message"
        statusMessage = trText("enginePaused")
    }

    function resumeEngineAnalysis() {
        enginePaused = false
        requestEngineAnalysis(true)
    }

    function toggleEnginePause() {
        if (enginePaused)
            resumeEngineAnalysis()
        else
            pauseEngineAnalysis()
    }

    function playBestEngineMove() {
        if (engineCandidateItems.length <= 0) {
            statusMode = "message"
            statusMessage = trText("engineNoCandidates")
            return
        }

        var best = engineCandidateItems[0]
        setSelectedPoint(best.x, best.y, best.z)
        placeStone(best.x, best.y, best.z)
    }

    function engineStatusText() {
        if (!engineController)
            return trText("engineNotStarted")
        if (enginePaused)
            return trText("enginePaused")
        if (engineLoading)
            return trText("engineLoading")
        var text = engineController.running ? trText("engineRunning") : trText("engineNotStarted")
        if (engineController.lastError && engineController.lastError.length > 0)
            text += " · " + engineController.lastError
        return text
    }

    function engineStateText() {
        if (enginePaused)
            return trText("enginePaused")
        if (engineController && engineController.lastError && engineController.lastError.length > 0)
            return engineStatusText()
        if (engineLoading || !engineController || !engineController.running)
            return trText("engineLoading")
        return trText("engineAutoAnalyzing") + " - " + engineCandidateSummaryText()
    }

    function engineDotColor() {
        if (enginePaused)
            return "#ff2424"
        if (engineLoading || !engineController || !engineController.running)
            return "#9ca4aa"
        return "#24c95a"
    }

    function engineCandidateSummaryText() {
        if (engineCandidateItems.length <= 0)
            return trText("engineNoCandidates")
        var best = engineCandidateItems[0]
        var suffix = best.winrateText.length > 0 ? " " + best.winrateText : ""
        return trText("engineBestMove") + ": " + coordinateText(best.x, best.y, best.z) + suffix
    }

    function toolbarActionEnabled(action) {
        if (action === "candidates" || action === "refresh")
            return true
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
        if (action === "candidates" || action === "refresh")
            requestEngineAnalysis(true)
        else if (action === "setMainBranch")
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

    function axisBillboardRotation() {
        axisCameraRevision
        cameraYaw
        cameraPitch
        return quaternionFromBasis(cameraRightVector(), cameraUpVector(), cameraBackVector())
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

    function parseCoordinateText(text) {
        var value = String(text).trim()
        var match = value.match(/^([A-Z])([a-z])(\d+)$/)
        if (!match)
            return null

        var point = {
            "x": match[1].charCodeAt(0) - "A".charCodeAt(0),
            "y": match[2].charCodeAt(0) - "a".charCodeAt(0),
            "z": parseInt(match[3], 10) - 1
        }

        if (!pointInBoard(point.x, point.y, point.z))
            return null
        return point
    }

    function pointInBoard(x, y, z) {
        return x >= 0 && x < boardSizeX
               && y >= 0 && y < boardSizeY
               && z >= 0 && z < boardSizeZ
    }

    function canPickPoint(x, y, z) {
        return pointInBoard(x, y, z) && stoneAt(x, y, z) === 0 && !isClipped(x, y, z)
    }

    function clampCoordinateInput(text, size) {
        var value = parseInt(String(text), 10)
        if (isNaN(value))
            value = 0
        return Math.round(clamp(value, 0, size - 1))
    }

    function clampOneBasedCoordinateInput(text, size) {
        var value = parseInt(String(text), 10)
        if (isNaN(value))
            value = 1
        return Math.round(clamp(value, 1, size))
    }

    function setSelectedPoint(x, y, z, locked) {
        var nextX = Math.round(clamp(x, 0, boardSizeX - 1))
        var nextY = Math.round(clamp(y, 0, boardSizeY - 1))
        var nextZ = Math.round(clamp(z, 0, boardSizeZ - 1))
        if (locked !== undefined)
            selectedPointLocked = locked
        coordinateInputX = nextX
        coordinateInputY = nextY
        coordinateInputZ = nextZ
        coordinateInputText = coordinateText(nextX, nextY, nextZ)
        hoverX = nextX
        hoverY = nextY
        hoverZ = nextZ
        hoverKey = keyFor(nextX, nextY, nextZ)
        if (!pointIsLegal(nextX, nextY, nextZ)) {
            statusMode = stoneAt(nextX, nextY, nextZ) !== 0 ? "occupied" : "message"
            statusMessage = trText("suicideMove") + ": " + coordinateText(nextX, nextY, nextZ)
            statusX = nextX
            statusY = nextY
            statusZ = nextZ
        } else if (statusMode === "occupied"
                   || (statusMode === "message" && statusMessage.indexOf(trText("suicideMove")) === 0)) {
            statusMode = "turn"
        }
        return true
    }

    function updateCoordinateInputText(locked) {
        setSelectedPoint(coordinateInputX, coordinateInputY, coordinateInputZ, locked)
    }

    function applyCoordinateInputText(text) {
        var point = parseCoordinateText(text)
        if (!point) {
            statusMode = "message"
            statusMessage = trText("coordinateInvalid") + ": " + text
            coordinateInputText = coordinateText(coordinateInputX, coordinateInputY, coordinateInputZ)
            return
        }
        setSelectedPoint(point.x, point.y, point.z, true)
    }

    function editCoordinateInputText(text) {
        coordinateInputText = text
        var point = parseCoordinateText(text)
        if (point)
            setSelectedPoint(point.x, point.y, point.z, true)
    }

    function playCoordinateInput() {
        if (!selectedPointPlayable())
            return
        placeStone(coordinateInputX, coordinateInputY, coordinateInputZ)
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
        var description = "Lizzie3D 3D " + gameRuleText()
                + ". Coordinates use SGF letters: aaa = (0,0,0), cde = (2,3,4)."
        var gameId = gameRuleMode === gameRuleGo ? 1 : 4
        var ruleName = gameRuleMode === gameRuleGo ? "Lizzie3D-Go" : "Lizzie3D-Gomoku"
        var text = "(;FF[4]GM[" + gameId + "]CA[UTF-8]AP[Lizzie3D]RU[" + sgfEscape(ruleName) + "]SZ["
                   + boardSizeX + ":" + boardSizeY + ":" + boardSizeZ + "]"
                   + "C[" + sgfEscape(description) + "]"
        var rootNode = nodeById(0)
        var children = rootNode ? (rootNode.children || []) : []
        for (var i = 0; i < children.length; ++i)
            text += sgfSubtree(children[i])
        return text + ")\n"
    }

    function openLoadSgfDialog() {
        loadSgfDialog.open()
    }

    function openSaveSgfDialog(closeAfterSave) {
        saveDialogClosesApp = closeAfterSave === true
        saveSgfDialog.currentFile = "lizzie3d-" + boardDimensionsText() + ".sgf"
        saveSgfDialog.open()
    }

    function saveSgfToFile(url) {
        var shouldClose = saveDialogClosesApp
        saveDialogClosesApp = false

        if (fileIo.writeTextFile(url, buildSgf())) {
            gameDirty = false
            statusMode = "message"
            statusMessage = trText("sgfSaved") + ": " + url
            if (pendingRuleMode >= 0) {
                var mode = pendingRuleMode
                pendingRuleMode = -1
                applyRuleModeChange(mode)
                return
            }
            if (shouldClose) {
                suppressUnsavedPrompt = true
                root.close()
                return
            }
        } else {
            pendingRuleMode = -1
            statusMode = "message"
            statusMessage = trText("sgfSaveFailed") + ": " + fileIo.lastError
        }
        focusBoardInput()
    }

    function firstSgfValue(properties, key) {
        var values = properties[key]
        return values && values.length > 0 ? values[0] : ""
    }

    function parseSgfBoardSize(value) {
        var parts = String(value).split(":")
        if (parts.length !== 1 && parts.length !== 3)
            return { "ok": false }

        var sizes = []
        for (var i = 0; i < parts.length; ++i) {
            var part = parseInt(parts[i], 10)
            if (isNaN(part))
                return { "ok": false }
            sizes.push(part)
        }

        if (parts.length === 1)
            return { "ok": true, "x": sizes[0], "y": sizes[0], "z": sizes[0] }
        return { "ok": true, "x": sizes[0], "y": sizes[1], "z": sizes[2] }
    }

    function parseSgf(text) {
        var sgf = String(text)
        var pos = 0
        var parsedBoardSizeX = minBoardSize
        var parsedBoardSizeY = minBoardSize
        var parsedBoardSizeZ = minBoardSize
        var parsedRuleMode = gameRuleMode
        var maxX = -1
        var maxY = -1
        var maxZ = -1
        var parseError = ""
        var nodes = [{ "id": 0, "parent": -1, "children": [], "x": -1, "y": -1, "z": -1,
                       "key": "", "player": 0, "moveNumber": 0 }]
        var nextId = 1

        function fail(message) {
            if (parseError === "")
                parseError = message
        }

        function skipWhitespace() {
            while (pos < sgf.length && /\s/.test(sgf.charAt(pos)))
                pos += 1
        }

        function isPropertyCharacter(ch) {
            return /[A-Za-z]/.test(ch)
        }

        function parseIdentifier() {
            var start = pos
            while (pos < sgf.length && isPropertyCharacter(sgf.charAt(pos)))
                pos += 1
            return sgf.substring(start, pos).toUpperCase()
        }

        function parsePropertyValue() {
            if (sgf.charAt(pos) !== "[") {
                fail("Expected property value.")
                return ""
            }

            pos += 1
            var value = ""
            while (pos < sgf.length) {
                var ch = sgf.charAt(pos)
                pos += 1

                if (ch === "\\") {
                    if (pos >= sgf.length)
                        break

                    var escaped = sgf.charAt(pos)
                    pos += 1
                    if (escaped === "\r") {
                        if (sgf.charAt(pos) === "\n")
                            pos += 1
                    } else if (escaped !== "\n") {
                        value += escaped
                    }
                } else if (ch === "]") {
                    return value
                } else {
                    value += ch
                }
            }

            fail("Unclosed property value.")
            return value
        }

        function parseNodeProperties() {
            var properties = ({})
            while (pos < sgf.length && parseError === "") {
                skipWhitespace()
                if (!isPropertyCharacter(sgf.charAt(pos)))
                    break

                var key = parseIdentifier()
                var values = []
                skipWhitespace()
                while (sgf.charAt(pos) === "[" && parseError === "") {
                    values.push(parsePropertyValue())
                    skipWhitespace()
                }

                if (values.length === 0) {
                    fail("Missing value for property " + key + ".")
                    return properties
                }

                properties[key] = (properties[key] || []).concat(values)
            }
            return properties
        }

        function updateSizeFromProperties(properties) {
            var sizeValue = firstSgfValue(properties, "SZ")
            if (sizeValue === "")
                return

            var size = parseSgfBoardSize(sizeValue)
            if (!size.ok || size.x < minBoardSize || size.x > maxBoardSize
                    || size.y < minBoardSize || size.y > maxBoardSize
                    || size.z < minBoardSize || size.z > maxBoardSize) {
                fail("Unsupported board size: " + sizeValue + ".")
                return
            }
            parsedBoardSizeX = size.x
            parsedBoardSizeY = size.y
            parsedBoardSizeZ = size.z
        }

        function updateRuleFromProperties(properties) {
            var gmValue = firstSgfValue(properties, "GM")
            var ruValue = firstSgfValue(properties, "RU").toUpperCase()
            if (ruValue.indexOf("GOMOKU") >= 0) {
                parsedRuleMode = gameRuleGomoku
                return
            }
            if (ruValue.indexOf("GO") >= 0) {
                parsedRuleMode = gameRuleGo
                return
            }

            if (gmValue === "1")
                parsedRuleMode = gameRuleGo
            else if (gmValue === "4")
                parsedRuleMode = gameRuleGomoku
        }

        function moveFromProperties(properties) {
            var value = ""
            var player = 0
            if (properties["B"] && properties["B"].length > 0) {
                value = properties["B"][0]
                player = 1
            } else if (properties["W"] && properties["W"].length > 0) {
                value = properties["W"][0]
                player = 2
            } else {
                return null
            }

            var coordinate = String(value).trim().toLowerCase()
            if (coordinate.length === 0)
                return null
            if (coordinate.length < 3) {
                fail("Expected 3D coordinate: " + value + ".")
                return null
            }

            var base = "a".charCodeAt(0)
            var x = coordinate.charCodeAt(0) - base
            var y = coordinate.charCodeAt(1) - base
            var z = coordinate.charCodeAt(2) - base
            if (x < 0 || y < 0 || z < 0 || x >= maxBoardSize || y >= maxBoardSize || z >= maxBoardSize) {
                fail("Invalid coordinate: " + value + ".")
                return null
            }

            maxX = Math.max(maxX, x)
            maxY = Math.max(maxY, y)
            maxZ = Math.max(maxZ, z)
            return { "x": x, "y": y, "z": z, "player": player }
        }

        function appendParsedNode(parentId, move) {
            var parent = nodes[parentId]
            if (!parent) {
                fail("Invalid SGF branch.")
                return parentId
            }

            var id = nextId
            nextId += 1
            var node = {
                "id": id,
                "parent": parentId,
                "children": [],
                "x": move.x,
                "y": move.y,
                "z": move.z,
                "key": keyFor(move.x, move.y, move.z),
                "player": move.player,
                "moveNumber": parent.moveNumber + 1
            }
            parent.children.push(id)
            nodes[id] = node
            return id
        }

        function parseGameTree(parentId) {
            skipWhitespace()
            if (sgf.charAt(pos) !== "(") {
                fail("Expected game tree.")
                return
            }

            pos += 1
            var currentParent = parentId
            while (pos < sgf.length && parseError === "") {
                skipWhitespace()
                var ch = sgf.charAt(pos)
                if (ch === ";") {
                    pos += 1
                    var properties = parseNodeProperties()
                    updateSizeFromProperties(properties)
                    updateRuleFromProperties(properties)
                    var move = moveFromProperties(properties)
                    if (move)
                        currentParent = appendParsedNode(currentParent, move)
                } else if (ch === "(") {
                    parseGameTree(currentParent)
                } else if (ch === ")") {
                    pos += 1
                    return
                } else if (ch === "") {
                    break
                } else {
                    pos += 1
                }
            }

            if (parseError === "")
                fail("Unclosed game tree.")
        }

        skipWhitespace()
        parseGameTree(0)
        if (parseError !== "")
            return { "ok": false, "error": parseError }

        var targetBoardSizeX = Math.max(parsedBoardSizeX, maxX + 1)
        var targetBoardSizeY = Math.max(parsedBoardSizeY, maxY + 1)
        var targetBoardSizeZ = Math.max(parsedBoardSizeZ, maxZ + 1)
        if (targetBoardSizeX < minBoardSize || targetBoardSizeX > maxBoardSize
                || targetBoardSizeY < minBoardSize || targetBoardSizeY > maxBoardSize
                || targetBoardSizeZ < minBoardSize || targetBoardSizeZ > maxBoardSize)
            return { "ok": false, "error": "Unsupported board size." }

        return { "ok": true, "nodes": nodes, "nextNodeId": nextId, "ruleMode": parsedRuleMode,
                 "boardSizeX": targetBoardSizeX, "boardSizeY": targetBoardSizeY, "boardSizeZ": targetBoardSizeZ }
    }

    function applyParsedSgf(parsed, url) {
        gameRuleMode = parsed.ruleMode === undefined ? gameRuleMode : parsed.ruleMode
        setBoardDimensions(parsed.boardSizeX, parsed.boardSizeY, parsed.boardSizeZ, false)
        resetClipCounts()
        clearHover()

        gameNodes = parsed.nodes
        nextNodeId = parsed.nextNodeId
        currentNodeId = 0
        rebuildPositionFromNode(currentNodeId)
        rebuildTreeLayout()
        gotoLastMove()
        gameDirty = false
        statusMode = "message"
        statusMessage = trText("sgfLoaded") + ": " + url
        focusBoardInput()
    }

    function loadSgfFromFile(url) {
        var text = fileIo.readTextFile(url)
        if (fileIo.lastError !== "") {
            statusMode = "message"
            statusMessage = trText("sgfLoadFailed") + ": " + fileIo.lastError
            focusBoardInput()
            return
        }

        var parsed = parseSgf(text)
        if (!parsed.ok) {
            statusMode = "message"
            statusMessage = trText("sgfLoadFailed") + ": " + parsed.error
            focusBoardInput()
            return
        }

        applyParsedSgf(parsed, url)
    }

    function mainAxisOrigin() {
        return pointPosition(-1, -1, -1)
    }

    function mainAxisLength(axis) {
        return spacing * (boardSizeForAxis(axis) + 1.15)
    }

    function buildMainAxisLabels() {
        var labels = []
        for (var i = 0; i < boardSizeX; ++i)
            labels.push({ "label": xCoordinateText(i), "x": i, "y": -1.34, "z": -1, "color": "#d84a43", "size": 0.48, "fontSize": 144 })

        for (var j = 0; j < boardSizeY; ++j)
            labels.push({ "label": yCoordinateText(j), "x": -1.34, "y": j, "z": -1, "color": "#39a66a", "size": 0.48, "fontSize": 144 })

        for (var k = 0; k < boardSizeZ; ++k)
            labels.push({ "label": zCoordinateText(k), "x": -1.34, "y": -1, "z": k, "color": "#3d73d8", "size": 0.48, "fontSize": 144 })

        labels.push({ "label": "X", "x": boardSizeX + 0.42, "y": -1, "z": -1, "color": "#d84a43", "size": 0.68, "fontSize": 164 })
        labels.push({ "label": "Y", "x": -1, "y": boardSizeY + 0.42, "z": -1, "color": "#39a66a", "size": 0.68, "fontSize": 164 })
        labels.push({ "label": "Z", "x": -1, "y": -1, "z": boardSizeZ + 0.42, "color": "#3d73d8", "size": 0.68, "fontSize": 164 })
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
        axisCameraRevision
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
        scheduleAxisCameraRefresh()
    }

    function rotateCameraByMouseDelta(deltaX, deltaY) {
        cameraYaw -= deltaX * 0.32
        cameraPitch = clamp(cameraPitch + deltaY * 0.22, -62, 78)
        refreshCamera()
    }

    function refreshSmallAxisCamera(camera, distance) {
        if (!camera)
            return

        var yaw = cameraYaw * Math.PI / 180
        var pitch = cameraPitch * Math.PI / 180
        var cp = Math.cos(pitch)
        camera.position = Qt.vector3d(
            distance * Math.sin(yaw) * cp,
            distance * Math.sin(pitch),
            distance * Math.cos(yaw) * cp)
        camera.lookAt(Qt.vector3d(0, 0, 0))
    }

    function refreshAxisCamera() {
        if (!axisGizmo || !clipPanel)
            return
        refreshSmallAxisCamera(axisGizmo.axisCamera, 320)
        refreshSmallAxisCamera(clipPanel.clipCamera, 260)
        axisCameraRevision += 1
    }

    function scheduleAxisCameraRefresh() {
        if (axisCameraRefreshPending)
            return

        axisCameraRefreshPending = true
        Qt.callLater(function() {
            axisCameraRefreshPending = false
            refreshAxisCamera()
        })
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
            cameraTarget.x - deltaX * amount * rightX - deltaY * amount * forwardX,
            cameraTarget.y,
            cameraTarget.z - deltaX * amount * rightZ - deltaY * amount * forwardZ)
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
            if (!canPickPoint(point.x, point.y, point.z))
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

    function clearHover(force) {
        if (selectedPointLocked && force !== true)
            return
        selectedPointLocked = false
        hoverX = -1
        hoverY = -1
        hoverZ = -1
        hoverKey = ""
    }

    function updateHover(x, y) {
        if (moveClickConfirm && selectedPointLocked)
            return

        var point = pointFromMouse(x, y)
        if (point) {
            setSelectedPoint(point.x, point.y, point.z)
        } else {
            clearHover()
        }
    }

    function placeFromMouse(x, y) {
        var point = pointFromMouse(x, y)
        if (point)
            placeStone(point.x, point.y, point.z)
    }

    function handleBoardClickFromMouse(x, y) {
        var point = pointFromMouse(x, y)
        if (!moveClickConfirm) {
            if (point)
                placeStone(point.x, point.y, point.z)
            return
        }

        if (!point) {
            clearHover(true)
            return
        }

        var nextKey = keyFor(point.x, point.y, point.z)
        var sameLockedPoint = selectedPointLocked && hoverKey === nextKey
        setSelectedPoint(point.x, point.y, point.z, true)
        if (sameLockedPoint) {
            if (!selectedPointPlayable())
                return
            selectedPointLocked = false
            placeStone(point.x, point.y, point.z)
        }
    }

    onClipRevisionChanged: {
        if (hoverKey !== "" && isClipped(hoverX, hoverY, hoverZ))
            clearHover(true)
        rebuildEngineCandidateItems()
    }

    Connections {
        target: engineController

        function onCandidatesChanged() {
            engineLoading = false
            engineCandidates = engineController.candidates
            engineCandidateRevision = engineController.candidateRevision
            rebuildEngineCandidateItems()
            if (engineCandidateItems.length > 0) {
                statusMode = "message"
                statusMessage = engineCandidateSummaryText()
            }
        }

        function onRunningChanged() {
            if (engineController.running) {
                engineLoading = false
            } else {
                engineLoading = false
                statusMode = "message"
                statusMessage = engineStatusText()
            }
        }

        function onLastErrorChanged() {
            if (engineController.lastError && engineController.lastError.length > 0) {
                engineLoading = false
                statusMode = "message"
                statusMessage = engineStatusText()
            }
        }
    }

    Component.onCompleted: {
        resetGameTree()
        rebuildBoardGeometry()
        resetCamera()
        setSelectedPoint(0, 0, 0)
        appReady = true
        scheduleAutoAnalysis()
    }

    AnalysisToolbar {
        id: analysisToolbar
        app: root
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

    CoordinateInputPanel {
        id: coordinateInputPanel
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
        visible: root.showAxisGizmoPanel
        enabled: root.showAxisGizmoPanel
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
