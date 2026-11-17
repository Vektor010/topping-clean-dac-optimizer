# Contributing Guidelines

Thank you for your interest in improving the TOPPING Clean DAC Optimizer toolkit.

## Core Project Principles
1. **Safety & Stability First:** Any tool or modification must be completely safe, non-destructive, and 100% reversible via `Restore_Default_Settings.bat`.
2. **Zero Bloat Policy:** No persistent background daemons, scheduled services, or memory resident utilities.
3. **Bilingual Parity:** User-facing scripts, menus, and documentation must provide full parity between Russian (RU) and English (EN).
4. **Polyglot Script Architecture:** Batch scripts use the single-file polyglot pattern (Line 1 CMD launcher + Line 2+ PowerShell in UTF-8).

## Submitting Pull Requests
1. Fork the repository and create your feature branch from `main`.
2. Ensure any added or modified batch script passes the syntax and static analysis tests in `tests/Test-ScriptsSyntax.ps1`.
3. Test changes locally across supported Windows environments (Windows 11 26H2/25H2/24H2 and Windows 10).
4. Submit a Pull Request detailing the changes, test results, and motivation.
