function Add-M365RunHistory {
    param(
        [Parameter(Mandatory = $true)]
        [object]$AssessmentResult
    )

    $HistoryPath = ".\data\run-history.json"

    if (-not (Test-Path ".\data")) {
        New-Item -Path ".\data" -ItemType Directory | Out-Null
    }

    if (-not (Test-Path $HistoryPath)) {
        @() | ConvertTo-Json -Depth 20 -AsArray | Set-Content -Path $HistoryPath
    }

    $ExistingHistoryRaw = Get-Content $HistoryPath -Raw

    if ([string]::IsNullOrWhiteSpace($ExistingHistoryRaw)) {
        $ExistingHistory = @()
    }
    else {
        $ExistingHistory = @($ExistingHistoryRaw | ConvertFrom-Json)
    }

    $RunId = Get-Date -Format "yyyyMMdd-HHmmss"

    $RunRecord = [PSCustomObject]@{
        runId                  = $RunId
        tenantName             = $AssessmentResult.tenantName
        assessmentDate         = $AssessmentResult.assessmentDate
        overallScore           = $AssessmentResult.summary.overallScore
        riskLevel              = $AssessmentResult.summary.riskLevel
        totalFindings          = $AssessmentResult.totalFindings
        criticalFindings       = $AssessmentResult.summary.criticalFindings
        highFindings           = $AssessmentResult.summary.highFindings
        mediumFindings         = $AssessmentResult.summary.mediumFindings
        lowFindings            = $AssessmentResult.summary.lowFindings
        informationalFindings  = $AssessmentResult.summary.informationalFindings
        totalExposurePoints    = $AssessmentResult.summary.totalExposurePoints
        identityScore          = $AssessmentResult.summary.identityScore
        identityExposurePoints = $AssessmentResult.summary.identityExposurePoints
    }

    $UpdatedHistory = @($ExistingHistory) + $RunRecord

    $UpdatedHistory |
        ConvertTo-Json -Depth 20 -AsArray |
        Set-Content -Path $HistoryPath

    Write-Host "Run history updated: $HistoryPath" -ForegroundColor Green

    return $RunRecord
}
