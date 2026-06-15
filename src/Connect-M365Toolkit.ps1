function Connect-M365Toolkit {
    param(
        [Parameter(Mandatory = $false)]
        [ValidateSet("ReadOnly", "Remediation")]
        [string]$Mode = "ReadOnly",

        [Parameter(Mandatory = $false)]
        [string]$TenantName
    )

    Import-Module Microsoft.Graph.Authentication -ErrorAction Stop

    if ($Mode -eq "ReadOnly") {
        $Scopes = @(
            "User.Read",
            "Directory.Read.All",
            "Group.Read.All",
            "Organization.Read.All",
            "Policy.Read.All"
        )

        $RemediationStatus = "Disabled"
    }

    if ($Mode -eq "Remediation") {
        Write-Warning "Remediation mode is not enabled in Phase 5."
        Write-Warning "Use ReadOnly mode until the remediation and rollback engine is built."
        return
    }

    Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
    Write-Host "Mode: $Mode"
    Write-Host "Requested scopes: $($Scopes -join ', ')"

    Connect-MgGraph -Scopes $Scopes -NoWelcome

    $GraphContext = Get-MgContext

    $Session = @{
        ConnectedAt = (Get-Date).ToString("s")
        Mode        = $Mode
        Remediation = $RemediationStatus
        TenantName  = $TenantName
        TenantId    = $GraphContext.TenantId
        Account     = $GraphContext.Account
        AuthType    = $GraphContext.AuthType
        Scopes      = $GraphContext.Scopes
    }

    $Session | ConvertTo-Json -Depth 10 | Set-Content -Path ".\data\tenant-cache.json"

    Write-Host "Connected to Microsoft Graph successfully." -ForegroundColor Green
    Write-Host "Current Mode: $Mode"
    Write-Host "Remediation: $RemediationStatus"
    Write-Host "Account: $($GraphContext.Account)"
    Write-Host "TenantId: $($GraphContext.TenantId)"

    return [PSCustomObject]$Session
}