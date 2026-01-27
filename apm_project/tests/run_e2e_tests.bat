@echo off
:: APM E2E Test Runner
:: This batch file runs the PowerShell E2E test suite

title APM E2E Tests

echo.
echo ============================================================
echo   APM E2E Test Runner
echo ============================================================
echo.

:: Parse arguments
set "TEST_SUITE=All"
set "VERBOSE="
set "KEEP_PROJECTS="

:parse_args
if "%~1"=="" goto run_tests
if /i "%~1"=="--rapid" set "TEST_SUITE=RAPID" & shift & goto parse_args
if /i "%~1"=="--full" set "TEST_SUITE=FULL" & shift & goto parse_args
if /i "%~1"=="--verbose" set "VERBOSE=-Verbose" & shift & goto parse_args
if /i "%~1"=="-v" set "VERBOSE=-Verbose" & shift & goto parse_args
if /i "%~1"=="--keep" set "KEEP_PROJECTS=-KeepTestProjects" & shift & goto parse_args
if /i "%~1"=="--help" goto show_help
if /i "%~1"=="-h" goto show_help
shift
goto parse_args

:show_help
echo Usage: run_e2e_tests.bat [options]
echo.
echo Options:
echo   --rapid      Run only RAPID methodology tests
echo   --full       Run only FULL methodology tests
echo   --verbose    Show detailed test output
echo   --keep       Keep test projects after completion
echo   --help, -h   Show this help message
echo.
echo By default, runs all tests.
echo.
goto end

:run_tests
:: Check if PowerShell Core is available
where pwsh >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Using PowerShell Core ^(pwsh^)
    pwsh -NoProfile -ExecutionPolicy Bypass -File "%~dp0e2e_tests.ps1" -TestSuite %TEST_SUITE% %VERBOSE% %KEEP_PROJECTS%
    set TEST_RESULT=%ERRORLEVEL%
    goto check_result
)

:: Fall back to Windows PowerShell
echo Using Windows PowerShell
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0e2e_tests.ps1" -TestSuite %TEST_SUITE% %VERBOSE% %KEEP_PROJECTS%
set TEST_RESULT=%ERRORLEVEL%
goto check_result

:check_result
if "%TEST_RESULT%"=="0" (
    echo.
    echo ============================================================
    echo   E2E TESTS PASSED
    echo ============================================================
) else (
    echo.
    echo ============================================================
    echo   E2E TESTS FAILED
    echo ============================================================
)

:end
echo.
pause

