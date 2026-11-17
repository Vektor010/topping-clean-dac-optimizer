# ===================================================================
# Test-ScriptsSyntax.ps1
# Automated PowerShell AST syntax validation for all repository scripts
# ===================================================================

[CmdletBinding()]
param()

$root = Split-Path -Parent $PSScriptRoot
$scripts = Get-ChildItem -Path $root -Filter "*.bat"

$passed = 0
$failed = 0

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Running Automated Script Syntax & AST Validation" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

foreach ($script in $scripts) {
    Write-Host -NoNewline "[TEST] Checking $($script.Name)... "
    try {
        $content = [System.IO.File]::ReadAllText($script.FullName, [System.Text.Encoding]::UTF8)
        $firstNewline = $content.IndexOf([char]10)
        if ($firstNewline -lt 0) {
            Write-Host "FAILED (No newline after CMD launcher)" -ForegroundColor Red
            $failed++
            continue
        }

        # Extract PowerShell body
        $psBody = $content.Substring($firstNewline + 1)

        # Parse AST
        $tokens = $null
        $errors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseInput($psBody, [ref]$tokens, [ref]$errors)

        if ($errors.Count -eq 0) {
            Write-Host "PASSED (0 AST errors, $($tokens.Count) tokens)" -ForegroundColor Green
            $passed++
        } else {
            Write-Host "FAILED ($($errors.Count) AST errors)" -ForegroundColor Red
            foreach ($err in $errors) {
                Write-Host "  -> Line $($err.Extent.StartLineNumber): $($err.Message)" -ForegroundColor Yellow
            }
            $failed++
        }
    } catch {
        Write-Host "ERROR: $_" -ForegroundColor Red
        $failed++
    }
}

Write-Host "----------------------------------------------------------"
Write-Host "AST Validation Summary: Passed: $passed | Failed: $failed" -ForegroundColor $(if ($failed -eq 0) { "Green" } else { "Red" })

if ($failed -gt 0) {
    exit 1
}
exit 0
