# Lizzie3D

# [中文版](README.zh-CN.md)

Lizzie3D is an early-stage Qt 6 desktop interface for 3D Go and 3D Gomoku. It provides a navigable 3D board, Lizzie-style review controls, SGF support, rule-aware move input, and experimental external AI engine analysis and play.

The project is still not complete. Engine integration, UI polish, SGF compatibility, and analysis workflows are actively evolving.

![Lizzie3D main window](docs/images/lizzie3d-main-window.png)

## Features

- 3D board rendered with Qt Quick 3D.
- Configurable cuboid board dimensions from 1x1x1 to 19x19x19.
- Perspective camera with mouse and keyboard navigation.
- Camera-relative movement with `W/A/S/D` and `Q/E`.
- Six-direction layer clipping with a rotatable "View and clip" control.
- Clickable clip-axis balls for camera alignment.
- Coordinate labels using `Aa1`-style 3D coordinates.
- 1-based coordinate input panel with step buttons and click-to-confirm move placement.
- Move placement, pass, deletion, branch navigation, main-branch selection, and full board clearing.
- Lizzie-style branch tree panel with horizontal and vertical scrolling.
- Lizzie-style left analysis panel with captures, engine state, a win-rate bar, win-rate history, and a candidate list.
- SGF import and export for the current game tree, including `SZ[x:y:z]` board dimensions.
- Bilingual UI, with Chinese as the default language.
- Rendering optimizations for larger boards, including line meshes and math-based picking.

## Rules

Lizzie3D currently supports two rule modes:

- **3D Go**: captures are handled with 6-neighbor liberties. Illegal self-capture points and simple-ko recaptures are marked red and cannot be played.
- **3D Gomoku**: five-in-a-row is detected in 3D directions and marked with a red pillar.

Changing rule mode clears the board. If the current game has unsaved changes, Lizzie3D asks whether to save the SGF first.

## Engine Analysis

Lizzie3D includes experimental GTP-style engine integration. It can start an external engine, replay the current position, request `kata-analyze 50`, and show candidate moves with win-rate labels. The left panel lists engine candidates and records a win-rate curve along the current game path.

The app also has early play modes: analysis, AI plays black, AI plays white, and AI self-play. AI play uses GTP `time_settings` plus `genmove`; after `genmove`, Lizzie3D treats the engine as having already played the returned move and keeps the engine board synchronized incrementally. If the board is edited during a pending `genmove`, Lizzie3D clears and replays the position before the next engine request.

For engines that expose a flattened 2D protocol for 3D boards, Lizzie3D can map a 3D board into 2D layers. Native 3D command names are also scaffolded for future engines.

This part is still rough and currently assumes a local engine command configured in the app.

The engine communication window can be opened from the menu or with `U`. It shows stdin/stdout/stderr in different colors and can send manual commands.

## Build

Requirements:

- Windows.
- CMake 3.24 or newer.
- Visual Studio 2022 with the C++ desktop toolchain.
- Qt 6.8 or newer with Qt Quick and Qt Quick 3D.

The included scripts currently expect Qt at:

```powershell
.tools\Qt\6.10.3\msvc2022_64
```

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
- `X/Z`: decrease/increase clip layers for the currently facing axis.
- Arrow left/right: rotate the camera horizontally.
- `Space`: pause/resume engine analysis, or stop an active AI game and return to analysis mode.
- `,`: play the current engine best move.
- `P`: pass.
- `U`: open the engine communication window.
- `Ctrl+O`: open an SGF file.
- `Ctrl+S`: save the current game tree as SGF.
- `Ctrl+I`: set board dimensions.
- `Backspace`: delete the current node.
- `M`: cycle move-number display modes.
- Left-drag on the board or clip/view panel: rotate the camera.
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
|   +-- AnalysisToolbar.qml
|   +-- CoordinateInputPanel.qml
|   +-- ...
+-- scripts/
|   +-- build.ps1
|   +-- run.ps1
+-- src/
    +-- main.cpp
    +-- fileio.cpp
    +-- enginecontroller.cpp
```

## License

Lizzie3D is licensed under the GNU General Public License version 3 only (`GPL-3.0-only`). See [LICENSE](LICENSE).
