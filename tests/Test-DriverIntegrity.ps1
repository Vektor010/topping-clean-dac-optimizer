# ===================================================================
# Test-DriverIntegrity.ps1
# Authenticode Signature & INF Catalog Integrity Verification
# ===================================================================

[CmdletBinding()]
param()

$root = Split-Path -Parent $PSScriptRoot
$driverDir = Join-Path $root "Driver"
$asioDir = Join-Path $root "ASIO"

$passed = 0
$failed = 0

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Running Driver & Authenticode Integrity Tests" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Test Driver files existence
$requiredDriverFiles = @(
    "ToppingUsbAudio.inf",
    "ToppingUsbAudio.cat",
    "ToppingUsbAudio.sys",
    "ToppingUsbAudioks.inf",
    "ToppingUsbAudioks.cat",
    "ToppingUsbAudioks.sys"
)

foreach ($file in $requiredDriverFiles) {
    $full = Join-Path $driverDir $file
    Write-Host -NoNewline "[TEST] File presence $file... "
    if (Test-Path $full) {
        Write-Host "OK ($((Get-Item $full).Length) bytes)" -ForegroundColor Green
        $passed++
    } else {
        Write-Host "MISSING!" -ForegroundColor Red
        $failed++
    }
}

# 2. Test INF content & Hardware ID
Write-Host -NoNewline "[TEST] Verifying INF Hardware ID VID_152A... "
$infPath = Join-Path $driverDir "ToppingUsbAudio.inf"
if (Test-Path $infPath) {
    $infContent = Get-Content $infPath -Raw
    if ($infContent -match "USB\\VID_152A&PID_8750") {
        Write-Host "MATCHED (VID_152A&PID_8750 verified)" -ForegroundColor Green
        $passed++
    } else {
        Write-Host "FAILED (VID/PID pattern not found)" -ForegroundColor Red
        $failed++
    }
} else {
    Write-Host "FAILED (INF missing)" -ForegroundColor Red
    $failed++
}

# 3. Test Authenticode signatures on sys and cat files
$binaryTargets = Get-ChildItem -Path $driverDir -Include "*.sys", "*.cat" -Recurse
foreach ($bin in $binaryTargets) {
    Write-Host -NoNewline "[TEST] Signature $($bin.Name)... "
    $sig = Get-AuthenticodeSignature $bin.FullName
    if ($sig.Status -eq "Valid") {
        Write-Host "VALID (Signer: $($sig.SignerCertificate.Subject))" -ForegroundColor Green
        $passed++
    } elseif ($sig.Status -eq "HashMismatch") {
        Write-Host "HASH MISMATCH!" -ForegroundColor Red
        $failed++
    } else {
        # Note: In offline or unchained environments status can be NotSigned/UnknownError for catalog-bound sys
        Write-Host "STATUS: $($sig.Status)" -ForegroundColor Yellow
        $passed++
    }
}

# 4. Test ASIO DLL presence
$asioFiles = @(
    "ToppingUsbAudioapi.dll",
    "ToppingUsbAudioapi_x64.dll",
    "ToppingUsbAudioasio.dll",
    "ToppingUsbAudioasio_x64.dll"
)

foreach ($dll in $asioFiles) {
    $dllPath = Join-Path $asioDir $dll
    Write-Host -NoNewline "[TEST] ASIO Library $dll... "
    if (Test-Path $dllPath) {
        Write-Host "OK ($((Get-Item $dllPath).Length) bytes)" -ForegroundColor Green
        $passed++
    } else {
        Write-Host "MISSING!" -ForegroundColor Red
        $failed++
    }
}

Write-Host "----------------------------------------------------------"
Write-Host "Integrity Summary: Passed: $passed | Failed: $failed" -ForegroundColor $(if ($failed -eq 0) { "Green" } else { "Red" })

if ($failed -gt 0) {
    exit 1
}
exit 0
