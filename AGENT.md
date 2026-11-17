# Universal AI Agent Guidelines: TOPPING Clean DAC Optimizer

> **Standard:** Universal Open Source Standard 2026 (AI + Human Continuation).  
> **Target Audience:** Any AI assistant (Claude Code, ChatGPT, Gemini, Copilot, Cursor, Windsurf, Aider) or human developer contributing to this repository.

---

## 1. Project Overview & Philosophy
**TOPPING Clean DAC Optimizer** is an open-source, zero-overhead Windows audio driver packaging and optimization toolkit for **TOPPING USB Digital-to-Analog Converters (DACs)** powered by XMOS USB receiver chips and **Thesycon USB Audio Class 2.0 (UAC2)** kernel drivers.

### Core Problems Solved:
1. **Bloatware Elimination:** Official vendor installers package `TOPPING Home.exe` (Node.js/Next.js/Electron server running on `127.0.0.1:27149`) and `ToppingUsbAudioCpl.exe` in Windows Startup.
2. **Error Prevention:** Missing or corrupted configuration files (`custom.ini`, `ToppingUsbAudioCpl.xml`) cause modal error dialogs upon user login.
3. **Zero Latency Overhead:** Direct installation of certified `.inf` and `.sys` packages into Windows `DriverStore` via `PnPUtil` ensures pure hardware bit-perfect playback without background processes.

---

## 2. Invariants & Strict Rules

1. **DRIVE RESTRICTIONS:**
   - **NEVER** touch, write, read, or modify anything on the `D:` drive under any circumstances. Strictly operate within the active repository directory:
     `C:\Users\User\Documents\AutoSettingsPS\Topping-Clean-DAC-Optimizer`
2. **100% REVERSIBILITY:**
   - Every modification must be accompanied by an easy revert mechanism (`Restore_Default_Settings.bat` or menu option `[6]`).
3. **BILINGUAL PARITY:**
   - All documentation, scripts, menus, and user messages must support both **Russian (RU)** and **English (EN)**.
4. **POLYGLOT SCRIPT ARCHITECTURE:**
   - Keep scripts as single-file polyglots: Line 1 CMD batch launcher + Lines 2+ PowerShell executing with UTF-8 encoding.
   - Do NOT split into fragile multi-file dependencies unless necessary.
5. **MANDATORY VERIFICATION BEFORE ASSERTIONS:**
   - Never claim a task or bug fix is complete without running `tests/Run-AllTests.ps1` and confirming 100% pass output.

---

## 3. Single Source of Truth Documentation Map

| Document | Purpose |
| :--- | :--- |
| **[README.md](README.md)** | Primary international English product documentation |
| **[README_RU.md](README_RU.md)** | Full parity Russian documentation |
| **[ARCHITECTURE.md](ARCHITECTURE.md)** | System layers, kernel vs user-mode design, PnP identifiers |
| **[PROJECT_STATE.md](PROJECT_STATE.md)** | Current release status, test logs, next tasks |
| **[DECISIONS.md](DECISIONS.md)** | Architectural Decision Records (ADRs) |
| **[KNOWN_ISSUES.md](KNOWN_ISSUES.md)** | Known hardware and OS quirks with workarounds |
| **[ROADMAP.md](ROADMAP.md)** | 2026-2027 planned milestones and features |
| **[DEVELOPMENT.md](DEVELOPMENT.md)** | Developer environment setup and build instructions |
| **[CONTRIBUTING.md](CONTRIBUTING.md)** | Contribution standards and pull request guide |
| **[SECURITY.md](SECURITY.md)** | Security disclosure policy and Authenticode verification |

---

## 4. Essential Commands

```powershell
# Run the complete test suite (AST Syntax + Authenticode Integrity)
.\tests\Run-AllTests.ps1

# Check Git Status
git status

# Build Release ZIP Package
$files = Get-ChildItem -Path . -Exclude ".git", "*.zip"
Compress-Archive -Path $files.FullName -DestinationPath "Topping-Clean-DAC-Optimizer-v1.0.0.zip" -Force
```
