# 🎵 TOPPING USB DAC: Clean Optimizer & Bloatware Remover

<p align="center">
  <img src="https://img.shields.io/badge/Windows-10%20%7C%2011%20(24H2%20Ready)-0078D6?style=for-the-badge&logo=windows&logoColor=white" alt="Windows Compatibility" />
  <img src="https://img.shields.io/badge/Driver-Thesycon%20v6.16.0%20WHQL-28a745?style=for-the-badge&logo=soundcharts&logoColor=white" alt="Driver Version" />
  <img src="https://img.shields.io/badge/Background%20RAM-0%20MB-brightgreen?style=for-the-badge" alt="0 MB RAM" />
  <img src="https://img.shields.io/badge/Audio-Bit--Perfect%2032bit%2F768kHz-blue?style=for-the-badge" alt="Bit-Perfect Audio" />
  <img src="https://img.shields.io/badge/Language-English%20%7C%20Русский-orange?style=for-the-badge" alt="Bilingual" />
</p>

---

## 📖 Languages / Языки
* 🇺🇸 **[English](README.md)** (Current)
* 🇷🇺 **[Русская версия](README_RU.md)**

---

## ⚡ The Problem with Official TOPPING Installers
When downloading the official driver package from TOPPING's website, the installer bundles heavy and unnecessary software that permanently runs on your PC:

1. **`TOPPING Home.exe`** — A background web server based on **Node.js, Next.js, and Electron**. It occupies port `27149`, creates scheduled tasks, constantly scans audio streams every 30 seconds, and consumes system RAM and CPU cycles.
2. **`ToppingUsbAudioCpl.exe`** — A persistent system tray application that auto-starts with Windows. If any config file gets corrupted, it triggers startup error dialog popups on every boot.
3. **Background Latency Spikes** — Persistent polling services compete with games and audio playback for CPU execution time.

---

## 🚀 The Solution: 100% Pure Hardware Audio
**TOPPING Clean DAC Optimizer** extracts and installs **ONLY** the official, certified **Thesycon kernel drivers** directly into the native Windows `DriverStore` using standard Windows `PnPUtil`.

### Key Benefits:
* **0% Background CPU & 0 MB RAM:** Absolutely zero background processes, daemons, or resident tray icons.
* **100% Bit-Perfect Audio:** Supports all native sample rates up to **32-bit / 768 kHz** and native **DSD512**.
* **Clean ASIO Support:** Includes pure ASIO libraries for Foobar2000, AIMP, Cubase, FL Studio, and DAWs without tray bloatware.
* **Zero Boot Errors:** Nothing runs on startup, so nothing can crash or show error dialogs.
* **100% Reversible:** Restore the standard tray icon or uninstall drivers anytime with 1 click.

---

## 🎯 Supported Devices
Compatible with all TOPPING USB DACs and amplifiers powered by XMOS / Thesycon:
* **DX Series:** DX1, DX3 Pro+, DX5, DX7 Pro, DX9
* **E / L Series:** E30, E30 II, E50, E70, E70 Velvet
* **D Series:** D10, D10s, D10 Balanced, D50, D50s, D50 III, D70, D70 Pro, D90, D90SE, D90 III
* **Portable Series:** G5, NX4 DSD

---

## 📦 How to Use (Beginner Quick-Start Guide)

### Scenario A: Clean Windows Installation (Fresh PC)
1. Download the latest release: **[TOPPING-Clean-DAC-Optimizer.zip](https://github.com/Vektor010/topping-clean-dac-optimizer/releases/latest)**.
2. Plug your TOPPING DAC into any USB port.
3. Right-click **`Install_Clean_Driver.bat`** and choose **Run as Administrator** (or double-click; it will auto-request admin rights).
4. Done! The driver registers directly into Windows within 2 seconds. No reboot required.

### Scenario B: You Already Installed Full TOPPING Software & Want to Clean It Up
1. Double-click **`Topping_Debloat_Tweak.bat`**.
2. It instantly kills `TOPPING Home.exe` and `ToppingUsbAudioCpl.exe`, deletes them from Windows Startup, and disables scheduled tasks.
3. Your music and audio continue playing uninterrupted!

### Scenario C: Advanced Management (Bilingual Manager)
Launch **`Topping_DAC_Manager.bat`** to access an interactive menu:
* `[1]` Instant Debloat & Tray Remover.
* `[2]` Clean Kernel Driver Install.
* `[3]` Export Clean Driver from current Windows to portable backup folder.
* `[4]` Live Diagnostics & Hardware Audio Endpoint status.
* `[5]` Open Control Panel once (to adjust ASIO buffer size if needed).
* `[6]` Restore Tray Autostart (Revert tweak).
* `[7]` Complete Driver Uninstall.
* `[L]` Switch language (English ↔ Русский).

---

## 📊 Comparison Matrix

| Feature | Official TOPPING Setup | TOPPING Clean Optimizer |
| :--- | :---: | :---: |
| **Bit-Perfect 32-bit / 768 kHz Sound** | ✅ Yes | ✅ **Yes (100% identical)** |
| **Native ASIO / WASAPI / DirectSound** | ✅ Yes | ✅ **Yes** |
| **Driver Engine** | Thesycon v6.16.0 | **Thesycon v6.16.0 (Certified WHQL)** |
| **Resident Background Processes** | ❌ 2–3 processes | ✅ **0 processes** |
| **Memory Footprint (RAM)** | ❌ ~50–150 MB | ✅ **0 MB** |
| **System Tray Icon** | ❌ Always running | ✅ **Clean (No icon)** |
| **Background Web Server** | ❌ Node.js on port 27149 | ✅ **Disabled** |

---

## 📄 License & Credits
* Drivers are copyrighted by **Thesycon Systemsoftware & Consulting GmbH** and **TOPPING Technology Co., Ltd.**.
* Toolkit scripts and optimization architecture provided under the MIT License.
