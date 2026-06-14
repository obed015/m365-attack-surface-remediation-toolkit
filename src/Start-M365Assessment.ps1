. .\modules\Identity\Test-IdentityFindings.ps1
. .\modules\Identity\Test-DisabledUsersStillLicensed.ps1
. .\modules\Scoring\Get-M365RiskScore.ps1

function Start-M365Assessment {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TenantName
    )

    Write-Host "Starting Microsoft 365 assessment for tenant: $TenantName" -ForegroundColor Cyan

    $AllFindings = @()

    $IdentityEngineCheck = Test-IdentityFindings -TenantName $TenantName
    $AllFindings += $IdentityEngineCheck

    $DisabledLicensedFinding = Test-DisabledUsersStillLicensed
    $AllFindings += $DisabledLicensedFinding

    $Summary = Get-M365RiskScore -Findings $AllFindings

    $AssessmentResult = [PSCustomObject]@{
        tenantName      = $TenantName
        assessmentDate  = (Get-Date).ToString("s")
        totalFindings   = $AllFindings.Count
        summary         = $Summary
        findings        = $AllFindings
    }

    $AssessmentResult | ConvertTo-Json -Depth 25 | Set-Content -Path ".\data\findings.json"

    Write-Host "Assessment complete. Findings saved to .\data\findings.json" -ForegroundColor Green
    Write-Host "Overall Score: $($Summary.overallScore)/100" -ForegroundColor Yellow
    Write-Host "Risk Level: $($Summary.riskLevel)" -ForegroundColor Yellow
    Write-Host "Exposure Points: $($Summary.totalExposurePoints)" -ForegroundColor Yellow

    return $AssessmentResult
}
