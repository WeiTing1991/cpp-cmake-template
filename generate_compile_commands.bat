@echo off
echo ========================================
echo Setup MSVC Environment
echo ========================================
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" x64 -vcvars_ver=14.2

echo ========================================
echo Configure with Ninja for compile_commands.json
echo ========================================


cmake --preset ninja-windows
cmake --build --preset=ninja-windows-build

move Build_Ninja\compile_commands.json \compile_commands.json
pause
