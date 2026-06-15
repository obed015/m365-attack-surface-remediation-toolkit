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

## ID-002 — Too many Global Administrators

**Category:** Identity  
**Severity:** High when Global Administrator count exceeds configured threshold.

### Risk

Too many Global Administrators increases privileged access exposure and raises the blast radius of account compromise.

### Recommendation

Reduce standing Global Administrator assignments. Use least privilege roles and Privileged Identity Management where available.

---

## ID-005 — Guest users present

**Category:** Identity  
**Severity:** Medium when guest users exist.

### Risk

Guest users are normal in many Microsoft 365 environments, but unmanaged external identities can increase exposure.

### Recommendation

Review guest users, confirm business ownership, and remove unnecessary external identities.

---

## ID-006 — Stale guest users

**Category:** Identity  
**Severity:** Medium when guest users are older than the configured threshold.

### Risk

Stale guest accounts may retain access after collaboration has ended.

### Recommendation

Review stale guests and remove or disable unnecessary external identities.

---
