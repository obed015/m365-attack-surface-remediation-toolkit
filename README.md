@'
# M365 Attack Surface & Remediation Toolkit

PowerShell-based Microsoft 365 attack surface assessment and remediation toolkit for hybrid identity and cloud security environments.

## Overview

This toolkit is designed to assess Microsoft 365 tenant security posture across identity, access control, collaboration, email, endpoint, audit, licensing, governance, and remediation workflows.

The project currently focuses on safe read-only assessment, structured findings, risk scoring, reporting, dashboard-ready JSON, run history, and future before/after comparison.

## Environment Foundation

This toolkit was built and tested against a hybrid Microsoft 365 environment containing:

- pfSense firewall/router
- Windows Server Active Directory
- Microsoft Entra Connect Sync
- Synced AD users and groups
- Microsoft 365 Business Premium licensing
- Group-based access and licensing controls

The hybrid environment was built separately before this toolkit project. Therefore, this repository starts from the toolkit build phase.

## Current Status

### Completed

- Phase 1: Core engine and project structure
- Phase 2: Microsoft Graph authentication
- Phase 3: Identity assessment foundation
- Phase 4: Scoring model
- Phase 5: Dashboard-ready JSON and run history

### In Progress

- Phase 6: Before/after comparison

### Next

- Phase 7: Identity assessment expansion

## Current Capabilities

- Connects to Microsoft Graph in read-only mode
- Captures Graph context and tenant session metadata locally
- Reads tenant users using Microsoft Graph PowerShell
- Detects disabled users with active Microsoft 365 licenses
- Generates structured JSON findings
- Calculates risk score from finding severity
- Generates Markdown assessment reports
- Stores run history locally
- Exports dashboard-ready JSON
- Keeps live tenant output files local only

## Current Commands

```powershell
Import-Module .\src\M365Toolkit.psm1 -Force

Connect-M365Toolkit -Mode ReadOnly -TenantName "ad-lab-m365"
Get-M365ToolkitContext
Get-M365TenantUsers

Start-M365Assessment -TenantName "ad-lab-m365"
Get-M365RunHistory
Export-M365DashboardData
Export-M365Report -Format Markdown

Yes boss. Use this **clean PowerShell version**. It will fully replace your `README.md`.

First run:

```powershell
cd C:\Projects\m365-attack-surface-remediation-toolkit
```

Then paste this:

````powershell
@'
# M365 Attack Surface & Remediation Toolkit

PowerShell-based Microsoft 365 attack surface assessment and remediation toolkit for hybrid identity and cloud security environments.

## Overview

This toolkit is designed to assess Microsoft 365 tenant security posture across identity, access control, collaboration, email, endpoint, audit, licensing, governance, and remediation workflows.

The project currently focuses on safe read-only assessment, structured findings, risk scoring, reporting, dashboard-ready JSON, run history, and future before/after comparison.

## Environment Foundation

This toolkit was built and tested against a hybrid Microsoft 365 environment containing:

- pfSense firewall/router
- Windows Server Active Directory
- Microsoft Entra Connect Sync
- Synced AD users and groups
- Microsoft 365 Business Premium licensing
- Group-based access and licensing controls

The hybrid environment was built separately before this toolkit project. Therefore, this repository starts from the toolkit build phase.

## Current Status

### Completed

- Phase 1: Core engine and project structure
- Phase 2: Microsoft Graph authentication
- Phase 3: Identity assessment foundation
- Phase 4: Scoring model
- Phase 5: Dashboard-ready JSON and run history

### In Progress

- Phase 6: Before/after comparison

### Next

- Phase 7: Identity assessment expansion

## Current Capabilities

- Connects to Microsoft Graph in read-only mode
- Captures Graph context and tenant session metadata locally
- Reads tenant users using Microsoft Graph PowerShell
- Detects disabled users with active Microsoft 365 licenses
- Generates structured JSON findings
- Calculates risk score from finding severity
- Generates Markdown assessment reports
- Stores run history locally
- Exports dashboard-ready JSON
- Keeps live tenant output files local only

## Current Commands

```powershell
Import-Module .\src\M365Toolkit.psm1 -Force

Connect-M365Toolkit -Mode ReadOnly -TenantName "ad-lab-m365"
Get-M365ToolkitContext
Get-M365TenantUsers

Start-M365Assessment -TenantName "ad-lab-m365"
Get-M365RunHistory
Export-M365DashboardData
Export-M365Report -Format Markdown
````

## Security Model

The toolkit runs in read-only mode by default.

Current Microsoft Graph scopes:

* User.Read
* Directory.Read.All
* Group.Read.All
* Organization.Read.All

Remediation mode is intentionally disabled until backup, confirmation, rollback, and logging features are implemented.

## Findings Implemented

### ID-000 — Identity assessment engine initialized

Confirms that the local assessment engine can generate findings in the expected structure.

### ID-007 — Disabled users still licensed

Detects disabled Microsoft Entra ID user accounts that still have active Microsoft 365 licenses assigned.

## Scoring Model

The toolkit uses an internal attack-path exposure score.

| Severity      | Exposure Points |
| ------------- | --------------: |
| Critical      |              20 |
| High          |              12 |
| Medium        |               7 |
| Low           |               3 |
| Informational |               0 |

Overall score:

```text
Overall Score = 100 - Total Exposure Points
```

The score is capped between 0 and 100.

## Repository Data Safety

Live assessment output is intentionally excluded from Git tracking.

Ignored local output includes:

* `data/findings.json`
* `data/run-history.json`
* `data/dashboard.json`
* `data/tenant-cache.json`
* `data/snapshots/`
* `reports/output/*`

Safe sample data is stored under:

```text
data/samples/
```

## Toolkit Roadmap

* Phase 1: Core engine and project structure
* Phase 2: Microsoft Graph authentication
* Phase 3: Identity assessment foundation
* Phase 4: Scoring model
* Phase 5: Dashboard-ready JSON and run history
* Phase 6: Before/after comparison
* Phase 7: Identity assessment expansion
* Phase 8: Dashboard UI
* Phase 9: Conditional Access module
* Phase 10: Exchange Online module
* Phase 11: SharePoint and Teams module
* Phase 12: Intune module
* Phase 13: Defender and audit module
* Phase 14: Remediation and rollback
* Phase 15: Attack path simulator
* Phase 16: GitHub polish, screenshots, demo video

## Architecture Direction

```text
Desktop/Web UI
        ↓
PowerShell Assessment Engine
        ↓
Microsoft Graph / Microsoft 365 APIs
        ↓
Local JSON Results
        ↓
Risk Scoring Engine
        ↓
Report Generator
        ↓
Remediation + Rollback Engine
```

## Planned Next Steps

* Complete before/after comparison
* Add more identity findings
* Build dashboard UI
* Add Conditional Access assessment
* Add Exchange Online assessment
* Add SharePoint and Teams assessment
* Add Intune and Defender assessment
* Add remediation planning
* Add rollback generation
  '@ | Set-Content -Path ".\README.md" -Encoding UTF8
