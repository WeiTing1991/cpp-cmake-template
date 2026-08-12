param(
    [string]$Preset = "Debug",
    [switch]$Clean,
    [switch]$Format,
    [switch]$Tidy
)

$ErrorActionPreference = "Stop"

$BuildType = if ($Preset -eq "Release") { "Release" } else { "Debug" }

if ($Clean) {
    Write-Host "Cleaning build..."
    if (Test-Path build) { Remove-Item -Recurse -Force build }
    Remove-Item -ErrorAction SilentlyContinue CMakeUserPresets.json, ConanPresets.json, conan_toolchain.cmake
}

if ($Format) {
    Write-Host "Formatting..."
    Get-ChildItem -Recurse -Include *.cpp,*.h Src,tests | ForEach-Object {
        clang-format -i $_.FullName
    }
}

if ($Tidy) {
    Write-Host "Running clang-tidy..."
    Get-ChildItem -Recurse -Include *.cpp Src,tests | ForEach-Object {
        clang-tidy --config-file=.clang-tidy -p "build/$Preset" $_.FullName
    }
}

conan install . `
    --output-folder="build/$BuildType" `
    --build=missing `
    -s build_type=$BuildType

cmake --preset $Preset
cmake --build --preset $Preset
