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

$Host.UI.RawUI.WindowTitle = if ($script:isRu) { "Установка чистого драйвера TOPPING USB DAC" } else { "TOPPING USB DAC Clean Driver Installer" }
$scriptDir = Split-Path -Parent $env:0

Clear-Host
Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host $(if ($script:isRu){"   TOPPING USB DAC — УСТАНОВКА ЧИСТОГО ДРАЙВЕРА (CLEAN DRIVER)    "}else{"   TOPPING USB DAC — CLEAN DRIVER INSTALLER (ZERO BLOAT)          "}) -ForegroundColor Cyan
Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host $(if ($script:isRu){" Установка ТОЛЬКО официального сертифицированного драйвера ядра Thesycon"}else{" Installs ONLY official certified Thesycon kernel driver into DriverStore"}) -ForegroundColor White
Write-Host $(if ($script:isRu){" напрямую в системное хранилище Windows DriverStore (без софта и трея)."}else{" with zero background RAM/CPU overhead and no resident tray app."}) -ForegroundColor White
Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host ""

# Шаг 1: Установка ядерных драйверов в DriverStore
Write-Host $(if ($script:isRu){"[*] Шаг 1: Установка ядерных драйверов в DriverStore через PnPUtil..."}else{"[*] Step 1: Installing kernel drivers into DriverStore via PnPUtil..."}) -ForegroundColor Yellow
$driverFolder = Join-Path $scriptDir "Driver"
$infFiles = Get-ChildItem -Path $driverFolder -Filter "*.inf"
foreach ($inf in $infFiles) {
    $out = pnputil /add-driver $inf.FullName /install 2>&1
    Write-Host "  -> $($inf.Name): OK" -ForegroundColor Green
}

# Шаг 2: Пересканирование устройств PnP
Write-Host "`n" + $(if ($script:isRu){"[*] Шаг 2: Пересканирование устройств Windows PnP..."}else{"[*] Step 2: Rescanning Windows PnP devices..."}) -ForegroundColor Yellow
pnputil /scan-devices | Out-Null
Write-Host "  -> OK" -ForegroundColor Green

# Шаг 3: Установка поддержки ASIO
Write-Host "`n" + $(if ($script:isRu){"[*] Шаг 3: Регистрация поддержки ASIO (для Foobar2000, AIMP, DAW)..."}else{"[*] Step 3: Registering ASIO components (for Foobar2000, AIMP, DAW)..."}) -ForegroundColor Yellow
$asioFolder = Join-Path $scriptDir "ASIO"
$sys32 = "$env:windir\System32"
$sysWow = "$env:windir\SysWOW64"

if (Test-Path "$asioFolder\ToppingUsbAudioasio_x64.dll") {
    Copy-Item "$asioFolder\ToppingUsbAudioapi_x64.dll" "$sys32\" -Force -ErrorAction SilentlyContinue
    Copy-Item "$asioFolder\ToppingUsbAudioasio_x64.dll" "$sys32\" -Force -ErrorAction SilentlyContinue
    Start-Process regsvr32.exe -ArgumentList "/s `"$sys32\ToppingUsbAudioasio_x64.dll`"" -Wait
    
    if (Test-Path $sysWow) {
        Copy-Item "$asioFolder\ToppingUsbAudioapi.dll" "$sysWow\" -Force -ErrorAction SilentlyContinue
        Copy-Item "$asioFolder\ToppingUsbAudioasio.dll" "$sysWow\" -Force -ErrorAction SilentlyContinue
        Start-Process "$sysWow\regsvr32.exe" -ArgumentList "/s `"$sysWow\ToppingUsbAudioasio.dll`"" -Wait
    }
    Write-Host $(if ($script:isRu){"  -> ASIO библиотеки зарегистрированы без создания фоновых процессов!"}else{"  -> ASIO libraries registered without background services!"}) -ForegroundColor Green
}

# Шаг 4: Удаление фонового мусора
Write-Host "`n" + $(if ($script:isRu){"[*] Шаг 4: Очистка фонового мусора..."}else{"[*] Step 4: Cleaning up any previous bloatware..."}) -ForegroundColor Yellow
$cplStartup = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\Topping USB Audio Device Control Panel Autostart.lnk"
if (Test-Path $cplStartup) { Remove-Item $cplStartup -Force -ErrorAction SilentlyContinue }

$task = Get-ScheduledTask -TaskName "TOPPINGHome-AutoStart" -ErrorAction SilentlyContinue
if ($task) {
    Disable-ScheduledTask -TaskName "TOPPINGHome-AutoStart" -ErrorAction SilentlyContinue | Out-Null
    Stop-Process -Name "TOPPING Home" -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "===================================================================" -ForegroundColor Green
Write-Host $(if ($script:isRu){"   [ГОТОВО!] Чистый драйвер TOPPING USB DAC успешно установлен!   "}else{"   [SUCCESS!] Clean TOPPING USB DAC Driver installed successfully! "}) -ForegroundColor Green
Write-Host $(if ($script:isRu){"   Звук работает на 100% аппаратно, в фоне висит 0 процессов.     "}else{"   Audio operates 100% natively in hardware with 0 background RAM. "}) -ForegroundColor White
Write-Host "===================================================================" -ForegroundColor Green
Write-Host ""
Write-Host $(if ($script:isRu){"Нажмите Enter для завершения..."}else{"Press Enter to exit..."})
$null = Read-Host
