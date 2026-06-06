import QtQuick

Item {
    id: inputLayer
    required property var app
    focus: true

    property real lastX: 0
    property real lastY: 0
    property bool moved: false
    property int pressedButton: 0
    property bool boardPressBlocked: false
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
                var step = Math.max(3.6, app.cameraDistance * 0.006)
                app.moveTarget(depthForward / length, screenRight / length, screenUp / length, step)
            }

            var turn = (inputLayer.turnRightHeld ? 1 : 0) - (inputLayer.turnLeftHeld ? 1 : 0)
            if (turn !== 0) {
                app.cameraYaw += turn * 1.15
                app.refreshCamera()
            }
        }
    }

    Keys.onPressed: function(event) {
        if (event.modifiers & Qt.ControlModifier)
            return

        if (app.viewNavigationKeysBlocked && app.isViewNavigationKey(event.key)) {
            inputLayer.clearHeldNavigationKeys()
            event.accepted = true
            return
        }

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
            inputLayer.upHeld = true
            event.accepted = true
        } else if (event.key === Qt.Key_E) {
            inputLayer.downHeld = true
            event.accepted = true
        } else if (event.key === Qt.Key_X) {
            if (!event.isAutoRepeat)
                app.focusCameraOnBestCandidate()
            event.accepted = true
        } else if (event.key === Qt.Key_Z) {
            if (!event.isAutoRepeat)
                app.focusCameraOnPreviousMove()
            event.accepted = true
        } else if (event.key === Qt.Key_Left) {
            inputLayer.turnLeftHeld = true
            event.accepted = true
        } else if (event.key === Qt.Key_Right) {
            inputLayer.turnRightHeld = true
            event.accepted = true
        } else if (event.key === Qt.Key_R) {
            if (!event.isAutoRepeat)
                app.adjustClip(app.frontFacingClipAxis(), 1)
            event.accepted = true
        } else if (event.key === Qt.Key_F) {
            if (!event.isAutoRepeat)
                app.adjustClip(app.frontFacingClipAxis(), -1)
            event.accepted = true
        } else if (event.key === Qt.Key_C) {
            if (!event.isAutoRepeat)
                app.resetCamera()
            event.accepted = true
        } else if (event.key === Qt.Key_V) {
            if (!event.isAutoRepeat)
                app.resetClipCounts()
            event.accepted = true
        } else if (event.key === Qt.Key_Space) {
            if (!event.isAutoRepeat)
                app.toggleEnginePause()
            event.accepted = true
        } else if (event.key === Qt.Key_Comma) {
            if (!event.isAutoRepeat)
                app.playBestEngineMove()
            event.accepted = true
        } else if (event.key === Qt.Key_P) {
            if (!event.isAutoRepeat)
                app.passMove()
            event.accepted = true
        } else if (event.key === Qt.Key_Backspace) {
            if (!event.isAutoRepeat)
                app.requestDeleteCurrentNode()
            event.accepted = true
        } else if (event.key === Qt.Key_M) {
            if (!event.isAutoRepeat)
                app.cycleMoveNumberDisplayMode()
            event.accepted = true
        } else if (event.key === Qt.Key_U) {
            if (!event.isAutoRepeat)
                app.openEngineCommunicationLog()
            event.accepted = true
        }
    }

    Keys.onReleased: function(event) {
        if (app.viewNavigationKeysBlocked && app.isViewNavigationKey(event.key)) {
            inputLayer.clearHeldNavigationKeys()
            event.accepted = true
            return
        }

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
        } else if (event.key === Qt.Key_Q) {
            inputLayer.upHeld = false
            event.accepted = true
        } else if (event.key === Qt.Key_E) {
            inputLayer.downHeld = false
            event.accepted = true
        } else if (event.key === Qt.Key_Left) {
            inputLayer.turnLeftHeld = false
            event.accepted = true
        } else if (event.key === Qt.Key_Right) {
            inputLayer.turnRightHeld = false
            event.accepted = true
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

        onPressed: function(mouse) {
            inputLayer.boardPressBlocked = app.boardInputBlocked(inputLayer, mouse.x, mouse.y)
            if (inputLayer.boardPressBlocked) {
                inputLayer.pressedButton = 0
                inputLayer.moved = false
                app.clearHover()
                mouse.accepted = true
                return
            }

            app.focusBoardInput()
            inputLayer.lastX = mouse.x
            inputLayer.lastY = mouse.y
            inputLayer.moved = false
            inputLayer.pressedButton = mouse.button
            mouse.accepted = true
        }

        onPositionChanged: function(mouse) {
            if (inputLayer.boardPressBlocked || (mouse.buttons === Qt.NoButton && app.boardInputBlocked(inputLayer, mouse.x, mouse.y))) {
                app.clearHover()
                mouse.accepted = true
                return
            }

            var dx = mouse.x - inputLayer.lastX
            var dy = mouse.y - inputLayer.lastY

            if (mouse.buttons & Qt.LeftButton) {
                if (Math.abs(dx) + Math.abs(dy) > 2)
                    inputLayer.moved = true
                app.rotateCameraByMouseDelta(dx, dy)
            } else if (mouse.buttons & Qt.MiddleButton) {
                if (Math.abs(dx) + Math.abs(dy) > 2)
                    inputLayer.moved = true
                app.panCamera(dx, dy)
            } else if (mouse.buttons & Qt.RightButton) {
                if (Math.abs(dx) + Math.abs(dy) > 2)
                    inputLayer.moved = true
            } else {
                app.updateHover(mouse.x, mouse.y)
            }

            inputLayer.lastX = mouse.x
            inputLayer.lastY = mouse.y
        }

        onReleased: function(mouse) {
            var skipHoverUpdate = false
            if (!inputLayer.boardPressBlocked && !inputLayer.moved) {
                if (inputLayer.pressedButton === Qt.LeftButton)
                    skipHoverUpdate = app.handleBoardClickFromMouse(mouse.x, mouse.y) === true
                else if (inputLayer.pressedButton === Qt.RightButton)
                    app.undoMove()
            }
            inputLayer.pressedButton = 0
            inputLayer.boardPressBlocked = false
            if (skipHoverUpdate)
                app.clearHover(true)
            else if (app.boardInputBlocked(inputLayer, mouse.x, mouse.y))
                app.clearHover()
            else
                app.updateHover(mouse.x, mouse.y)
            mouse.accepted = true
        }

        onExited: app.clearHover()

        onWheel: function(wheel) {
            if (app.boardInputBlocked(inputLayer, wheel.x, wheel.y)) {
                app.clearHover()
                wheel.accepted = true
                return
            }

            var factor = wheel.angleDelta.y > 0 ? 0.9 : 1.12
            app.cameraDistance = app.clamp(app.cameraDistance * factor, 220, Math.max(1900, app.defaultCameraDistance() * 2.2))
            app.refreshCamera()
            wheel.accepted = true
        }
    }
}
