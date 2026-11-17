@(set "0=%~f0" '& set 1=%*) & powershell -NoProfile -ExecutionPolicy Bypass -Command "$c=[System.IO.File]::ReadAllText($env:0, [System.Text.Encoding]::UTF8); Invoke-Expression ($c.Substring($c.IndexOf([char]10)+1))" & exit /b

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8

$sysLang = (Get-Culture).TwoLetterISOLanguageName
$script:isRu = $sysLang -in @('ru', 'be', 'uk', 'kk')

# Elevation
$isElevatedFlag = $env:1 -like "*-elevated*"
$currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentIdentity)
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    if ($isElevatedFlag) {
        Write-Host "[-] Error: Failed to obtain Administrator privileges!" -ForegroundColor Red
        Read-Host "Press Enter to exit..."
        exit 1
    }
    Write-Host $(if ($script:isRu){"[*] Запрос прав Администратора..."}else{"[*] Requesting Administrator privileges..."}) -ForegroundColor Yellow
    Start-Process cmd.exe -Verb RunAs -ArgumentList "/c `"`"$env:0`" -elevated $env:1`""
    exit 0
}

$Host.UI.RawUI.WindowTitle = if ($script:isRu) { "Восстановление автозапуска панели управления" } else { "Restore TOPPING Control Panel Autostart" }

Clear-Host
Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host $(if ($script:isRu){"   TOPPING USB DAC — ВОССТАНОВЛЕНИЕ ПАНЕЛИ В ТРЕЕ (ОТКАТ ТВИКА)    "}else{"   TOPPING USB DAC — RESTORE TRAY CONTROL PANEL (REVERT TWEAK)     "}) -ForegroundColor Cyan
Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host $(if ($script:isRu){" Этот скрипт возвращает запуск панели управления ToppingUsbAudioCpl"}else{" This script restores the tray icon and autostart for the standard"}) -ForegroundColor White
Write-Host $(if ($script:isRu){" в автозагрузку Windows при старте системы."}else{" ToppingUsbAudioCpl Control Panel upon Windows startup."}) -ForegroundColor White
Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host ""

$cplPath = "C:\Program Files\Topping\USB Audio Device Driver\x64\ToppingUsbAudioCpl.exe"
if (Test-Path $cplPath) {
    $lnkPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\Topping USB Audio Device Control Panel Autostart.lnk"
    $sh = New-Object -ComObject WScript.Shell
    $lnk = $sh.CreateShortcut($lnkPath)
    $lnk.TargetPath = $cplPath
    $lnk.Arguments = "-hide"
    $lnk.Save()
    
    Start-Process $cplPath -ArgumentList "-hide" -ErrorAction SilentlyContinue
    
    Write-Host $(if ($script:isRu){"[УСПЕХ] Панель ToppingUsbAudioCpl.exe возвращена в автозагрузку и запущена в трее!"}else{"[SUCCESS] ToppingUsbAudioCpl.exe restored to startup and launched in tray!"}) -ForegroundColor Green
} else {
    Write-Host $(if ($script:isRu){"[-] Файл ToppingUsbAudioCpl.exe не найден по пути $cplPath"}else{"[-] File ToppingUsbAudioCpl.exe not found at $cplPath"}) -ForegroundColor Red
}

Write-Host ""
Write-Host $(if ($script:isRu){"Нажмите Enter для завершения..."}else{"Press Enter to exit..."})
$null = Read-Host
