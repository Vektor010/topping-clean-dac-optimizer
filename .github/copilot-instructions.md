# GitHub Copilot Instructions

Refer to `AGENTS.md` for complete architectural rules, design patterns, and constraints.

## Guidelines Summary
- **Scope Restriction:** Only modify files inside `Topping-Clean-DAC-Optimizer`. NEVER touch drive D:.
- **Reversibility:** Every debloat action must be cleanly reversible via `Restore_Default_Settings.bat`.
- **Polyglot Pattern:** Batch files use the single-file polyglot pattern (BAT line 1 + PowerShell line 2+ in UTF-8).
- **Quality Standard:** Validate changes using `.\tests\Run-AllTests.ps1`.
