@echo off
REM ===================================================================
REM  Rebuild bin\admintickets.dll without Visual Studio.
REM  Requires MSBuild (ships with "Build Tools for Visual Studio" -
REM  select the ".NET desktop build tools" workload). Run this from a
REM  normal command prompt in the repo root.
REM ===================================================================

REM --- Find MSBuild via vswhere (installed with any recent VS/Build Tools) ---
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
set "MSBUILD="
if exist "%VSWHERE%" (
  for /f "usebackq tokens=*" %%i in (`"%VSWHERE%" -latest -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe`) do set "MSBUILD=%%i"
)

REM --- Fallback: legacy framework MSBuild (works for this .NET 4.x project) ---
if "%MSBUILD%"=="" if exist "%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe" set "MSBUILD=%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe"

if "%MSBUILD%"=="" (
  echo Could not find MSBuild. Install "Build Tools for Visual Studio"
  echo ^(.NET desktop build tools^) from https://visualstudio.microsoft.com/downloads/
  exit /b 1
)

echo Using MSBuild: %MSBUILD%
"%MSBUILD%" admintickets.vbproj /p:Configuration=Release /p:Platform=AnyCPU /v:minimal /nologo
if errorlevel 1 (
  echo.
  echo BUILD FAILED - see errors above.
  exit /b 1
)
echo.
echo BUILD OK -^> bin\admintickets.dll
