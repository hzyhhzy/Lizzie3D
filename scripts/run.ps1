$ErrorActionPreference = "Stop"

$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$Exe = Join-Path $Root "build\lizzie3d\Release\lizzie3d.exe"

if (!(Test-Path -LiteralPath $Exe)) {
    throw "Lizzie3D executable is missing. Run scripts\build.ps1 first."
}

& $Exe
