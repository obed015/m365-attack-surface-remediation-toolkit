. $PSScriptRoot\Connect-M365Toolkit.ps1
. $PSScriptRoot\Start-M365Assessment.ps1
. $PSScriptRoot\Export-M365Report.ps1

Export-ModuleMember -Function Connect-M365Toolkit
Export-ModuleMember -Function Start-M365Assessment
Export-ModuleMember -Function Export-M365Report
