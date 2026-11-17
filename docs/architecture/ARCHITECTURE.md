# Architecture & Technical Design

## 1. System Overview
TOPPING Clean DAC Optimizer decouples the physical hardware audio layer from vendor user-mode utilities. It delivers pure Bit-Perfect audio directly through the Microsoft Windows Kernel Audio Subsystem with zero persistent resident background processes.

```
                 [ User Audio Application ]
            (Foobar2000, AIMP, Cubase, FL Studio, Games)
                           │
       ┌───────────────────┴───────────────────┐
       ▼                                       ▼
 [ Direct ASIO Driver ]              [ Windows Audio Engine (WASAPI) ]
(ToppingUsbAudioasio.dll)            (Audio Endpoint / Exclusive Mode)
       │                                       │
       └───────────────────┬───────────────────┘
                           ▼
             [ Thesycon Kernel Streaming ]
                 (ToppingUsbAudioks.sys)
                           │
                           ▼
               [ Thesycon Kernel Driver ]
                  (ToppingUsbAudio.sys)
                 Hardware ID: VID_152A
                           │
                           ▼
             [ XMOS USB Audio 2.0 Receiver ]
              (Hardware DAC Physical Device)
```

## 2. Kernel vs User-Mode Architecture

### Standard Vendor Installation (Bloated Stack)
1. **`TOPPING Home.exe`**: Local HTTP server listening on `127.0.0.1:27149`. Uses Node.js / Electron / Next.js. Polls endpoints every 30s. Memory footprint: 80–150 MB RAM.
2. **`ToppingUsbAudioCpl.exe`**: Win32 notification tray daemon. Reads `custom.ini` and `ToppingUsbAudioCpl.xml`. Crashes with modal dialog on missing XML entries.
3. **Scheduled Tasks**: `TOPPINGHome-AutoStart` running with SYSTEM privileges.

### Clean Kernel Architecture (Our Stack)
1. **Zero User-Mode Daemons**: No processes running in Task Manager. 0 MB RAM overhead.
2. **Kernel Registration**: Pure `.inf` and `.sys` staging directly into `%SystemRoot%\System32\DriverStore\FileRepository` via `PnPUtil`.
3. **On-Demand ASIO**: `ToppingUsbAudioasio_x64.dll` and `ToppingUsbAudioapi_x64.dll` are invoked solely when an audio application initializes the ASIO COM interface (`CLSID {B1CE8DCB-5CE5-4CE3-B9E3-2C01A9401C31}`). They terminate when playback stops.

## 3. Hardware Interfacing & PnP Identifiers
- **USB Vendor ID (VID)**: `0x152A` (Thesycon / TOPPING Technology Co., Ltd.)
- **Base Product ID (PID)**: `0x8750`
- **Class GUID**: `{4d36e96c-e325-11ce-bfc1-08002be10318}` (Media / Sound, video and game controllers)
- **Supported Audio Formats**:
  - PCM: 16-bit, 24-bit, 32-bit up to 768 kHz
  - DSD: Native DSD64, DSD128, DSD256, DSD512 via DoP (DSD over PCM) or ASIO Native
