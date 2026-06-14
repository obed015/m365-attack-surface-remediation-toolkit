# Progress Log

## Phase 4 — Toolkit Core Engine Foundation

**Date completed:** 2026-06-14

### Completed

- Created the base project folder structure.
- Created local PowerShell toolkit module.
- Built `Connect-M365Toolkit`.
- Built `Start-M365Assessment`.
- Built `Export-M365Report`.
- Created first standard finding object: `ID-000`.
- Exported first assessment result to JSON.
- Exported first Markdown report.

### Test Evidence

Commands successfully tested:

```powershell
Import-Module .\src\M365Toolkit.psm1 -Force
Connect-M365Toolkit
Start-M365Assessment -TenantName "ad-lab-m365"
Export-M365Report -Format Markdown
```

## Phase 5 — Microsoft Graph Authentication

**Date completed:** 2026-06-14

### Goal

Connect the local M365 Attack Surface & Remediation Toolkit to Microsoft Graph using delegated read-only authentication.

### Completed

- Installed required Microsoft Graph PowerShell modules.
- Updated `Connect-M365Toolkit` to use Microsoft Graph delegated authentication.
- Added read-only permission scopes.
- Blocked remediation mode until rollback and backup features are built.
- Added `Get-M365ToolkitContext`.
- Added first tenant read test using `Get-M365TenantUsers`.
- Confirmed the toolkit can read users from the Microsoft 365 tenant.

### Security Model

The toolkit uses read-only mode by default.

Requested scopes:

- User.Read
- Directory.Read.All
- Group.Read.All
- Organization.Read.All

Remediation mode remains disabled in Phase 5.

### Test Commands

```powershell
Import-Module .\src\M365Toolkit.psm1 -Force
Connect-M365Toolkit -Mode ReadOnly -TenantName "ad-lab-m365"
Get-M365ToolkitContext
Get-M365TenantUsers
```

### Status

Phase 5 completed successfully. The toolkit now connects to Microsoft Graph in read-only mode.
