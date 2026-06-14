function Save-M365AssessmentSnapshot {
    param(
        [Parameter(Mandatory = $true)]
        [object]$AssessmentResult
    )

    $SnapshotFolder = ".\data\snapshots"

    if (-not (Test-Path $SnapshotFolder)) {
        New-Item -Path $SnapshotFolder -ItemType Directory | Out-Null
    }

    $RunId = Get-Date -Format "yyyyMMdd-HHmmss"
    $SnapshotPath = Join-Path $SnapshotFolder "assessment-$RunId.json"

    $AssessmentResult |
        ConvertTo-Json -Depth 30 |
        Set-Content -Path $SnapshotPath

    Write-Host "Assessment snapshot saved: $SnapshotPath" -ForegroundColor Green

    return $SnapshotPath
}
