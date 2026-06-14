function Export-M365DashboardData {
    $FindingsPath = ".\data\findings.json"
    $HistoryPath = ".\data\run-history.json"
    $DashboardPath = ".\data\dashboard.json"

    if (-not (Test-Path $FindingsPath)) {
        Write-Error "No findings found. Run Start-M365Assessment first."
        return
    }

    $Assessment = Get-Content $FindingsPath -Raw | ConvertFrom-Json

    if (Test-Path $HistoryPath) {
        $RunHistory = @(Get-Content $HistoryPath -Raw | ConvertFrom-Json)
    }
    else {
        $RunHistory = @()
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
        topFindings = $TopFindings
        runHistory  = $RunHistory
    }

    $Dashboard |
        ConvertTo-Json -Depth 30 |
        Set-Content -Path $DashboardPath

    Write-Host "Dashboard data exported to $DashboardPath" -ForegroundColor Green

    return $DashboardPath
}
