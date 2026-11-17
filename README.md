# 🎵 TOPPING USB DAC: Clean Optimizer & Bloatware Remover

<p align="center">
  <a href="https://github.com/Vektor010/topping-clean-dac-optimizer/releases/download/v1.0.0/Topping-Clean-DAC-Optimizer-v1.0.0.zip">
    <img src="https://img.shields.io/badge/DOWNLOAD_READY_RELEASE_(v1.0.0)-2ea44f?style=for-the-badge&logo=github&logoColor=white" alt="Download Release" height="38" />
  </a>
  <a href="https://github.com/Vektor010/topping-clean-dac-optimizer/releases">
    <img src="https://img.shields.io/badge/RELEASES_PAGE-0078D6?style=for-the-badge&logo=github&logoColor=white" alt="Releases" height="38" />
  </a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Windows-10%20%7C%2011%20(24H2%20Ready)-0078D6?style=flat-square&logo=windows&logoColor=white" alt="Windows Compatibility" />
  <img src="https://img.shields.io/badge/Driver-Thesycon%20v6.16.0%20WHQL-28a745?style=flat-square&logo=soundcharts&logoColor=white" alt="Driver Version" />
  <img src="https://img.shields.io/badge/Background%20RAM-0%20MB-brightgreen?style=flat-square" alt="0 MB RAM" />
  <img src="https://img.shields.io/badge/Audio-Bit--Perfect%2032bit%2F768kHz-blue?style=flat-square" alt="Bit-Perfect Audio" />
  <img src="https://img.shields.io/badge/Language-English%20%7C%20Русский-orange?style=flat-square" alt="Bilingual" />
</p>

---

## 📖 Languages / Языки
* 🇺🇸 **[English](README.md)** (Current)
* 🇷🇺 **[Русская версия](README_RU.md)**

---

## ⚡ QUICK START FOR BEGINNERS (30 Seconds)

### 📥 Step 1: Download the Ready Package
* **[👉 Click here to download `Topping-Clean-DAC-Optimizer-v1.0.0.zip` (870 KB)](https://github.com/Vektor010/topping-clean-dac-optimizer/releases/download/v1.0.0/Topping-Clean-DAC-Optimizer-v1.0.0.zip)**
* Extract the ZIP archive anywhere on your PC (e.g. Downloads or Desktop).

---

### 🎯 Step 2: Choose Your Scenario:

#### Scenario A: You ALREADY installed TOPPING software and want to remove the tray icon & background bloatware
1. Open the extracted folder.
2. Double-click **`Topping_Debloat_Tweak.bat`**.
3. **Result:**
   * The control panel icon immediately disappears from your system tray.
   * The heavy background `TOPPING Home.exe` server is terminated and removed from Windows Startup.
   * **Your audio continues playing at 100% bit-perfect quality without rebooting.**

#### Scenario B: You REINSTALLED WINDOWS (Clean PC)
1. Plug your TOPPING DAC into any USB port.
2. Run **`Install_Clean_Driver.bat`** (it will automatically ask for Administrator rights).
3. **Result:**
   * In 2 seconds, Windows `PnPUtil` registers the genuine certified driver directly into the Windows kernel `DriverStore`.
   * No reboot required — audio starts working immediately with full 32-bit / 768 kHz and DSD support.
   * Zero tray icons and zero background processes are installed.

#### Scenario C: You want an interactive menu with diagnostics and controls
1. Run **`Topping_DAC_Manager.bat`**.
2. An interactive bilingual console provides DAC connection checks, latency tests, 1-time buffer adjustments, driver exports, and instant rollbacks.

---

## 🔍 WHERE TO FIND OFFICIAL TOPPING DRIVERS?

> 💡 **IMPORTANT:** This repository and download archive **already bundle** the official certified latest driver (**Thesycon v6.16.0 WHQL** in the `Driver/` folder). You **do not need to search or download anything from the web** to get your DAC working right now!

If you want to verify the manufacturer's site or check for updates in the future, here are the direct official links:

### 🌐 Official Manufacturer Portals:
1. **Primary Global Support & Downloads Portal:**  
   👉 **[https://www.toppingaudio.com/support](https://www.toppingaudio.com/support)**
2. **Official Archive & Download Mirror:**  
   👉 **[https://www.tpdz.net/download](https://www.tpdz.net/download)**

---

### 📝 Step-by-Step Guide: How to Find Your DAC's Driver:
```
1. Open: https://www.toppingaudio.com/support
2. In the center search box, enter your DAC model name:
   -> For example: DX1, DX3 Pro+, E30 II, D10s, D50 III, D70, D90, G5
3. Click your device card in the search results.
4. Go to the "Drivers & Software" tab.
5. Click "Download" next to:
   "TOPPING USB Audio Driver (Windows 10/11)"
```

#### 🔑 The TOPPING Driver Secret (Why One Driver Fits All Models):
All TOPPING DACs (from entry-level DX1 to flagship D90) use the same **XMOS USB receiver** and licensed driver engine from German company **Thesycon GmbH** (Hardware ID `VID_152A`).
* This means **the driver package is 100% identical across all models**!
* Downloading the driver for DX1 gives you the exact same driver files as for E30 or D90.

---

## ⚡ WHAT'S WRONG WITH THE OFFICIAL INSTALLER?

When installing the vendor package from the official site, it installs heavy background bloatware onto your PC:
1. **`TOPPING Home.exe`** — A heavy local web server powered by **Node.js, Next.js, and Electron**. It listens on port `27149`, registers a scheduled autostart task, scans Windows audio streams every 30 seconds, and wastes RAM and CPU cycles.
2. **`ToppingUsbAudioCpl.exe`** — A resident system tray utility in Windows Startup. If any config file gets corrupted or deleted, it crashes on every boot with error popups (`Failed to open application configuration file`).
3. **Micro-stutters in Games** — Continuous audio endpoint polling can cause micro-latency spikes in competitive gaming (CS2, Valorant, Apex Legends).

### Our Solution:
We stripped all bloatware and preserved **only the pure Thesycon kernel driver** (`.inf`, `.sys`, `.cat`), installed directly into Windows `DriverStore`.

---

## 📊 Comparison: Official Topping Setup vs Our Tweak

| Feature | Official TOPPING Setup | TOPPING Clean Optimizer |
| :--- | :---: | :---: |
| **Bit-Perfect Audio (32-bit / 768 kHz)** | ✅ Yes | ✅ **Yes (100% identical)** |
| **DSD Support (DSD64 - DSD512)** | ✅ Yes | ✅ **Yes** |
| **ASIO / WASAPI / DirectSound** | ✅ Yes | ✅ **Yes** |
| **Kernel Driver Engine** | Thesycon v6.16.0 | **Thesycon v6.16.0 (WHQL)** |
| **Background Processes in Task Manager** | ❌ 2–3 processes | ✅ **0 processes** |
| **Memory Footprint (RAM)** | ❌ ~50–150 MB | ✅ **0 MB** |
| **System Tray Icon** | ❌ Always present | ✅ **Clean tray (No icon)** |
| **Background Node.js Web Server** | ❌ Active on port 27149 | ✅ **Disabled** |
| **Boot Error Dialog Risk** | ❌ Possible on config corruption | ✅ **0% (Nothing to crash)** |

---

## 📁 File Structure (What's Inside the Archive)

| File / Folder | Purpose |
| :--- | :--- |
| **`Topping_Debloat_Tweak.bat`** | **Primary 1-Click Tweak.** Closes tray icon, kills Node.js server, and removes them from startup. |
| **`Install_Clean_Driver.bat`** | **Clean Driver Installer.** For fresh Windows installs. Installs pure driver in 2 seconds. |
| **`Topping_DAC_Manager.bat`** | **Interactive Manager.** Diagnostics, latency test, 1-time buffer change, backup, and rollback. |
| **`Restore_Default_Settings.bat`** | **1-Click Rollback.** Restores standard tray panel and autostart if ever needed. |
| **`Driver/`** | Certified genuine Thesycon kernel driver files (`.inf`, `.sys`, `.cat`). |
| **`ASIO/`** | Pure ASIO direct output libraries for Foobar2000, AIMP, Cubase, FL Studio. |

---

## 🎯 Supported TOPPING Devices
Works with all TOPPING USB DACs and headphone amplifiers:
* **DX Series:** DX1, DX3 Pro+, DX5, DX5 Lite, DX7 Pro, DX7 Pro+, DX9
* **E / L Series:** E30, E30 II, E30 II Lite, E50, E70, E70 Velvet
* **D Series:** D10, D10s, D10 Balanced, D50, D50s, D50 III, D70, D70 Pro, D90, D90SE, D90 III
* **Portable Series:** G5, NX4 DSD

---

## 🔄 100% Reversible and Safe
Every change made by this toolkit is completely reversible:
* Simply run **`Restore_Default_Settings.bat`** (or choose menu item `[6]` in `Topping_DAC_Manager.bat`) to bring back the tray icon and startup entries at any time.

---

## 📄 License & Credits
* Drivers are copyrighted by **Thesycon Systemsoftware & Consulting GmbH** and **TOPPING Technology Co., Ltd.**.
* Toolkit scripts and optimization architecture provided under the MIT License.
