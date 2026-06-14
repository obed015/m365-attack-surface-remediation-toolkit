function Add-M365RunHistory {
    param(
        [Parameter(Mandatory = $true)]
        [object]$AssessmentResult
    )

    $HistoryPath = ".\data\run-history.json"

    if (-not (Test-Path ".\data")) {
        New-Item -Path ".\data" -ItemType Directory | Out-Null
    }

    $ExistingHistory = @()

    if (Test-Path $HistoryPath) {
        $ExistingHistoryRaw = Get-Content $HistoryPath -Raw

        if (-not [string]::IsNullOrWhiteSpace($ExistingHistoryRaw)) {
            $ParsedHistory = $ExistingHistoryRaw | ConvertFrom-Json

            foreach ($Item in @($ParsedHistory)) {
                if ($Item.runId) {
                    $ExistingHistory += $Item
                }
                elseif ($Item.value) {
                    foreach ($NestedItem in @($Item.value)) {
                        if ($NestedItem.runId) {
                            $ExistingHistory += $NestedItem
                        }
                    }
                }
            }
        }
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

    $CleanHistory = @()
    $CleanHistory += $ExistingHistory
    $CleanHistory += $RunRecord

    $JsonItems = @()

    foreach ($Run in $CleanHistory) {
        if ($Run.runId) {
            $CleanRun = [PSCustomObject]@{
                runId                  = $Run.runId
                tenantName             = $Run.tenantName
                assessmentDate         = $Run.assessmentDate
                overallScore           = $Run.overallScore
                riskLevel              = $Run.riskLevel
                totalFindings          = $Run.totalFindings
                criticalFindings       = $Run.criticalFindings
                highFindings           = $Run.highFindings
                mediumFindings         = $Run.mediumFindings
                lowFindings            = $Run.lowFindings
                informationalFindings  = $Run.informationalFindings
                totalExposurePoints    = $Run.totalExposurePoints
                identityScore          = $Run.identityScore
                identityExposurePoints = $Run.identityExposurePoints
            }

            $JsonItems += ($CleanRun | ConvertTo-Json -Depth 20)
        }
    }

    $Json = "[`n" + ($JsonItems -join ",`n") + "`n]"

    Set-Content -Path $HistoryPath -Value $Json

    Write-Host "Run history updated: $HistoryPath" -ForegroundColor Green

    return $RunRecord
}
