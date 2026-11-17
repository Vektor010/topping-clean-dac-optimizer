# Known Issues and Workarounds

## 1. Windows USB Selective Suspend (Audio Pop on Sleep/Wake)
- **Symptom:** Brief pop or click when Windows resumes from sleep or powers down the USB root hub.
- **Cause:** Windows aggressive USB Power Management shuts off power to the XMOS microcontroller.
- **Workaround:**
  1. Open Device Manager (`devmgmt.msc`).
  2. Expand `Universal Serial Bus controllers`.
  3. Right-click your USB Root Hub -> `Properties` -> `Power Management`.
  4. Uncheck `Allow the computer to turn off this device to save power`.

## 2. Windows 11 Exclusive Mode Contention
- **Symptom:** In DAW software (Cubase/FL Studio) using ASIO, YouTube or Discord has no sound.
- **Cause:** ASIO driver takes exclusive control of the hardware endpoint when configured for exclusive bit-perfect playback.
- **Workaround:** This is standard audiophile behavior for bit-perfect output. To allow mixed playback, set the sample rate in Windows Sound Properties to match your DAW project sample rate (e.g., 44.1 kHz or 48 kHz).

## 3. Adjusting ASIO Buffer Size without Resident Tray
- **Symptom:** User needs to change ASIO buffer from 256 samples to 64 or 512 samples.
- **Solution:** Run `Topping_DAC_Manager.bat` and select `[5] Open Topping Control Panel once`. It launches the control panel window on-demand without keeping it resident after exit.
