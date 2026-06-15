function Test-StaleGuestUsers {
    param(
        [Parameter(Mandatory = $false)]
        [int]$StaleAfterDays = 90
    )

    Import-Module Microsoft.Graph.Users -ErrorAction Stop

    Write-Host "Running identity check: ID-006 Stale guest users" -ForegroundColor Cyan

    $CutoffDate = (Get-Date).AddDays(-$StaleAfterDays)

    $GuestUsers = Get-MgUser -All -Filter "userType eq 'Guest'" -Property Id,DisplayName,UserPrincipalName,UserType,AccountEnabled,CreatedDateTime |
        Select-Object Id,DisplayName,UserPrincipalName,UserType,AccountEnabled,CreatedDateTime

    $StaleGuests = @(
        $GuestUsers | Where-Object {
            $_.CreatedDateTime -and ([datetime]$_.CreatedDateTime -lt $CutoffDate)
        }
    )

    $AffectedObjects = @(
        $StaleGuests | ForEach-Object {
            [PSCustomObject]@{
                displayName       = $_.DisplayName
                userPrincipalName = $_.UserPrincipalName
                userType          = $_.UserType
                accountEnabled    = $_.AccountEnabled
                createdDateTime   = $_.CreatedDateTime
                staleAfterDays    = $StaleAfterDays
            }
        }
    )

    if ($AffectedObjects.Count -gt 0) {
        return [PSCustomObject]@{
            id                   = "ID-006"
            category             = "Identity"
            severity             = "Medium"
            title                = "Stale guest users detected"
            risk                 = "Guest users older than the configured threshold were found. Stale guest accounts may retain access after collaboration has ended."
            affectedObjects      = $AffectedObjects
            evidence             = @{
                staleGuestCount = $AffectedObjects.Count
                staleAfterDays  = $StaleAfterDays
                cutoffDate      = $CutoffDate.ToString("s")
                source          = "Microsoft Graph guest users createdDateTime"
            }
            recommendation       = "Review stale guest accounts, confirm ownership and business need, then remove or disable unnecessary external identities."
            remediationAvailable = $false
            rollbackAvailable    = $false
        }
    }

    return [PSCustomObject]@{
        id                   = "ID-006"
        category             = "Identity"
        severity             = "Informational"
        title                = "No stale guest users detected"
        risk                 = "No guest users older than the configured stale threshold were found."
        affectedObjects      = @()
        evidence             = @{
            staleGuestCount = 0
            staleAfterDays  = $StaleAfterDays
            cutoffDate      = $CutoffDate.ToString("s")
            source          = "Microsoft Graph guest users createdDateTime"
        }
        recommendation       = "Continue monitoring guest lifecycle and external collaboration."
        remediationAvailable = $false
        rollbackAvailable    = $false
    }
}
