param(
    [string]$Preset = "Debug",
    [switch]$Clean,
    [switch]$Format,
    [switch]$Tidy
)

$ErrorActionPreference = "Stop"

if ($Clean) {
    Write-Host "Cleaning build..."
    if (Test-Path build) { Remove-Item -Recurse -Force build }
}

if ($Format) {
    Write-Host "Formatting..."
    Get-ChildItem -Recurse -Include *.cpp,*.h src,include,tests | ForEach-Object {
        clang-format -i $_.FullName
    }
}

if ($Tidy) {
    Write-Host "Running clang-tidy..."
    Get-ChildItem -Recurse -Include *.cpp src,include,tests | ForEach-Object {
        clang-tidy --config-file=.clang-tidy -p "build/$Preset" $_.FullName
    }
}

cmake --preset $Preset
cmake --build --preset $Preset
