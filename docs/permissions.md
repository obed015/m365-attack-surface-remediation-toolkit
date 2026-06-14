# Permissions Model

## Phase 5 — Read-Only Graph Authentication

The toolkit currently uses delegated Microsoft Graph authentication.

## Read-Only Mode

Used for assessment only.

### Current scopes

| Scope | Purpose |
|---|---|
| User.Read | Sign in and read current user profile |
| Directory.Read.All | Read directory users, groups, and directory objects |
| Group.Read.All | Read group membership and group details |
| Organization.Read.All | Read tenant organization details |

## Remediation Mode

Not enabled yet.

Remediation mode will only be added after:

- Backup logic
- Change confirmation
- Rollback generation
- Remediation logging
