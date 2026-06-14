function Export-M365DashboardData {
    $FindingsPath = ".\data\findings.json"
    $HistoryPath = ".\data\run-history.json"
    $DashboardPath = ".\data\dashboard.json"

    if (-not (Test-Path $FindingsPath)) {
        Write-Error "No findings found. Run Start-M365Assessment first."
        return
    }

    $Assessment = Get-Content $FindingsPath -Raw | ConvertFrom-Json

    $RunHistory = @()

    if (Test-Path $HistoryPath) {
        $HistoryRaw = Get-Content $HistoryPath -Raw

        if (-not [string]::IsNullOrWhiteSpace($HistoryRaw)) {
            $ParsedHistory = $HistoryRaw | ConvertFrom-Json

            foreach ($Item in $ParsedHistory) {
                if ($Item.runId) {
                    $RunHistory += $Item
                }
                elseif ($Item.value) {
                    foreach ($NestedItem in $Item.value) {
                        if ($NestedItem.runId) {
                            $RunHistory += $NestedItem
                        }
                    }
                }
            }
        }
    }

    $Comparison = $null

    if ($RunHistory.Count -ge 2) {
        $SortedHistory = $RunHistory | Sort-Object assessmentDate -Descending
        $CurrentRun = $SortedHistory[0]
        $PreviousRun = $SortedHistory[1]

        $Comparison = [PSCustomObject]@{
            previousRunId     = $PreviousRun.runId
            currentRunId      = $CurrentRun.runId
            previousDate      = $PreviousRun.assessmentDate
            currentDate       = $CurrentRun.assessmentDate
            previousScore     = $PreviousRun.overallScore
            currentScore      = $CurrentRun.overallScore
            scoreChange       = $CurrentRun.overallScore - $PreviousRun.overallScore
            previousRiskLevel = $PreviousRun.riskLevel
            currentRiskLevel  = $CurrentRun.riskLevel
        }
    }

    $TopFindings = @(
        $Assessment.findings |
            Where-Object { $_.severity -ne "Informational" } |
            Select-Object id, category, severity, title, affectedObjects, recommendation
    )

    $Dashboard = [PSCustomObject]@{
        generatedAt = (Get-Date).ToString("s")
        tenantName  = $Assessment.tenantName
        summary     = $Assessment.summary
        comparison  = $Comparison
        topFindings = $TopFindings
        runHistory  = $RunHistory
    }

    $Dashboard |
        ConvertTo-Json -Depth 30 |
        Set-Content -Path $DashboardPath

    Write-Host "Dashboard data exported to $DashboardPath" -ForegroundColor Green

    return $DashboardPath
}
