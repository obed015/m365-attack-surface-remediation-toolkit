. $PSScriptRoot\Connect-M365Toolkit.ps1
. $PSScriptRoot\Get-M365ToolkitContext.ps1
. $PSScriptRoot\Start-M365Assessment.ps1
. $PSScriptRoot\Export-M365Report.ps1
. $PSScriptRoot\Export-M365DashboardData.ps1

. $PSScriptRoot\..\modules\Identity\Get-M365TenantUsers.ps1
. $PSScriptRoot\..\modules\Identity\Test-IdentityFindings.ps1
. $PSScriptRoot\..\modules\Identity\Test-DisabledUsersStillLicensed.ps1

. $PSScriptRoot\..\modules\Scoring\Get-M365RiskScore.ps1

. $PSScriptRoot\..\modules\RunHistory\Add-M365RunHistory.ps1
. $PSScriptRoot\..\modules\RunHistory\Get-M365RunHistory.ps1

Export-ModuleMember -Function Connect-M365Toolkit
Export-ModuleMember -Function Get-M365ToolkitContext
Export-ModuleMember -Function Start-M365Assessment
Export-ModuleMember -Function Export-M365Report
Export-ModuleMember -Function Export-M365DashboardData
Export-ModuleMember -Function Get-M365TenantUsers
Export-ModuleMember -Function Test-DisabledUsersStillLicensed
Export-ModuleMember -Function Get-M365RiskScore
Export-ModuleMember -Function Add-M365RunHistory
Export-ModuleMember -Function Get-M365RunHistory
