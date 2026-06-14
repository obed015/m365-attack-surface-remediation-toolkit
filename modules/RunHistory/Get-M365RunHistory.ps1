function Get-M365RunHistory {
    param(
        [Parameter(Mandatory = $false)]
        [int]$Last = 10
    )

    $HistoryPath = ".\data\run-history.json"

    if (-not (Test-Path $HistoryPath)) {
        Write-Warning "No run history found yet. Run Start-M365Assessment first."
        return
    }

    $HistoryRaw = Get-Content $HistoryPath -Raw

    if ([string]::IsNullOrWhiteSpace($HistoryRaw)) {
        Write-Warning "Run history file is empty."
        return
    }

    $ParsedHistory = $HistoryRaw | ConvertFrom-Json

    $CleanHistory = @()

    foreach ($Item in $ParsedHistory) {
        if ($Item.runId) {
            $CleanHistory += $Item
        }
        elseif ($Item.value) {
            foreach ($NestedItem in $Item.value) {
                if ($NestedItem.runId) {
                    $CleanHistory += $NestedItem
                }
            }
        }
    }

    $CleanHistory |
        Sort-Object assessmentDate -Descending |
        Select-Object -First $Last |
        Select-Object runId, tenantName, assessmentDate, overallScore, riskLevel, totalFindings, criticalFindings, highFindings, mediumFindings, lowFindings, informationalFindings, totalExposurePoints
}
