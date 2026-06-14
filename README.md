# M365 Attack Surface & Remediation Toolkit

A local Microsoft 365 security assessment toolkit designed to evaluate identity, access control, collaboration, email, endpoint, audit, and governance risks across a Microsoft 365 tenant.

This project is built on top of a hybrid lab environment containing:

- pfSense firewall/router
- Windows Server Active Directory
- Microsoft Entra Connect Sync
- Synced AD users and groups
- Microsoft 365 Business Premium licensing
- Group-based access and licensing controls

## Current Status

### Completed Lab Foundation

- Phase 1: Core lab network
- Phase 2: Hybrid identity foundation
- Phase 3: Licensing, groups, and access control

### Toolkit Progress

- Phase 4: Toolkit core engine foundation

## Current Working Commands

```powershell
Import-Module .\src\M365Toolkit.psm1 -Force
Connect-M365Toolkit
Start-M365Assessment -TenantName "ad-lab-m365"
Export-M365Report -Format Markdown
```

## Current Output

The toolkit currently generates:

- Local session cache
- JSON findings output
- Markdown assessment report

## Next Phase

Phase 5 will add Microsoft Graph authentication in read-only mode.
