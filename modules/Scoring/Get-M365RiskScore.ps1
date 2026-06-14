function Get-M365RiskScore {
    param(
        [Parameter(Mandatory = $true)]
        [array]$Findings
    )

    $SeverityWeights = @{
        Critical      = 20
        High          = 12
        Medium        = 7
        Low           = 3
        Informational = 0
    }

    $TotalExposurePoints = 0

    foreach ($Finding in $Findings) {
        if ($SeverityWeights.ContainsKey($Finding.severity)) {
            $TotalExposurePoints += $SeverityWeights[$Finding.severity]
        }
    }

    $OverallScore = 100 - $TotalExposurePoints

    if ($OverallScore -lt 0) {
        $OverallScore = 0
    }

    if ($OverallScore -gt 100) {
        $OverallScore = 100
    }

    $CriticalCount = @($Findings | Where-Object { $_.severity -eq "Critical" }).Count
    $HighCount = @($Findings | Where-Object { $_.severity -eq "High" }).Count
    $MediumCount = @($Findings | Where-Object { $_.severity -eq "Medium" }).Count
    $LowCount = @($Findings | Where-Object { $_.severity -eq "Low" }).Count
    $InformationalCount = @($Findings | Where-Object { $_.severity -eq "Informational" }).Count

    if ($CriticalCount -gt 0 -or $OverallScore -lt 50) {
        $RiskLevel = "Critical"
    }
    elseif ($HighCount -gt 0 -or $OverallScore -lt 75) {
        $RiskLevel = "High"
    }
    elseif ($MediumCount -gt 0 -or $OverallScore -lt 90) {
        $RiskLevel = "Medium"
    }
    elseif ($LowCount -gt 0) {
        $RiskLevel = "Low"
    }
    else {
        $RiskLevel = "Informational"
    }

    $IdentityFindings = @($Findings | Where-Object { $_.category -eq "Identity" })
    $IdentityExposurePoints = 0

    foreach ($Finding in $IdentityFindings) {
        if ($SeverityWeights.ContainsKey($Finding.severity)) {
            $IdentityExposurePoints += $SeverityWeights[$Finding.severity]
        }
    }

    $IdentityScore = 100 - $IdentityExposurePoints

    if ($IdentityScore -lt 0) {
        $IdentityScore = 0
    }

    if ($IdentityScore -gt 100) {
        $IdentityScore = 100
    }

    [PSCustomObject]@{
        overallScore           = $OverallScore
        riskLevel              = $RiskLevel
        totalExposurePoints    = $TotalExposurePoints
        criticalFindings       = $CriticalCount
        highFindings           = $HighCount
        mediumFindings         = $MediumCount
        lowFindings            = $LowCount
        informationalFindings  = $InformationalCount
        identityScore          = $IdentityScore
        identityExposurePoints = $IdentityExposurePoints
        scoringModel           = @{
            Critical      = 20
            High          = 12
            Medium        = 7
            Low           = 3
            Informational = 0
        }
    }
}
