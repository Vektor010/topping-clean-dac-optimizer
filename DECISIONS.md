# Architectural Decision Records (ADR)

## ADR-001: Polyglot Single-File Architecture (BAT + PowerShell)
- **Status:** Accepted
- **Context:** Windows users double-click `.bat` files naturally. PowerShell `.ps1` files are blocked by default `Restricted` execution policies.
- **Decision:** All user-facing utilities are single-file polyglots: Line 1 launches CMD, which invokes PowerShell with `-ExecutionPolicy Bypass` and UTF-8 encoding reading the remainder of the file.
- **Consequences:** Eliminates external file dependencies, guarantees execution on stock Windows systems, maintains readable PowerShell syntax.

## ADR-002: Direct DriverStore Injection via PnPUtil
- **Status:** Accepted
- **Context:** Official vendor installers execute MSI packages bundled with secondary Node.js and Electron executables.
- **Decision:** Deploy drivers using Windows native `pnputil.exe /add-driver "$PSScriptRoot\Driver\*.inf" /install`.
- **Consequences:** Bypasses all MSI vendor bloatware, installs directly into `%SystemRoot%\System32\DriverStore`, guarantees clean uninstallability via `pnputil /delete-driver`.

## ADR-003: Decoupling ASIO Registration from the Tray App
- **Status:** Accepted
- **Context:** Thesycon installers tie ASIO registration to the tray application `ToppingUsbAudioCpl.exe`.
- **Decision:** Copy certified ASIO DLLs directly to `System32` / `SysWOW64` and register COM interfaces via native `regsvr32.exe /s`.
- **Consequences:** Bit-perfect low-latency DAW audio works without needing a resident tray icon running in the background.

## ADR-004: Termination and Disabling of TOPPING Home Node.js Server
- **Status:** Accepted
- **Context:** `TOPPING Home.exe` opens local TCP port `27149`, runs constantly, scans audio devices periodically, and consumes 80–150 MB RAM.
- **Decision:** Terminate process tree, delete registry run key `TOPPING Home`, and disable scheduled task `TOPPINGHome-AutoStart`.
- **Consequences:** Saves 100% of background memory footprint and eliminates DPC latency jitter during gaming.
