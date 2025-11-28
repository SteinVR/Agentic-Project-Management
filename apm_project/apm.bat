@echo off
:: APM (Agentic Project Management) - Windows Launcher
:: This batch file launches the PowerShell configurator

title APM - Agentic Project Management

:: Check if PowerShell is available
where pwsh >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    pwsh -NoProfile -ExecutionPolicy Bypass -File "%~dp0apm.ps1" %*
    goto :end
)

where powershell >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0apm.ps1" %*
    goto :end
)

echo [ERROR] PowerShell not found. Please install PowerShell.
echo Download from: https://github.com/PowerShell/PowerShell
pause

:end

