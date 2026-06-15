function Test-GuestUsersPresent {
    Import-Module Microsoft.Graph.Users -ErrorAction Stop

    Write-Host "Running identity check: ID-005 Guest users present" -ForegroundColor Cyan

    $GuestUsers = Get-MgUser -All -Filter "userType eq 'Guest'" -Property Id,DisplayName,UserPrincipalName,UserType,AccountEnabled,CreatedDateTime |
        Select-Object Id,DisplayName,UserPrincipalName,UserType,AccountEnabled,CreatedDateTime

    $AffectedObjects = @(
        $GuestUsers | ForEach-Object {
            [PSCustomObject]@{
                displayName       = $_.DisplayName
                userPrincipalName = $_.UserPrincipalName
                userType          = $_.UserType
                accountEnabled    = $_.AccountEnabled
                createdDateTime   = $_.CreatedDateTime
            }
        }
    )

    if ($AffectedObjects.Count -gt 0) {
        return [PSCustomObject]@{
            id                   = "ID-005"
            category             = "Identity"
            severity             = "Medium"
            title                = "Guest users present"
            risk                 = "Guest users exist in the tenant. Guest access is normal in many Microsoft 365 environments, but unmanaged guest accounts can increase exposure if access reviews, expiry, and external collaboration controls are weak."
            affectedObjects      = $AffectedObjects
            evidence             = @{
                guestUserCount = $AffectedObjects.Count
                source         = "Microsoft Graph users filtered by userType Guest"
            }
            recommendation       = "Review guest users, confirm business ownership, remove unnecessary guests, and consider access reviews for external identities."
            remediationAvailable = $false
            rollbackAvailable    = $false
        }
    }

    return [PSCustomObject]@{
        id                   = "ID-005"
        category             = "Identity"
        severity             = "Informational"
        title                = "No guest users detected"
        risk                 = "No guest users were found in the tenant."
        affectedObjects      = @()
        evidence             = @{
            guestUserCount = 0
            source         = "Microsoft Graph users filtered by userType Guest"
        }
        recommendation       = "Continue monitoring external identities and guest access."
        remediationAvailable = $false
        rollbackAvailable    = $false
    }
}
