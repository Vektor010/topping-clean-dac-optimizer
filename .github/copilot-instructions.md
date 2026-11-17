# GitHub Copilot Instructions for TOPPING Clean DAC Optimizer

## Project Context
TOPPING Clean DAC Optimizer is a lightweight, zero-overhead Windows audio driver toolkit that isolates and installs only the certified Thesycon kernel drivers for TOPPING USB DACs without background bloatware (TOPPING Home Node.js server, tray app).

## Development Constraints
- Scope: Only modify files inside `Topping-Clean-DAC-Optimizer`. Never touch drive D:.
- Reversibility: Provide 100% reversible scripts for all actions.
- Scripting: Batch files use a polyglot BAT-PowerShell architecture with UTF-8 encoding.
- Bilingual: Maintain Russian and English parity across all user-facing documentation and scripts.
- See `AGENT.md` for complete technical details.
