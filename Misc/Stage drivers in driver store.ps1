# This script will find driver inf files in the specified directory and stage them in the Windows driver store

# Path to inf files
$driverPath = 'C:\Drivers'

#region Error handling

# Confirm that path exists
if (!(Test-Path $driverPath))
{
	Write-Warning 'The specified path does not exist. Please confirm that you have the correct path.'
	
	break
}

# Confirm that shell is elevated
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator'))
{
	Write-Warning 'You do not have administrator rights. Please run PowerShell as administrator and try again.'
	
	break
}

#endregion

# Get all inf files within $driverPath
$infList = Get-ChildItem $driverPath -Recurse -Filter *.inf | Select-Object FullName

# Use pnputil to stage drivers in driver store
foreach ($inf in $infList)
{
	$cmd = -join ('pnputil -a "', $inf.FullName, '"')
	
	Invoke-Expression $cmd
}