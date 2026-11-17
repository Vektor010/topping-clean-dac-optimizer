# ===================================================================
# Run-AllTests.ps1
# Master test runner executing all project test suites
# ===================================================================

[CmdletBinding()]
param()

$testDir = $PSScriptRoot
$totalFailed = 0

Write-Host "==========================================================" -ForegroundColor Magenta
Write-Host " TOPPING CLEAN DAC OPTIMIZER - MASTER TEST SUITE" -ForegroundColor Magenta
Write-Host "==========================================================" -ForegroundColor Magenta

# 1. Run Syntax Test
& (Join-Path $testDir "Test-ScriptsSyntax.ps1")
if ($LASTEXITCODE -ne 0) { $totalFailed++ }

Write-Host ""

# 2. Run Driver Integrity Test
& (Join-Path $testDir "Test-DriverIntegrity.ps1")
if ($LASTEXITCODE -ne 0) { $totalFailed++ }

Write-Host ""
Write-Host "==========================================================" -ForegroundColor $(if ($totalFailed -eq 0) { "Green" } else { "Red" })
if ($totalFailed -eq 0) {
    Write-Host " ALL TEST SUITES PASSED (100% SUCCESS)" -ForegroundColor Green
    Write-Host "==========================================================" -ForegroundColor Green
    exit 0
} else {
    Write-Host " TEST SUITE FAILED ($totalFailed suites failed)" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
    exit 1
}
