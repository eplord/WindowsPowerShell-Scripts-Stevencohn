<#
.SYNOPSIS
Update PowerShell to the latest version using winget.

.PARAMETER Silent
Suppresses output from winget.
#>

[CmdletBinding(SupportsShouldProcess = $true)]

param (
	[switch] $Silent
)

Begin
{
    function UpdatePS
    {
		# must use an array of arguments rather than splatting a hashtable
		# so we can pass double-dash arguments to winget

		$plist = @(
			'--id', 'Microsoft.PowerShell',
			'--source', 'winget',
			'--accept-package-agreements', '',
			'--accept-source-agreements', ''
		)

		if ($Silent) { $plist += '--silent', '' }
		
		winget upgrade @plist

		return $LASTEXITCODE
	}
}
Process
{
	Write-Host "Update PowerShell`n" -fo Blue

	$code = UpdatePS
	if ($code -eq 0)
	{
		Write-Host "`n... Done. Open a new console" -fo Green
	}
	else
	{
		Write-Host 'PowerShell is up to date'
	}
}
