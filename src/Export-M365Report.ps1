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

        $Lines = @()
        $Lines += "# Microsoft 365 Attack Surface Assessment Report"
        $Lines += ""
        $Lines += "## Executive Summary"
        $Lines += ""
        $Lines += "The assessment identified $($Assessment.totalFindings) findings across the Microsoft 365 tenant."
        $Lines += ""
        $Lines += "Overall risk score: **$($Assessment.summary.overallScore)/100**"
        $Lines += ""
        $Lines += "Overall risk level: **$($Assessment.summary.riskLevel)**"
        $Lines += ""
        $Lines += "Total exposure points: **$($Assessment.summary.totalExposurePoints)**"
        $Lines += ""
        $Lines += "## Tenant"
        $Lines += $Assessment.tenantName
        $Lines += ""
        $Lines += "## Assessment Date"
        $Lines += $Assessment.assessmentDate
        $Lines += ""
        $Lines += "## Risk Summary"
        $Lines += ""
        $Lines += "| Severity | Count |"
        $Lines += "|---|---:|"
        $Lines += "| Critical | $($Assessment.summary.criticalFindings) |"
        $Lines += "| High | $($Assessment.summary.highFindings) |"
        $Lines += "| Medium | $($Assessment.summary.mediumFindings) |"
        $Lines += "| Low | $($Assessment.summary.lowFindings) |"
        $Lines += "| Informational | $($Assessment.summary.informationalFindings) |"
        $Lines += ""
        $Lines += "## Category Scores"
        $Lines += ""
        $Lines += "| Category | Score | Exposure Points |"
        $Lines += "|---|---:|---:|"
        $Lines += "| Identity | $($Assessment.summary.identityScore)/100 | $($Assessment.summary.identityExposurePoints) |"
        $Lines += ""
        $Lines += "## Findings"
        $Lines += ""

        foreach ($Finding in $Assessment.findings) {
            $Lines += "### $($Finding.id) - $($Finding.title)"
            $Lines += ""
            $Lines += "**Category:** $($Finding.category)  "
            $Lines += "**Severity:** $($Finding.severity)  "
            $Lines += ""
            $Lines += "**Risk:**"
            $Lines += $Finding.risk
            $Lines += ""
            $Lines += "**Affected Objects:**"
            $Lines += ""

            if ($Finding.affectedObjects -and $Finding.affectedObjects.Count -gt 0) {
                foreach ($Object in $Finding.affectedObjects) {
                    if ($Object.userPrincipalName) {
                        $Lines += "- $($Object.displayName) <$($Object.userPrincipalName)> - License Count: $($Object.licenseCount)"
                    }
                    else {
                        $Lines += "- $Object"
                    }
                }
            }
            else {
                $Lines += "- None detected"
            }

            $EvidenceJson = $Finding.evidence | ConvertTo-Json -Depth 10

            $Lines += ""
            $Lines += "**Evidence:**"
            $Lines += ""
            $Lines += '```json'
            $Lines += $EvidenceJson
            $Lines += '```'
            $Lines += ""
            $Lines += "**Recommendation:**"
            $Lines += $Finding.recommendation
            $Lines += ""
            $Lines += "**Remediation Available:** $($Finding.remediationAvailable)  "
            $Lines += "**Rollback Available:** $($Finding.rollbackAvailable)"
            $Lines += ""
        }

        $Lines | Set-Content -Path $OutputPath

        Write-Host "Markdown report exported to $OutputPath" -ForegroundColor Green
        return $OutputPath
    }
}
