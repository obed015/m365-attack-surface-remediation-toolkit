function Test-CAAdminMFAPolicy {
    Import-Module Microsoft.Graph.Identity.SignIns -ErrorAction Stop

    Write-Host "Running Conditional Access check: CA-001 Admin MFA policy" -ForegroundColor Cyan

    $GlobalAdminRoleTemplateId = "62e90394-69f5-4237-9190-012177145e10"

    $Policies = Get-MgIdentityConditionalAccessPolicy -All

    $MatchingPolicies = @(
        $Policies | Where-Object {
            $Policy = $_

            $IsEnabled = $Policy.State -eq "enabled" -or $Policy.State -eq "enabledForReportingButNotEnforced"

            $HasMfaControl = $false
            if ($Policy.GrantControls -and $Policy.GrantControls.BuiltInControls) {
                $HasMfaControl = $Policy.GrantControls.BuiltInControls -contains "mfa"
            }

            $TargetsAdmins = $false

            if ($Policy.Conditions -and $Policy.Conditions.Users) {
                $IncludeRoles = @($Policy.Conditions.Users.IncludeRoles)
                $IncludeUsers = @($Policy.Conditions.Users.IncludeUsers)

                if ($IncludeRoles -contains $GlobalAdminRoleTemplateId -or $IncludeUsers -contains "All") {
                    $TargetsAdmins = $true
                }
            }

            $IsEnabled -and $HasMfaControl -and $TargetsAdmins
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
            id                   = "CA-001"
            category             = "Conditional Access"
            severity             = "Informational"
            title                = "Admin MFA Conditional Access policy detected"
            risk                 = "At least one Conditional Access policy appears to require MFA for administrators or broadly targeted users."
            affectedObjects      = $AffectedObjects
            evidence             = @{
                matchingPolicyCount = $AffectedObjects.Count
                checkedPolicies     = @($Policies).Count
                source              = "Microsoft Graph Conditional Access policies"
            }
            recommendation       = "Review the matching policies and confirm all privileged roles are protected with MFA."
            remediationAvailable = $false
            rollbackAvailable    = $false
        }
    }

    return [PSCustomObject]@{
        id                   = "CA-001"
        category             = "Conditional Access"
        severity             = "High"
        title                = "No admin MFA Conditional Access policy detected"
        risk                 = "No enabled or report-only Conditional Access policy was found requiring MFA for Global Administrators or broadly targeted users. This increases the risk of privileged account compromise."
        affectedObjects      = @()
        evidence             = @{
            matchingPolicyCount = 0
            checkedPolicies     = @($Policies).Count
            source              = "Microsoft Graph Conditional Access policies"
        }
        recommendation       = "Create or confirm a Conditional Access policy requiring MFA for administrators and privileged roles."
        remediationAvailable = $false
        rollbackAvailable    = $false
    }
}
