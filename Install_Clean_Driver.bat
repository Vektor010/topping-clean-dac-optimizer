@echo off
:: Safety Check: Attempt installation only if PnPUtil exists
where pnputil >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] PnPUtil not found. Your Windows build may be too stripped.
    pause
    exit /b
)
:: Proceed with installation
powershell -NoProfile -ExecutionPolicy Bypass -Command "& { try { pnputil /add-driver "$PSScriptRoot\Driver\*.inf" /install } catch { Write-Host 'Installation failed, check logs.' } }"
