function Test-CALegacyAuthBlocked {
    Import-Module Microsoft.Graph.Identity.SignIns -ErrorAction Stop

    Write-Host "Running Conditional Access check: CA-002 Legacy authentication blocked" -ForegroundColor Cyan

    $Policies = Get-MgIdentityConditionalAccessPolicy -All

    $MatchingPolicies = @(
        $Policies | Where-Object {
            $Policy = $_

            $IsEnabled = $Policy.State -eq "enabled" -or $Policy.State -eq "enabledForReportingButNotEnforced"

            $TargetsLegacyClients = $false
            if ($Policy.Conditions -and $Policy.Conditions.ClientAppTypes) {
                $ClientApps = @($Policy.Conditions.ClientAppTypes)

                if ($ClientApps -contains "exchangeActiveSync" -or $ClientApps -contains "other") {
                    $TargetsLegacyClients = $true
                }
            }

            $BlocksAccess = $false
            if ($Policy.GrantControls -and $Policy.GrantControls.BuiltInControls) {
                $BlocksAccess = $Policy.GrantControls.BuiltInControls -contains "block"
            }

            $IsEnabled -and $TargetsLegacyClients -and $BlocksAccess
        }
    )

    $AffectedObjects = @(
        $MatchingPolicies | ForEach-Object {
            [PSCustomObject]@{
                id          = $_.Id
                displayName = $_.DisplayName
                state       = $_.State
            }
        }
    )

    if ($AffectedObjects.Count -gt 0) {
        return [PSCustomObject]@{
            id                   = "CA-002"
            category             = "Conditional Access"
            severity             = "Informational"
            title                = "Legacy authentication block policy detected"
            risk                 = "At least one Conditional Access policy appears to block legacy client authentication."
            affectedObjects      = $AffectedObjects
            evidence             = @{
                matchingPolicyCount = $AffectedObjects.Count
                checkedPolicies     = @($Policies).Count
                source              = "Microsoft Graph Conditional Access policies"
            }
            recommendation       = "Review the matching policy and confirm all legacy authentication paths are blocked."
            remediationAvailable = $false
            rollbackAvailable    = $false
        }
    }

    return [PSCustomObject]@{
        id                   = "CA-002"
        category             = "Conditional Access"
        severity             = "High"
        title                = "Legacy authentication is not blocked by Conditional Access"
        risk                 = "No enabled or report-only Conditional Access policy was found blocking legacy authentication. Legacy authentication can bypass modern authentication controls such as MFA and increases account compromise risk."
        affectedObjects      = @()
        evidence             = @{
            matchingPolicyCount = 0
            checkedPolicies     = @($Policies).Count
            source              = "Microsoft Graph Conditional Access policies"
        }
        recommendation       = "Create or confirm a Conditional Access policy blocking legacy authentication clients such as Exchange ActiveSync and other legacy clients."
        remediationAvailable = $false
        rollbackAvailable    = $false
    }
}
