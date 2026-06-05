$ErrorActionPreference = "Stop"

$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$QtDir = Join-Path $Root ".tools\Qt\6.10.3\msvc2022_64"
$SourceDir = $Root
$BuildDir = Join-Path $Root "build\lizzie3d"
$Exe = Join-Path $BuildDir "Release\lizzie3d.exe"

cmake -S $SourceDir -B $BuildDir -G "Visual Studio 17 2022" -A x64 -DCMAKE_PREFIX_PATH="$QtDir"
cmake --build $BuildDir --config Release
& (Join-Path $QtDir "bin\windeployqt.exe") --qmldir (Join-Path $SourceDir "qml") $Exe
