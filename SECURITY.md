# Security Policy

## Supported Versions
Security updates and integrity fixes apply to the latest released version:

| Version | Supported |
| :--- | :---: |
| 1.0.x | Yes |
| < 1.0 | No |

## Driver Authenticode Integrity
The driver files bundled in the `Driver/` directory (`ToppingUsbAudio.inf`, `ToppingUsbAudio.sys`, `ToppingUsbAudio.cat`, etc.) are signed by Thesycon GmbH and WHQL-certified by Microsoft Corporation.
You can verify file integrity and digital signatures locally using PowerShell:
```powershell
Get-AuthenticodeSignature .\Driver\*.sys
Get-AuthenticodeSignature .\Driver\*.cat
```

## Reporting a Vulnerability
If you discover a security issue or unexpected privilege elevation vulnerability:
1. Do not open a public issue on GitHub.
2. Submit a private security advisory through GitHub Security Advisories or contact the repository owner directly.
3. Please provide device model, Windows build version, and reproduction steps.
