function Test-DisabledUsersStillLicensed {
    Import-Module Microsoft.Graph.Users -ErrorAction Stop

    Write-Host "Running identity check: ID-007 Disabled users still licensed" -ForegroundColor Cyan

    $Users = Get-MgUser -All -Property Id,DisplayName,UserPrincipalName,AccountEnabled,UserType,AssignedLicenses |
        Select-Object Id,DisplayName,UserPrincipalName,AccountEnabled,UserType,AssignedLicenses

    $DisabledLicensedUsers = $Users | Where-Object {
        $_.AccountEnabled -eq $false -and
        $_.AssignedLicenses -ne $null -and
        $_.AssignedLicenses.Count -gt 0
    }

    if (-not $DisabledLicensedUsers -or $DisabledLicensedUsers.Count -eq 0) {
        return [PSCustomObject]@{
            id                   = "ID-007"
            category             = "Identity"
            severity             = "Informational"
            title                = "No disabled users with active licenses detected"
            risk                 = "No disabled user accounts were found with active Microsoft 365 licenses."
            affectedObjects      = @()
            evidence             = @{
                checkedUsers          = $Users.Count
                disabledLicensedUsers = 0
            }
            recommendation       = "Continue monitoring disabled accounts as part of the joiner, mover, and leaver process."
            remediationAvailable = $false
            rollbackAvailable    = $false
        }
    }

    $AffectedObjects = @(
        $DisabledLicensedUsers | ForEach-Object {
            [PSCustomObject]@{
                displayName       = $_.DisplayName
                userPrincipalName = $_.UserPrincipalName
                accountEnabled    = $_.AccountEnabled
                licenseCount      = $_.AssignedLicenses.Count
            }
        }
    )

    return [PSCustomObject]@{
        id                   = "ID-007"
        category             = "Identity"
        severity             = "High"
        title                = "Disabled users still licensed"
        risk                 = "Disabled user accounts with active Microsoft 365 licenses indicate weak offboarding controls and unnecessary license consumption. If account lifecycle processes are inconsistent, stale accounts may remain in a risky or unmanaged state."
        affectedObjects      = $AffectedObjects
        evidence             = @{
            checkedUsers          = $Users.Count
            disabledLicensedUsers = $DisabledLicensedUsers.Count
            source                = "Microsoft Graph user assignedLicenses and accountEnabled properties"
        }
        recommendation       = "Review disabled accounts and remove unnecessary Microsoft 365 licenses after confirming business and retention requirements."
        remediationAvailable = $false
        rollbackAvailable    = $false
    }
}
