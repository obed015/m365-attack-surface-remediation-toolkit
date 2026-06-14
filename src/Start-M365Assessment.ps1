. .\modules\Identity\Test-IdentityFindings.ps1

function Start-M365Assessment {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TenantName
    )

    Write-Host "Starting Microsoft 365 assessment for tenant: $TenantName" -ForegroundColor Cyan

    $AllFindings = @()

    $IdentityFindings = Test-IdentityFindings -TenantName $TenantName
    $AllFindings += $IdentityFindings

    $AssessmentResult = [PSCustomObject]@{
        tenantName      = $TenantName
        assessmentDate  = (Get-Date).ToString("s")
        totalFindings   = $AllFindings.Count
        findings        = $AllFindings
    }

    $AssessmentResult | ConvertTo-Json -Depth 10 | Set-Content -Path ".\data\findings.json"

    Write-Host "Assessment complete. Findings saved to .\data\findings.json" -ForegroundColor Green

    return $AssessmentResult
}
