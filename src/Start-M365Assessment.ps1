. .\modules\Identity\Test-IdentityFindings.ps1
. .\modules\Identity\Test-DisabledUsersStillLicensed.ps1
. .\modules\Identity\Test-TooManyGlobalAdmins.ps1
. .\modules\Identity\Test-GuestUsersPresent.ps1
. .\modules\Identity\Test-StaleGuestUsers.ps1

. .\modules\ConditionalAccess\Test-CAAdminMFAPolicy.ps1
. .\modules\ConditionalAccess\Test-CALegacyAuthBlocked.ps1

. .\modules\Scoring\Get-M365RiskScore.ps1
. .\modules\RunHistory\Add-M365RunHistory.ps1
. .\modules\Comparison\Save-M365AssessmentSnapshot.ps1

function Start-M365Assessment {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TenantName
    )

    Write-Host "Starting Microsoft 365 assessment for tenant: $TenantName" -ForegroundColor Cyan

    $AllFindings = @()

    $AllFindings += Test-IdentityFindings -TenantName $TenantName
    $AllFindings += Test-DisabledUsersStillLicensed
    $AllFindings += Test-TooManyGlobalAdmins
    $AllFindings += Test-GuestUsersPresent
    $AllFindings += Test-StaleGuestUsers

    $AllFindings += Test-CAAdminMFAPolicy
    $AllFindings += Test-CALegacyAuthBlocked

    $Summary = Get-M365RiskScore -Findings $AllFindings

    $AssessmentResult = [PSCustomObject]@{
        tenantName      = $TenantName
        assessmentDate  = (Get-Date).ToString("s")
        totalFindings   = $AllFindings.Count
        summary         = $Summary
        findings        = $AllFindings
    }

    $AssessmentResult |
        ConvertTo-Json -Depth 30 |
        Set-Content -Path ".\data\findings.json"

    $SnapshotPath = Save-M365AssessmentSnapshot -AssessmentResult $AssessmentResult
    $RunRecord = Add-M365RunHistory -AssessmentResult $AssessmentResult

    Write-Host "Assessment complete. Findings saved to .\data\findings.json" -ForegroundColor Green
    Write-Host "Snapshot: $SnapshotPath" -ForegroundColor Green
    Write-Host "Run ID: $($RunRecord.runId)" -ForegroundColor Green
    Write-Host "Overall Score: $($Summary.overallScore)/100" -ForegroundColor Yellow
    Write-Host "Risk Level: $($Summary.riskLevel)" -ForegroundColor Yellow
    Write-Host "Exposure Points: $($Summary.totalExposurePoints)" -ForegroundColor Yellow

    return $AssessmentResult
}
