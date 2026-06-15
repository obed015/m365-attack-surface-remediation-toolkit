# M365 Attack Surface & Remediation Toolkit

PowerShell-based Microsoft 365 attack surface assessment and remediation toolkit for hybrid identity and cloud security environments.

## Overview

This toolkit assesses Microsoft 365 tenant security posture across identity, access control, Conditional Access, collaboration, email, endpoint, audit, licensing, governance, reporting, and future remediation workflows.

The project currently focuses on safe read-only assessment, structured findings, risk scoring, dashboard-ready JSON, run history, before/after comparison, and Markdown reporting.

## Environment Foundation

This toolkit is built on top of a completed hybrid Microsoft 365 lab environment.

### Completed Lab Foundation

- Phase 1 — Core lab network
  - pfSense firewall/router
  - WAN internet
  - LAN `10.10.10.0/24`
  - LAB-DC01 static IP `10.10.10.10`
  - DHCP, DNS, and Active Directory working

- Phase 2 — Hybrid identity foundation
  - LAB-SYNC01 built
  - Joined to `ad.lab.local`
  - Microsoft Entra Connect Sync installed
  - Password Hash Sync working
  - AD users synced to Microsoft Entra ID
  - Cloud sign-in tested successfully

- Phase 3 — Licensing, groups, and access control
  - Synced AD groups used for cloud access control
  - Microsoft 365 Business Premium licensing tested
  - Group-based access and licensing controls validated

The hybrid environment was built separately before this toolkit project. The toolkit uses that lab tenant as the assessment target.

## Toolkit Build Status

### Completed

- Phase 4 — Core engine and project structure
- Phase 5 — Microsoft Graph read-only authentication
- Phase 6 — Identity assessment foundation
- Phase 7 — Scoring engine and risk summary
- Phase 8 — Dashboard-ready JSON and run history
- Phase 9 — Before/after comparison
- Phase 10 — Identity assessment expansion
- Phase 11 — Conditional Access assessment foundation

### Next

- Phase 12 — Conditional Access policy detail export

## Current Capabilities

- Connects to Microsoft Graph using delegated read-only authentication
- Captures tenant context and session metadata locally
- Runs structured Microsoft 365 security checks
- Generates standardised finding objects
- Calculates exposure points and overall tenant risk score
- Produces dashboard-ready JSON
- Maintains local run history
- Compares previous and current assessment scores
- Saves local assessment snapshots
- Generates Markdown assessment reports
- Keeps live tenant output files local only

## Implemented Assessment Areas

### Identity

- `ID-000` — Identity assessment engine initialized
- `ID-002` — Too many Global Administrators
- `ID-005` — Guest users present
- `ID-006` — Stale guest users
- `ID-007` — Disabled users still licensed

### Conditional Access

- `CA-001` — Admin MFA Conditional Access policy
- `CA-002` — Legacy authentication blocked by Conditional Access

## Current Working Commands

```powershell
Import-Module .\src\M365Toolkit.psm1 -Force

Connect-M365Toolkit -Mode ReadOnly -TenantName "ad-lab-m365"
Get-M365ToolkitContext

Start-M365Assessment -TenantName "ad-lab-m365"

Get-M365RunHistory
Compare-M365AssessmentRuns

Export-M365DashboardData
Export-M365Report -Format Markdown

Current Example Result

The current assessment output includes:

7 total findings
Identity and Conditional Access checks
Risk scoring
Before/after comparison
Dashboard-ready JSON
Markdown report output

Example scoring behaviour:

Previous Score: 81
Current Score: 57
Score Change: -24
Risk Level: High

The score changed because Conditional Access checks introduced two new high-severity findings.

Scoring Model

The toolkit uses exposure points to calculate risk.

Severity	Exposure Points
Critical	20
High	12
Medium	7
Low	3
Informational	0

Overall score:

Overall Score = 100 - Total Exposure Points

The score is capped between 0 and 100.

Security Model

The toolkit currently runs in read-only mode.

Current Microsoft Graph scopes include:

User.Read
Directory.Read.All
Group.Read.All
Organization.Read.All
Policy.Read.All

Remediation mode is intentionally disabled until confirmation, rollback, backup, and audit logging features are implemented.

Repository Data Safety

Live assessment output is intentionally excluded from Git tracking.

Ignored local output includes:

data/findings.json
data/run-history.json
data/dashboard.json
data/tenant-cache.json
data/snapshots/
reports/output/*

Only safe code, documentation, and future sanitised sample data should be committed.

Architecture Direction
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
Roadmap
Phase 12 — Conditional Access policy detail export
Phase 13 — Exchange Online security assessment
Phase 14 — SharePoint and OneDrive sharing assessment
Phase 15 — Teams exposure assessment
Phase 16 — Intune and device compliance assessment
Phase 17 — Defender and audit logging assessment
Phase 18 — Remediation planning
Phase 19 — Rollback generation
Phase 20 — Dashboard UI
Phase 21 — Attack path view
Phase 22 — GitHub polish, screenshots, and demo video