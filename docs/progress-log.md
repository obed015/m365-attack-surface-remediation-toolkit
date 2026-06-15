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

## Phase 6 — Identity Assessment Module

**Date completed:** 2026-06-14

### Goal

Build the first real Microsoft 365 identity finding using Microsoft Graph tenant data.

### Completed

- Updated tenant user collection to include assigned license data.
- Created `Test-DisabledUsersStillLicensed`.
- Added finding `ID-007`.
- Integrated the identity finding into `Start-M365Assessment`.
- Improved Markdown report output to include affected objects and evidence.
- Updated findings catalog.

### Finding Added

`ID-007 — Disabled users still licensed`

### Security Model

Assessment only. No remediation actions are performed in this phase.

### Test Commands

```powershell
Import-Module .\src\M365Toolkit.psm1 -Force
Connect-M365Toolkit -Mode ReadOnly -TenantName "ad-lab-m365"
Test-DisabledUsersStillLicensed
Start-M365Assessment -TenantName "ad-lab-m365"
Export-M365Report -Format Markdown
```

### Status

Phase 6 completed successfully. The toolkit now performs its first real Microsoft 365 identity assessment.

## Phase 7 — Scoring Engine and Risk Summary

**Date completed:** 2026-06-14

### Goal

Add a scoring engine that calculates Microsoft 365 tenant exposure based on finding severity.

### Completed

- Created `modules/Scoring`.
- Created `Get-M365RiskScore`.
- Added severity weights:
  - Critical = 20
  - High = 12
  - Medium = 7
  - Low = 3
  - Informational = 0
- Integrated scoring into `Start-M365Assessment`.
- Added summary output to `data/findings.json`.
- Improved Markdown report with executive summary, risk summary, and category scores.

### Current Score Logic

Overall Score = 100 - Total Exposure Points

The final score is capped between 0 and 100.

### Current Expected Result

With the current findings:

- ID-000 = Informational = 0 points
- ID-007 = High = 12 points

Expected score: 88/100

### Status

Phase 7 completed successfully. The toolkit now has a dashboard-ready risk scoring model.

## Phase 8 — Dashboard-ready JSON and Run History

**Date completed:** 2026-06-14

### Goal

Add run history and dashboard-ready JSON output to support the future UI dashboard and before/after comparison.

### Completed

- Created `modules/RunHistory`.
- Added `Add-M365RunHistory`.
- Added `Get-M365RunHistory`.
- Integrated run history into `Start-M365Assessment`.
- Added `Export-M365DashboardData`.
- Created `data/run-history.json`.
- Created `data/dashboard.json`.
- Prepared JSON output for future dashboard UI.

### Current Dashboard Data

The toolkit now exports:

- Tenant name
- Assessment summary
- Overall score
- Risk level
- Top findings
- Run history

### Alignment With Original Project

This phase supports the original project requirements:

- Risk dashboard
- Run history
- Before/after evidence
- Local JSON results

### Status

Phase 8 completed successfully. The toolkit now produces dashboard-ready data and stores assessment history.

## Phase 6 — Before/After Comparison

**Date completed:** 2026-06-14

### Goal

Add before/after comparison capability using run history and archived assessment snapshots.

### Completed

- Created `modules/Comparison`.
- Added `Save-M365AssessmentSnapshot`.
- Added `Compare-M365AssessmentRuns`.
- Updated `Start-M365Assessment` to save assessment snapshots.
- Added score comparison between the latest two runs.
- Added finding-level comparison support using archived JSON snapshots.
- Updated dashboard JSON to include comparison data.

### Current Behaviour

The toolkit can now compare:

- Previous score
- Current score
- Score change
- Previous risk level
- Current risk level
- Fixed findings
- New findings
- Still-open findings

### Current Expected Result

Because no remediation has been performed yet:

Previous Score: 88
Current Score: 88
Improvement: 0
Risk Level: High to High

### Status

Phase 6 completed successfully. The toolkit can now compare assessment runs and prepare before/after evidence for reporting.

## Phase 10 — Identity Assessment Expansion

**Date completed:** 2026-06-14

### Goal

Expand the identity assessment module with privileged role and guest identity checks.

### Completed

- Added `ID-002 Too many Global Administrators`.
- Added `ID-005 Guest users present`.
- Added `ID-006 Stale guest users`.
- Updated module loader.
- Updated assessment runner.
- Updated findings catalog.
- Confirmed dashboard and report output support expanded findings.

### Status

Phase 10 completed successfully. The toolkit now performs broader identity exposure assessment across privileged roles, guest users, stale guests, and disabled licensed accounts.
