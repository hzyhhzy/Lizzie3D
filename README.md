# Lizzie3D

# [中文版](README.zh-CN.md)

Lizzie3D is an experimental Qt 6 desktop interface for 3D gomoku analysis. It focuses on a clear, navigable 3D board, branch-tree review, clipping tools, and future integration with external AI engines.

The project is still early. It can display and edit a 3D move tree, but it does not yet connect to an AI engine and does not implement win/loss rule adjudication.

![Lizzie3D main window](docs/images/lizzie3d-main-window.png)

## Features

- 3D board rendered with Qt Quick 3D.
- Configurable cuboid board dimensions from 1x1x1 to 19x19x19.
- Perspective camera with keyboard and mouse navigation.
- Camera-relative movement with `W/A/S/D` and `Q/E`.
- Layer clipping from six directions, with a rotatable six-axis clip control and keyboard shortcuts.
- Axis gizmo for aligning the camera; dragging inside either axis panel rotates the camera.
- Coordinate labels using `Aa1`-style 3D coordinates.
- Move placement, deletion, branch navigation, and main-branch selection.
- Lizzie-style branch tree panel.
- SGF import and export for the current game tree, including `SZ[x:y:z]` board dimensions.
- Stone move-number display modes.
- Chinese and English UI, with Chinese as the default language.
- Rendering optimizations for larger boards, including line meshes and math-based picking.

## Current Status

Implemented:

- 3D board interaction.
- Local game-tree editing.
- Basic SGF loading and saving.
- Bilingual UI text.
- Visual settings for stones, grid, clipping, lighting, and move numbers.

Not implemented yet:

- AI engine protocol integration.
- AI candidate-move display.
- Rule checking and win/loss detection.
- Full SGF compatibility testing with external tools.

## Requirements

- Windows.
- CMake 3.24 or newer.
- Visual Studio 2022 with the C++ desktop toolchain.
- Qt 6.8 or newer with Qt Quick and Qt Quick 3D.

The included scripts currently expect Qt at:

```powershell
.tools\Qt\6.10.3\msvc2022_64
```

If your Qt installation is somewhere else, edit `scripts/build.ps1` and update `$QtDir`, or use the manual CMake commands below.

## Build

Using the included script:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build.ps1
```

Run the app:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\run.ps1
```

Manual build example:

```powershell
cmake -S . -B build\lizzie3d -G "Visual Studio 17 2022" -A x64 -DCMAKE_PREFIX_PATH="C:\Qt\6.10.3\msvc2022_64"
cmake --build build\lizzie3d --config Release
```

For a redistributable build, run `windeployqt` against the built executable:

```powershell
C:\Qt\6.10.3\msvc2022_64\bin\windeployqt.exe --qmldir qml build\lizzie3d\Release\lizzie3d.exe
```

## Controls

- `W/S`: move the camera target up/down relative to the current camera view.
- `A/D`: move the camera target left/right relative to the current camera view.
- `Q/E`: move the camera forward/backward.
- `X/Z`: decrease/increase the clipping layers for the currently facing axis.
- Arrow left/right: rotate the camera horizontally.
- `Space`: reset the camera.
- `Ctrl+O`: open an SGF file.
- `Ctrl+S`: save the current game tree as SGF.
- `Ctrl+I`: set board dimensions.
- `Backspace`: delete the current node.
- `M`: cycle move-number display modes.
- Left-drag on the board or either six-axis panel: rotate the camera.
- Right-drag or middle-drag on the board: pan the camera target.
- Mouse wheel on the board: zoom.
- Mouse wheel over a clip-axis circle: adjust that clip direction.

## Repository Layout

```text
.
+-- CMakeLists.txt
+-- qml/
|   +-- Main.qml
|   +-- BoardScene.qml
|   +-- BoardInputLayer.qml
|   +-- BranchPanel.qml
|   +-- ClipPanel.qml
|   +-- ...
+-- scripts/
|   +-- build.ps1
|   +-- run.ps1
+-- src/
    +-- main.cpp
    +-- fileio.cpp
    +-- fileio.h
```

## Notes

Local toolchains, build outputs, logs, and deployed binaries are ignored by Git. The repository is intended to contain source code and project files only.

## License

Lizzie3D is licensed under the GNU General Public License version 3 only (`GPL-3.0-only`). See [LICENSE](LICENSE).
