function Get-M365TenantUsers {
    Import-Module Microsoft.Graph.Users -ErrorAction Stop

    $Users = Get-MgUser -All -Property Id,DisplayName,UserPrincipalName,AccountEnabled,UserType,CreatedDateTime,AssignedLicenses |
        Select-Object Id,DisplayName,UserPrincipalName,AccountEnabled,UserType,CreatedDateTime,AssignedLicenses

    return $Users
}
