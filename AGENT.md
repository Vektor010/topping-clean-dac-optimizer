# AI Agent & Developer Guidelines: TOPPING Clean DAC Optimizer

> **Purpose:** This document provides comprehensive architectural context, constraints, and instructions for any AI assistant (Claude, GPT, Gemini, Cursor, Copilot, Antigravity, Aider) or human developer continuing work on this project.

---

## 1. Project Philosophy & Hardware Architecture

**TOPPING Clean DAC Optimizer** is an open-source, zero-overhead Windows audio driver packaging and optimization toolkit for **TOPPING USB Digital-to-Analog Converters (DACs)** powered by XMOS USB receiver chips and **Thesycon USB Audio Class 2.0 (UAC2)** kernel drivers.

### Core Problems Solved:
1. **Bloatware Elimination:** Official vendor installers package `TOPPING Home.exe` (Node.js/Next.js/Electron server running on `127.0.0.1:27149`) and `ToppingUsbAudioCpl.exe` in Windows Startup.
2. **Error Prevention:** Missing or corrupted configuration files (`custom.ini`, `ToppingUsbAudioCpl.xml`) cause modal error dialogs upon user login.
3. **Zero Latency Overhead:** Direct installation of certified `.inf` and `.sys` packages into Windows `DriverStore` via `PnPUtil` ensures pure hardware bit-perfect playback without background processes.

---

## 2. Strict Project Boundaries & Safety Rules

1. **DRIVE RESTRICTIONS:**
   - **NEVER** touch, write, read, or modify anything on the `D:` drive. Strictly operate within the active repository directory:
     `C:\Users\User\Documents\AutoSettingsPS\Topping-Clean-DAC-Optimizer`
2. **100% REVERSIBILITY:**
   - Every modification must be accompanied by an easy revert mechanism (`Restore_Default_Settings.bat` or menu option `[6]`).
3. **BILINGUAL PARITY:**
   - All documentation, scripts, menus, and user messages must support both **Russian (RU)** and **English (EN)**.
4. **POLYGLOT SCRIPT ARCHITECTURE:**
   - Keep scripts as single-file polyglots: Line 1 CMD batch launcher + Lines 2+ PowerShell executing with UTF-8 encoding.
   - Do NOT split into fragile multi-file dependencies unless necessary.

---

## 3. Driver Architecture, OS Support & PnP IDs

### Target Operating Systems:
- **Windows 11**: 26H2, 25H2, 24H2, 23H2 (x64)
- **Windows 10**: 22H2, 21H2 (x64)
- **Architecture**: 64-bit native kernel with 32-bit WoW64 ASIO compatibility.

### Thesycon Driver Packages:
- **`ToppingUsbAudio.inf`**: Hardware ID `USB\VID_152A&PID_8750` (Class: `ToppingUsbAudio_sc`).
- **`ToppingUsbAudioks.inf`**: Hardware ID `TUSBAUDIO_ENUM\VID_152A&PID_8750&KS` (Class: `Media`, Kernel Streaming).
- Installation mechanism:
  ```powershell
  pnputil /add-driver "$PSScriptRoot\Driver\*.inf" /install
  pnputil /scan-devices
  ```
- ASIO support:
  - 64-bit: `ToppingUsbAudioasio_x64.dll` & `ToppingUsbAudioapi_x64.dll` in `System32` (registered via `regsvr32 /s`).
  - 32-bit: `ToppingUsbAudioasio.dll` & `ToppingUsbAudioapi.dll` in `SysWOW64` (registered via `SysWOW64\regsvr32.exe /s`).

---

## 4. How to Update to Newer Drivers

When a new driver release (e.g., v6.17+) is released:
1. Export the newly installed driver from Windows DriverStore:
   ```powershell
   pnputil /export-driver * "$tempDir"
   ```
2. Filter for `toppingusbaudio*.inf`, `.sys`, and `.cat` files and copy to the `Driver/` folder.
3. Verify Authenticode signatures with `Get-AuthenticodeSignature`.
4. Update version strings across `README.md` and `README_RU.md`.
