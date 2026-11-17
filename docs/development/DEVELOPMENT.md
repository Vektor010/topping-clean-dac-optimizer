# Development & Contribution Guide

## Prerequisites
- Operating System: Windows 10 (21H2+) or Windows 11 (24H2, 25H2, 26H2).
- PowerShell: 5.1 (Built-in) or PowerShell 7+.
- Git for Windows.

## Repository Setup
```powershell
git clone https://github.com/Vektor010/topping-clean-dac-optimizer.git
cd topping-clean-dac-optimizer
```

## Running the Automated Test Suite
Before committing any changes, run the master test runner:
```powershell
.\tests\Run-AllTests.ps1
```
This executes:
1. `Test-ScriptsSyntax.ps1`: Extracts PowerShell bodies from all `.bat` files and performs an abstract syntax tree (AST) parse.
2. `Test-DriverIntegrity.ps1`: Validates file sizes, hardware IDs (`VID_152A`), and Microsoft Authenticode signatures.

## Creating a Release Archive
To generate the production ZIP release package:
```powershell
$files = Get-ChildItem -Path . -Exclude ".git", "*.zip"
Compress-Archive -Path $files.FullName -DestinationPath "Topping-Clean-DAC-Optimizer-v1.0.0.zip" -Force
```
