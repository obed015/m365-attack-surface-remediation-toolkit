function Export-M365Report {
    param(
        [Parameter(Mandatory = $false)]
        [ValidateSet("Json", "Markdown")]
        [string]$Format = "Json"
    )

    $FindingsPath = ".\data\findings.json"

    if (-not (Test-Path $FindingsPath)) {
        Write-Error "No findings found. Run Start-M365Assessment first."
        return
    }

    $Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

    if ($Format -eq "Json") {
        $OutputPath = ".\reports\output\m365-assessment-report-$Timestamp.json"
        Copy-Item $FindingsPath $OutputPath
        Write-Host "JSON report exported to $OutputPath" -ForegroundColor Green
        return $OutputPath
    }

    if ($Format -eq "Markdown") {
        $Assessment = Get-Content $FindingsPath | ConvertFrom-Json
        $OutputPath = ".\reports\output\m365-assessment-report-$Timestamp.md"

        $Markdown = @"
# Microsoft 365 Attack Surface Assessment Report

## Tenant
$($Assessment.tenantName)

## Assessment Date
$($Assessment.assessmentDate)

## Total Findings
$($Assessment.totalFindings)

## Findings

"@

        foreach ($Finding in $Assessment.findings) {
            $Markdown += @"

### $($Finding.id) - $($Finding.title)

**Category:** $($Finding.category)  
**Severity:** $($Finding.severity)  

**Risk:**  
$($Finding.risk)

**Recommendation:**  
$($Finding.recommendation)

"@
        }

        $Markdown | Set-Content -Path $OutputPath

        Write-Host "Markdown report exported to $OutputPath" -ForegroundColor Green
        return $OutputPath
    }
}
