function Test-TooManyGlobalAdmins {
    param(
        [Parameter(Mandatory = $false)]
        [int]$MaximumAllowedGlobalAdmins = 4
    )

    Import-Module Microsoft.Graph.Identity.DirectoryManagement -ErrorAction Stop

    Write-Host "Running identity check: ID-002 Too many Global Administrators" -ForegroundColor Cyan

    $GlobalAdminRole = Get-MgDirectoryRole -Filter "displayName eq 'Global Administrator'"

    if (-not $GlobalAdminRole) {
        return [PSCustomObject]@{
            id                   = "ID-002"
            category             = "Identity"
            severity             = "Informational"
            title                = "Global Administrator role not currently activated"
            risk                 = "The Global Administrator directory role was not returned as an active directory role."
            affectedObjects      = @()
            evidence             = @{
                globalAdminCount = 0
                source           = "Microsoft Graph directoryRoles"
            }
            recommendation       = "Confirm role activation and privileged role governance in Microsoft Entra ID."
            remediationAvailable = $false
            rollbackAvailable    = $false
        }
    }

    $GlobalAdmins = Get-MgDirectoryRoleMember -DirectoryRoleId $GlobalAdminRole.Id -All

    $AffectedObjects = @(
        $GlobalAdmins | ForEach-Object {
            [PSCustomObject]@{
                id                = $_.Id
                displayName       = $_.AdditionalProperties.displayName
                userPrincipalName = $_.AdditionalProperties.userPrincipalName
                objectType        = $_.AdditionalProperties.'@odata.type'
            }
        }
    )

    if ($AffectedObjects.Count -gt $MaximumAllowedGlobalAdmins) {
        $Severity = "High"
        $Title = "Too many Global Administrators"
        $Risk = "The tenant has more Global Administrator accounts than the configured threshold. Excessive Global Administrators increases the blast radius of account compromise and weakens privileged access governance."
        $Recommendation = "Reduce standing Global Administrator assignments. Use least privilege roles and Privileged Identity Management where available."
    }
    else {
        $Severity = "Informational"
        $Title = "Global Administrator count within configured threshold"
        $Risk = "The number of Global Administrator accounts is within the configured threshold."
        $Recommendation = "Continue reviewing privileged roles regularly and avoid assigning permanent Global Administrator access unless required."
    }

    return [PSCustomObject]@{
        id                   = "ID-002"
        category             = "Identity"
        severity             = $Severity
        title                = $Title
        risk                 = $Risk
        affectedObjects      = $AffectedObjects
        evidence             = @{
            globalAdminCount             = $AffectedObjects.Count
            maximumAllowedGlobalAdmins   = $MaximumAllowedGlobalAdmins
            source                       = "Microsoft Graph directoryRoles and directoryRoleMembers"
        }
        recommendation       = $Recommendation
        remediationAvailable = $false
        rollbackAvailable    = $false
    }
}
