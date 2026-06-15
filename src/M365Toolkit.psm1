. $PSScriptRoot\Connect-M365Toolkit.ps1
. $PSScriptRoot\Get-M365ToolkitContext.ps1
. $PSScriptRoot\Start-M365Assessment.ps1
. $PSScriptRoot\Export-M365Report.ps1
. $PSScriptRoot\Export-M365DashboardData.ps1

. $PSScriptRoot\..\modules\Identity\Get-M365TenantUsers.ps1
. $PSScriptRoot\..\modules\Identity\Test-IdentityFindings.ps1
. $PSScriptRoot\..\modules\Identity\Test-DisabledUsersStillLicensed.ps1
. $PSScriptRoot\..\modules\Identity\Test-TooManyGlobalAdmins.ps1
. $PSScriptRoot\..\modules\Identity\Test-GuestUsersPresent.ps1
. $PSScriptRoot\..\modules\Identity\Test-StaleGuestUsers.ps1

. $PSScriptRoot\..\modules\ConditionalAccess\Test-CAAdminMFAPolicy.ps1
. $PSScriptRoot\..\modules\ConditionalAccess\Test-CALegacyAuthBlocked.ps1

. $PSScriptRoot\..\modules\Scoring\Get-M365RiskScore.ps1

. $PSScriptRoot\..\modules\RunHistory\Add-M365RunHistory.ps1
. $PSScriptRoot\..\modules\RunHistory\Get-M365RunHistory.ps1

. $PSScriptRoot\..\modules\Comparison\Save-M365AssessmentSnapshot.ps1
. $PSScriptRoot\..\modules\Comparison\Compare-M365AssessmentRuns.ps1

Export-ModuleMember -Function Connect-M365Toolkit
Export-ModuleMember -Function Get-M365ToolkitContext
Export-ModuleMember -Function Start-M365Assessment
Export-ModuleMember -Function Export-M365Report
Export-ModuleMember -Function Export-M365DashboardData

Export-ModuleMember -Function Get-M365TenantUsers
Export-ModuleMember -Function Test-DisabledUsersStillLicensed
Export-ModuleMember -Function Test-TooManyGlobalAdmins
Export-ModuleMember -Function Test-GuestUsersPresent
Export-ModuleMember -Function Test-StaleGuestUsers

Export-ModuleMember -Function Test-CAAdminMFAPolicy
Export-ModuleMember -Function Test-CALegacyAuthBlocked

Export-ModuleMember -Function Get-M365RiskScore

Export-ModuleMember -Function Add-M365RunHistory
Export-ModuleMember -Function Get-M365RunHistory

Export-ModuleMember -Function Save-M365AssessmentSnapshot
Export-ModuleMember -Function Compare-M365AssessmentRuns
