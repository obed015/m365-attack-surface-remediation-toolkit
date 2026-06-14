function Get-M365ToolkitContext {
    $TenantCachePath = ".\data\tenant-cache.json"

    if (-not (Test-Path $TenantCachePath)) {
        Write-Warning "No toolkit session cache found. Run Connect-M365Toolkit first."
        return
    }

    $ToolkitSession = Get-Content $TenantCachePath | ConvertFrom-Json
    $GraphContext = Get-MgContext

    if (-not $GraphContext) {
        [PSCustomObject]@{
            Connected   = $false
            Mode        = $ToolkitSession.Mode
            Remediation = $ToolkitSession.Remediation
            TenantName  = $ToolkitSession.TenantName
            Message     = "Toolkit session exists, but Microsoft Graph is not connected."
        }

        return
    }

    [PSCustomObject]@{
        Connected   = $true
        Mode        = $ToolkitSession.Mode
        Remediation = $ToolkitSession.Remediation
        TenantName  = $ToolkitSession.TenantName
        TenantId    = $GraphContext.TenantId
        Account     = $GraphContext.Account
        AuthType    = $GraphContext.AuthType
        Scopes      = $GraphContext.Scopes
    }
}
