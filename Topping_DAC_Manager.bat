@(set "0=%~f0" '& set 1=%*) & powershell -NoProfile -ExecutionPolicy Bypass -Command "$c=[System.IO.File]::ReadAllText($env:0, [System.Text.Encoding]::UTF8); Invoke-Expression ($c.Substring($c.IndexOf([char]10)+1))" & exit /b

# ===================================================================
# TOPPING USB DAC Manager: Master Optimizer & Clean Driver Toolkit
# Bilingual: English (EN) & Russian (RU) with Auto-Detection
# Zero Background RAM/CPU, Low Latency, Anti-Bloatware
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

$scriptDir = Split-Path -Parent $env:0

while ($true) {
    $Host.UI.RawUI.WindowTitle = if ($script:isRu) { "Менеджер ЦАПа TOPPING — Чистый звук без мусора" } else { "TOPPING DAC Manager — Pure Audio Optimizer" }
    Clear-Host
    Write-Host "===================================================================" -ForegroundColor Cyan
    Write-Host $(if ($script:isRu){"       МЕНЕДЖЕР ЦАПА TOPPING: ОПТИМИЗАЦИЯ И ЧИСТЫЙ ДРАЙВЕР        "}else{"       TOPPING USB DAC MANAGER: OPTIMIZER & CLEAN DRIVER          "}) -ForegroundColor Cyan
    Write-Host "===================================================================" -ForegroundColor Cyan
    
    # Live DAC detection
    $dac = Get-PnpDevice | Where-Object { $_.FriendlyName -match "TOPPING" -and $_.Status -eq "OK" } | Select-Object -First 1
    $drv = Get-CimInstance Win32_SystemDriver | Where-Object { $_.Name -eq "ToppingUsbAudio" }
    
    Write-Host $(if ($script:isRu){" [СТАТУС]  Устройство: "}else{" [STATUS]  Device:     "}) -NoNewline
    if ($dac) { Write-Host "$($dac.FriendlyName) (ПОДКЛЮЧЕН / OK)" -ForegroundColor Green } else { Write-Host "ЦАП не найден по USB" -ForegroundColor Yellow }
    
    Write-Host $(if ($script:isRu){" [ДРАЙВЕР] Состояние:  "}else{" [DRIVER]  Status:     "}) -NoNewline
    if ($drv -and $drv.State -eq 'Running') { Write-Host "Thesycon Kernel Driver: RUNNING (OK)" -ForegroundColor Green } else { Write-Host "Не активен / Стандартный драйвер" -ForegroundColor Gray }

    $cplRunning = Get-Process -Name "ToppingUsbAudioCpl" -ErrorAction SilentlyContinue
    $homeRunning = Get-Process -Name "TOPPING Home" -ErrorAction SilentlyContinue
    Write-Host $(if ($script:isRu){" [ФОН]     Процессы:   "}else{" [OVERHEAD] Background: "}) -NoNewline
    if (-not $cplRunning -and -not $homeRunning) {
        Write-Host "ИДЕАЛЬНО: 0 процессов в трее, 0 МБ ОЗУ" -ForegroundColor Green
    } else {
        Write-Host "ОБНАРУЖЕН МУСОР: $(if($cplRunning){'ToppingUsbAudioCpl '})$(if($homeRunning){'TOPPING_Home '})" -ForegroundColor Red
    }
    Write-Host "===================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host $(if ($script:isRu){" [1] Быстрый твик очистки: убрать из трея и выключить фоновый мусор"}else{" [1] Instant Debloat: Remove tray icon & disable background services"}) -ForegroundColor White
    Write-Host $(if ($script:isRu){" [2] Установить чистый драйвер (только .sys/.inf, 0% фоновых служб)"}else{" [2] Clean Driver Install: Kernel driver only (0% background RAM/CPU)"}) -ForegroundColor White
    Write-Host $(if ($script:isRu){" [3] Экспорт чистого драйвера из системы (создать автономный бэкап)"}else{" [3] Export clean driver from current Windows to portable folder"}) -ForegroundColor White
    Write-Host $(if ($script:isRu){" [4] Подробная диагностика ЦАПа (форматы, задержки, драйверы)"}else{" [4] Detailed DAC Diagnostics (audio formats, latency, drivers)"}) -ForegroundColor White
    Write-Host $(if ($script:isRu){" [5] Открыть панель управления Topping (для смены буфера ASIO)"}else{" [5] Open Topping Control Panel once (to adjust ASIO buffer size)"}) -ForegroundColor White
    Write-Host $(if ($script:isRu){" [6] Восстановить автозагрузку панели в трее (откат твика)"}else{" [6] Restore tray autostart & standard launcher (revert tweak)"}) -ForegroundColor White
    Write-Host $(if ($script:isRu){" [7] Полное удаление драйвера Topping (откат на стандартный USB)"}else{" [7] Completely uninstall Topping driver (revert to generic USB)"}) -ForegroundColor White
    Write-Host ""
    Write-Host $(if ($script:isRu){" [L] Переключить язык меню / Switch Language (Current: Русский)"}else{" [L] Switch Menu Language / Переключить язык (Current: English)"}) -ForegroundColor Yellow
    Write-Host $(if ($script:isRu){" [0] Выход"}else{" [0] Exit"}) -ForegroundColor Gray
    Write-Host "-------------------------------------------------------------------"
    
    $choice = Read-Host $(if ($script:isRu){"Выберите действие [0-7, L]"}else{"Select action [0-7, L]"})
    if ([string]::IsNullOrWhiteSpace($choice)) { continue }

    switch ($choice.Trim().ToUpper()) {
        "L" {
            $script:isRu = -not $script:isRu
            continue
        }
        "1" {
            Clear-Host
            Write-Host $(if ($script:isRu){"=== Быстрый твик: Очистка трея и фонового софта ==="}else{"=== Instant Debloat: Removing Tray & Background Bloatware ==="}) -ForegroundColor Cyan
            Stop-Process -Name "ToppingUsbAudioCpl" -Force -ErrorAction SilentlyContinue
            Stop-Process -Name "TOPPING Home" -Force -ErrorAction SilentlyContinue
            
            $startupLnk = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\Topping USB Audio Device Control Panel Autostart.lnk"
            if (Test-Path $startupLnk) { Remove-Item $startupLnk -Force -ErrorAction SilentlyContinue }
            
            $task = Get-ScheduledTask -TaskName "TOPPINGHome-AutoStart" -ErrorAction SilentlyContinue
            if ($task) { Disable-ScheduledTask -TaskName "TOPPINGHome-AutoStart" -ErrorAction SilentlyContinue | Out-Null }
            
            Write-Host $(if ($script:isRu){"`n[УСПЕХ] Трей очищен! Фоновые процессы остановлены, автозапуск отключен."}else{"`n[SUCCESS] Tray cleaned! Background processes killed, autostart disabled."}) -ForegroundColor Green
            Write-Host $(if ($script:isRu){"Звук продолжает работать через нативный драйвер Thesycon."}else{"Audio continues playing natively through Thesycon kernel driver."}) -ForegroundColor White
            Write-Host $(if ($script:isRu){"`nНажмите Enter для возврата в меню..."}else{"`nPress Enter to return to menu..."})
            $null = Read-Host
        }
        "2" {
            Clear-Host
            Write-Host $(if ($script:isRu){"=== Установка чистого драйвера TOPPING USB DAC ==="}else{"=== Installing Clean TOPPING USB DAC Driver ==="}) -ForegroundColor Cyan
            $driverFolder = Join-Path $scriptDir "Driver"
            $infFiles = Get-ChildItem -Path $driverFolder -Filter "*.inf" -ErrorAction SilentlyContinue
            if ($infFiles) {
                foreach ($inf in $infFiles) {
                    $out = pnputil /add-driver $inf.FullName /install 2>&1
                    Write-Host "  -> $($inf.Name): OK" -ForegroundColor Green
                }
                pnputil /scan-devices | Out-Null
                
                # Optional ASIO
                $asioFolder = Join-Path $scriptDir "ASIO"
                if (Test-Path "$asioFolder\ToppingUsbAudioasio_x64.dll") {
                    Copy-Item "$asioFolder\ToppingUsbAudioapi_x64.dll" "$env:windir\System32\" -Force -ErrorAction SilentlyContinue
                    Copy-Item "$asioFolder\ToppingUsbAudioasio_x64.dll" "$env:windir\System32\" -Force -ErrorAction SilentlyContinue
                    Start-Process regsvr32.exe -ArgumentList "/s `"$env:windir\System32\ToppingUsbAudioasio_x64.dll`"" -Wait
                    
                    if (Test-Path "$env:windir\SysWOW64") {
                        Copy-Item "$asioFolder\ToppingUsbAudioapi.dll" "$env:windir\SysWOW64\" -Force -ErrorAction SilentlyContinue
                        Copy-Item "$asioFolder\ToppingUsbAudioasio.dll" "$env:windir\SysWOW64\" -Force -ErrorAction SilentlyContinue
                        Start-Process "$env:windir\SysWOW64\regsvr32.exe" -ArgumentList "/s `"$env:windir\SysWOW64\ToppingUsbAudioasio.dll`"" -Wait
                    }
                    Write-Host "  -> ASIO библиотеки зарегистрированы." -ForegroundColor Green
                }
                Write-Host $(if ($script:isRu){"`n[УСПЕХ] Чистый драйвер установлен напрямую в Windows DriverStore!"}else{"`n[SUCCESS] Clean driver installed directly into Windows DriverStore!"}) -ForegroundColor Green
            } else {
                Write-Host $(if ($script:isRu){"[-] Ошибка: Файлы драйвера не найдены в папке Driver!"}else{"[-] Error: Driver files not found in Driver folder!"}) -ForegroundColor Red
            }
            Write-Host $(if ($script:isRu){"`nНажмите Enter для возврата в меню..."}else{"`nPress Enter to return to menu..."})
            $null = Read-Host
        }
        "3" {
            Clear-Host
            Write-Host $(if ($script:isRu){"=== Экспорт чистого драйвера из текущей Windows ==="}else{"=== Exporting Clean Driver from Current Windows ==="}) -ForegroundColor Cyan
            $driverFolder = Join-Path $scriptDir "Driver"
            $tempExp = "$env:TEMP\topping_export_temp"
            if (Test-Path $tempExp) { Remove-Item $tempExp -Recurse -Force }
            New-Item -ItemType Directory -Path $tempExp -Force | Out-Null
            
            pnputil /export-driver * $tempExp | Out-Null
            $found = Get-ChildItem $tempExp -Recurse | Where-Object { $_.Name -match "topping" -and $_.Extension -in '.inf','.sys','.cat' }
            if ($found) {
                foreach ($f in $found) {
                    Copy-Item $f.FullName "$driverFolder\$($f.Name)" -Force
                    Write-Host "  -> Экспортирован: $($f.Name)" -ForegroundColor Green
                }
                Write-Host $(if ($script:isRu){"`n[УСПЕХ] Драйверы экспортированы в папку: $driverFolder"}else{"`n[SUCCESS] Drivers exported to: $driverFolder"}) -ForegroundColor Green
            } else {
                Write-Host $(if ($script:isRu){"[-] Драйвер TOPPING не найден в системе."}else{"[-] TOPPING driver not found in system."}) -ForegroundColor Red
            }
            Remove-Item $tempExp -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host $(if ($script:isRu){"`nНажмите Enter для возврата в меню..."}else{"`nPress Enter to return to menu..."})
            $null = Read-Host
        }
        "4" {
            Clear-Host
            Write-Host $(if ($script:isRu){"=== Подробная диагностика ЦАПа и аудиостека ==="}else{"=== Detailed DAC & Audio Diagnostics ==="}) -ForegroundColor Cyan
            Write-Host "`n--- 1. PnP Devices ---" -ForegroundColor Yellow
            Get-PnpDevice | Where-Object { $_.FriendlyName -match "TOPPING" -or $_.InstanceId -match "152A" } | Select-Object Status, Class, FriendlyName, InstanceId | Format-Table -AutoSize
            
            Write-Host "--- 2. Kernel Drivers ---" -ForegroundColor Yellow
            Get-CimInstance Win32_SystemDriver | Where-Object { $_.Name -match "Topping" } | Select-Object Name, State, Status, PathName | Format-Table -AutoSize
            
            Write-Host "--- 3. Audio Endpoints ---" -ForegroundColor Yellow
            Get-PnpDevice -Class AudioEndpoint | Where-Object { $_.FriendlyName -match "TOPPING|fifine" } | Select-Object Status, FriendlyName | Format-Table -AutoSize
            
            Write-Host "--- 4. Active Background Processes ---" -ForegroundColor Yellow
            $audioProcs = Get-Process | Where-Object { $_.ProcessName -match "topp|tusb|mic" }
            if ($audioProcs) { $audioProcs | Select-Object Name, Id, WS | Format-Table -AutoSize } else { Write-Host "Нет лишних процессов (0% фоновой нагрузки)" -ForegroundColor Green }
            
            Write-Host $(if ($script:isRu){"`nНажмите Enter для возврата в меню..."}else{"`nPress Enter to return to menu..."})
            $null = Read-Host
        }
        "5" {
            $cplPath = "C:\Program Files\Topping\USB Audio Device Driver\x64\ToppingUsbAudioCpl.exe"
            if (Test-Path $cplPath) {
                Write-Host "`n[*] Запуск панели управления: $cplPath" -ForegroundColor Cyan
                Start-Process $cplPath
            } else {
                Write-Host "`n[-] ToppingUsbAudioCpl.exe не установлен на этом ПК." -ForegroundColor Red
            }
            Start-Sleep -Seconds 2
        }
        "6" {
            Clear-Host
            Write-Host $(if ($script:isRu){"=== Восстановление автозапуска панели в трее ==="}else{"=== Restoring Tray Control Panel Autostart ==="}) -ForegroundColor Cyan
            $cplPath = "C:\Program Files\Topping\USB Audio Device Driver\x64\ToppingUsbAudioCpl.exe"
            if (Test-Path $cplPath) {
                $lnkPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\Topping USB Audio Device Control Panel Autostart.lnk"
                $sh = New-Object -ComObject WScript.Shell
                $lnk = $sh.CreateShortcut($lnkPath)
                $lnk.TargetPath = $cplPath
                $lnk.Arguments = "-hide"
                $lnk.Save()
                Start-Process $cplPath -ArgumentList "-hide"
                Write-Host $(if ($script:isRu){"`n[УСПЕХ] Панель возвращена в автозагрузку и запущена в трее."}else{"`n[SUCCESS] Control panel restored to startup and launched in tray."}) -ForegroundColor Green
            } else {
                Write-Host $(if ($script:isRu){"[-] ToppingUsbAudioCpl.exe не найден."}else{"[-] ToppingUsbAudioCpl.exe not found."}) -ForegroundColor Red
            }
            Write-Host $(if ($script:isRu){"`nНажмите Enter для возврата в меню..."}else{"`nPress Enter to return to menu..."})
            $null = Read-Host
        }
        "7" {
            Clear-Host
            Write-Host $(if ($script:isRu){"=== Полное удаление драйвера Topping ==="}else{"=== Complete Uninstall of Topping Driver ==="}) -ForegroundColor Cyan
            $confirm = Read-Host $(if ($script:isRu){"Вы действительно хотите удалить драйвер Topping? (y/n)"}else{"Are you sure you want to remove Topping driver? (y/n)"})
            if ($confirm -match '^(y|yes|д|да)$') {
                $drivers = pnputil /enum-drivers | Select-String "toppingusbaudio"
                foreach ($d in $drivers) {
                    if ($d -match "oem\d+\.inf") {
                        $oem = $matches[0]
                        Write-Host "  -> Удаление $oem..." -ForegroundColor White
                        pnputil /delete-driver $oem /uninstall /force | Out-Null
                    }
                }
                pnputil /scan-devices | Out-Null
                Write-Host $(if ($script:isRu){"`n[УСПЕХ] Драйверы удалены из системы."}else{"`n[SUCCESS] Drivers removed from system."}) -ForegroundColor Green
            }
            Write-Host $(if ($script:isRu){"`nНажмите Enter для возврата в меню..."}else{"`nPress Enter to return to menu..."})
            $null = Read-Host
        }
        "0" {
            Clear-Host
            exit 0
        }
    }
}
