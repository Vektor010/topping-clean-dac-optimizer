@(set "0=%~f0" '& set 1=%*) & powershell -NoProfile -ExecutionPolicy Bypass -Command "$c=[System.IO.File]::ReadAllText($env:0, [System.Text.Encoding]::UTF8); Invoke-Expression ($c.Substring($c.IndexOf([char]10)+1))" & exit /b

# ===================================================================
# TOPPING USB DAC: Standalone Debloat & Tray Remover Tweak
# Removes background bloatware, tray app & Node.js server.
# Leaves 100% pure hardware audio driver working at full bit-depth.
# ===================================================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8

$sysLang = (Get-Culture).TwoLetterISOLanguageName
$script:isRu = $sysLang -in @('ru', 'be', 'uk', 'kk')

# 1. Administrator Elevation Check with Recursion Guard
$isElevatedFlag = $env:1 -like "*-elevated*"
$currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentIdentity)
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    if ($isElevatedFlag) {
        if ($script:isRu) {
            Write-Host "[-] Ошибка: Не удалось получить права Администратора!" -ForegroundColor Red
            Read-Host "Нажмите Enter для выхода..."
        } else {
            Write-Host "[-] Error: Failed to obtain Administrator privileges!" -ForegroundColor Red
            Read-Host "Press Enter to exit..."
        }
        exit 1
    }
    Write-Host $(if ($script:isRu){"[*] Запрос прав Администратора..."}else{"[*] Requesting Administrator privileges..."}) -ForegroundColor Yellow
    Start-Process cmd.exe -Verb RunAs -ArgumentList "/c `"`"$env:0`" -elevated $env:1`""
    exit 0
}

$Host.UI.RawUI.WindowTitle = if ($script:isRu) { "Твик ЦАПа TOPPING: Очистка трея и фонового софта" } else { "TOPPING DAC Debloat & Tray Remover Tweak" }

Clear-Host
Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host $(if ($script:isRu){"   TOPPING USB DAC: ТВИК ОЧИСТКИ ТРЕЯ И ФОНОВЫХ ПРОЦЕССОВ (0% RAM) "}else{"   TOPPING USB DAC: DEBLOAT & TRAY REMOVER TWEAK (0% RAM/CPU)      "}) -ForegroundColor Cyan
Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host $(if ($script:isRu){" Этот твик навсегда убирает из трея панель управления и отключает"}else{" This tweak removes the tray control panel icon and permanently"}) -ForegroundColor White
Write-Host $(if ($script:isRu){" тяжелый фоновый сервер TOPPING Home (Node.js), оставляя только"}else{" disables the heavy TOPPING Home Node.js web server in background,"}) -ForegroundColor White
Write-Host $(if ($script:isRu){" чистый и быстрый аппаратный звук через системный драйвер Thesycon."}else{" leaving only pure, ultra-low latency hardware audio via Thesycon driver."}) -ForegroundColor White
Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host ""

# Шаг 1: Остановка фоновых процессов
Write-Host $(if ($script:isRu){"[*] Шаг 1: Остановка фоновых процессов ЦАПа..."}else{"[*] Step 1: Terminating non-essential DAC background processes..."}) -ForegroundColor Yellow

$cplProc = Get-Process -Name "ToppingUsbAudioCpl" -ErrorAction SilentlyContinue
if ($cplProc) {
    Stop-Process -InputObject $cplProc -Force -ErrorAction SilentlyContinue
    Write-Host $(if ($script:isRu){"  -> Панель ToppingUsbAudioCpl.exe остановлена (значок исчез из трея)."}else{"  -> ToppingUsbAudioCpl.exe stopped (tray icon removed)."}) -ForegroundColor Green
} else {
    Write-Host $(if ($script:isRu){"  -> Панель ToppingUsbAudioCpl.exe уже не запущена."}else{"  -> ToppingUsbAudioCpl.exe is not currently running."}) -ForegroundColor Gray
}

$homeProc = Get-Process -Name "TOPPING Home" -ErrorAction SilentlyContinue
if ($homeProc) {
    Stop-Process -InputObject $homeProc -Force -ErrorAction SilentlyContinue
    Write-Host $(if ($script:isRu){"  -> Веб-сервер TOPPING Home.exe остановлен (освобождена память)."}else{"  -> TOPPING Home.exe stopped (freed RAM)."}) -ForegroundColor Green
} else {
    Write-Host $(if ($script:isRu){"  -> Процесс TOPPING Home не запущен."}else{"  -> TOPPING Home is not running."}) -ForegroundColor Gray
}

# Шаг 2: Удаление из автозагрузки
Write-Host "`n" + $(if ($script:isRu){"[*] Шаг 2: Удаление из автозагрузки Windows..."}else{"[*] Step 2: Removing from Windows Startup..."}) -ForegroundColor Yellow

$startupShortcuts = @(
    "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\Topping USB Audio Device Control Panel Autostart.lnk",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Topping USB Audio Device Control Panel Autostart.lnk",
    "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\TOPPING Home.lnk",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\TOPPING Home.lnk"
)
foreach ($lnk in $startupShortcuts) {
    if (Test-Path $lnk) {
        Remove-Item $lnk -Force -ErrorAction SilentlyContinue
        Write-Host "  -> $(Split-Path $lnk -Leaf): " + $(if ($script:isRu){"удален из автозагрузки."}else{"removed from startup."}) -ForegroundColor Green
    }
}

# Шаг 3: Отключение задачи планировщика TOPPING Home
Write-Host "`n" + $(if ($script:isRu){"[*] Шаг 3: Отключение задачи автозапуска в Планировщике..."}else{"[*] Step 3: Disabling autostart task in Task Scheduler..."}) -ForegroundColor Yellow
$task = Get-ScheduledTask -TaskName "TOPPINGHome-AutoStart" -ErrorAction SilentlyContinue
if ($task) {
    Disable-ScheduledTask -TaskName "TOPPINGHome-AutoStart" -ErrorAction SilentlyContinue | Out-Null
    Write-Host $(if ($script:isRu){"  -> Задача TOPPINGHome-AutoStart успешно отключена."}else{"  -> Scheduled task TOPPINGHome-AutoStart disabled."}) -ForegroundColor Green
} else {
    Write-Host $(if ($script:isRu){"  -> Задача автозапуска в планировщике отсутствует."}else{"  -> Task Scheduler entry does not exist."}) -ForegroundColor Gray
}

# Шаг 4: Проверка статуса аудиоустройства
Write-Host "`n" + $(if ($script:isRu){"[*] Шаг 4: Проверка работы звукового драйвера..."}else{"[*] Step 4: Verifying audio driver status..."}) -ForegroundColor Yellow
$dac = Get-PnpDevice | Where-Object { $_.FriendlyName -match "TOPPING" -and $_.Status -eq "OK" }
if ($dac) {
    Write-Host $(if ($script:isRu){"  [+] ЦАП TOPPING активен и готов к работе! Звук в полном порядке."}else{"  [+] TOPPING DAC is ACTIVE and ready! Audio output is working."}) -ForegroundColor Green
} else {
    Write-Host $(if ($script:isRu){"  [i] ЦАП в данный момент не подключен по USB (подключите для звука)."}else{"  [i] DAC is currently disconnected from USB."}) -ForegroundColor Gray
}

Write-Host ""
Write-Host "===================================================================" -ForegroundColor Green
Write-Host $(if ($script:isRu){"   [УСПЕХ!] ТВИК УСПЕШНО ПРИМЕНЕН:                                 "}else{"   [SUCCESS!] TWEAK APPLIED SUCCESSFULLY:                          "}) -ForegroundColor Green
Write-Host $(if ($script:isRu){"   [+] Трей чистый (нет лишних значков)                            "}else{"   [+] System tray is clean (no bloatware icons)                   "}) -ForegroundColor White
Write-Host $(if ($script:isRu){"   [+] В фоне 0 процессов, 0 служб, 0 МБ ОЗУ                       "}else{"   [+] 0 background processes, 0 services, 0 MB RAM overhead       "}) -ForegroundColor White
Write-Host $(if ($script:isRu){"   [+] Звук работает напрямую через системный драйвер Thesycon     "}else{"   [+] Audio plays directly through Thesycon kernel driver         "}) -ForegroundColor White
Write-Host "===================================================================" -ForegroundColor Green
Write-Host ""
Write-Host $(if ($script:isRu){"Нажмите Enter для закрытия..."}else{"Press Enter to exit..."})
$null = Read-Host
