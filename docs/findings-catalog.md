# Findings Catalog

## Identity

### ID-007 — Disabled users still licensed

**Category:** Identity  
**Severity:** High  

### Description

Detects disabled Microsoft Entra ID user accounts that still have active Microsoft 365 licenses assigned.

### Risk

Disabled users with active licenses indicate weak joiner, mover, and leaver controls. This may lead to unnecessary license cost and poor account lifecycle governance.

### Evidence Collected

- Display name
- User principal name
- Account enabled status
- Assigned license count

### Recommendation

Review disabled accounts and remove unnecessary Microsoft 365 licenses after confirming business and retention requirements.

### Remediation Status

Assessment only in Phase 6. Remediation will be added later after backup, confirmation, rollback, and logging are built.
