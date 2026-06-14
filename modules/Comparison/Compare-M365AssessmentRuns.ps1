function Compare-M365AssessmentRuns {
    param(
        [Parameter(Mandatory = $false)]
        [string]$PreviousFindingsPath,

        [Parameter(Mandatory = $false)]
        [string]$CurrentFindingsPath = ".\data\findings.json"
    )

    $HistoryPath = ".\data\run-history.json"

    if (-not (Test-Path $CurrentFindingsPath)) {
        Write-Error "Current findings file not found. Run Start-M365Assessment first."
        return
    }

    $CurrentAssessment = Get-Content $CurrentFindingsPath -Raw | ConvertFrom-Json

    if ($PreviousFindingsPath -and (Test-Path $PreviousFindingsPath)) {
        $PreviousAssessment = Get-Content $PreviousFindingsPath -Raw | ConvertFrom-Json
    }
    else {
        if (-not (Test-Path $HistoryPath)) {
            Write-Warning "No run history found. At least two assessment runs are needed for score comparison."
            return
        }

        $HistoryRaw = Get-Content $HistoryPath -Raw

        if ([string]::IsNullOrWhiteSpace($HistoryRaw)) {
            Write-Warning "Run history file is empty. At least two assessment runs are needed."
            return
        }

        $ParsedHistory = $HistoryRaw | ConvertFrom-Json

        $History = @()

        foreach ($Item in $ParsedHistory) {
            if ($Item.runId) {
                $History += $Item
            }
            elseif ($Item.value) {
                foreach ($NestedItem in $Item.value) {
                    if ($NestedItem.runId) {
                        $History += $NestedItem
                    }
                }
            }
        }

        if ($History.Count -lt 2) {
            Write-Warning "Only one run exists. Run Start-M365Assessment again later to compare previous and current scores."
            return
        }

        $SortedHistory = $History | Sort-Object assessmentDate -Descending
        $CurrentRun = $SortedHistory[0]
        $PreviousRun = $SortedHistory[1]

        return [PSCustomObject]@{
            comparisonType       = "RunHistoryScoreOnly"
            previousRunId        = $PreviousRun.runId
            currentRunId         = $CurrentRun.runId
            previousDate         = $PreviousRun.assessmentDate
            currentDate          = $CurrentRun.assessmentDate
            previousScore        = $PreviousRun.overallScore
            currentScore         = $CurrentRun.overallScore
            scoreChange          = $CurrentRun.overallScore - $PreviousRun.overallScore
            previousRiskLevel    = $PreviousRun.riskLevel
            currentRiskLevel     = $CurrentRun.riskLevel
            previousHighFindings = $PreviousRun.highFindings
            currentHighFindings  = $CurrentRun.highFindings
            message              = "Score comparison generated from run history."
        }
    }

    $PreviousFindingIds = @($PreviousAssessment.findings | Select-Object -ExpandProperty id)
    $CurrentFindingIds = @($CurrentAssessment.findings | Select-Object -ExpandProperty id)

    $FixedFindingIds = @($PreviousFindingIds | Where-Object { $_ -notin $CurrentFindingIds })
    $NewFindingIds = @($CurrentFindingIds | Where-Object { $_ -notin $PreviousFindingIds })
    $StillOpenFindingIds = @($CurrentFindingIds | Where-Object { $_ -in $PreviousFindingIds })

    $FixedFindings = @(
        $PreviousAssessment.findings |
            Where-Object { $_.id -in $FixedFindingIds } |
            Select-Object id, category, severity, title
    )

    $NewFindings = @(
        $CurrentAssessment.findings |
            Where-Object { $_.id -in $NewFindingIds } |
            Select-Object id, category, severity, title
    )

    $StillOpenFindings = @(
        $CurrentAssessment.findings |
            Where-Object { $_.id -in $StillOpenFindingIds } |
            Select-Object id, category, severity, title
    )

    [PSCustomObject]@{
        comparisonType    = "FindingLevel"
        previousTenant    = $PreviousAssessment.tenantName
        currentTenant     = $CurrentAssessment.tenantName
        previousDate      = $PreviousAssessment.assessmentDate
        currentDate       = $CurrentAssessment.assessmentDate
        previousScore     = $PreviousAssessment.summary.overallScore
        currentScore      = $CurrentAssessment.summary.overallScore
        scoreChange       = $CurrentAssessment.summary.overallScore - $PreviousAssessment.summary.overallScore
        previousRiskLevel = $PreviousAssessment.summary.riskLevel
        currentRiskLevel  = $CurrentAssessment.summary.riskLevel
        fixedFindings     = $FixedFindings
        newFindings       = $NewFindings
        stillOpenFindings = $StillOpenFindings
        fixedCount        = $FixedFindings.Count
        newCount          = $NewFindings.Count
        stillOpenCount    = $StillOpenFindings.Count
    }
}
