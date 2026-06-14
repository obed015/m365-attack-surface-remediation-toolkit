function Connect-M365Toolkit {
    param(
        [Parameter(Mandatory = $false)]
        [ValidateSet("ReadOnly", "Remediation")]
        [string]$Mode = "ReadOnly"
    )

    $Session = @{
        ConnectedAt = (Get-Date).ToString("s")
        Mode        = $Mode
        Remediation = if ($Mode -eq "Remediation") { "Enabled" } else { "Disabled" }
        TenantName  = $null
    }

    $Session | ConvertTo-Json -Depth 5 | Set-Content -Path ".\data\tenant-cache.json"

    Write-Host "Connected to M365 Toolkit session" -ForegroundColor Green
    Write-Host "Current Mode: $Mode"
    Write-Host "Remediation: $($Session.Remediation)"

    return $Session
}
