# This script sets iSCSI timeout values in registry for AWS Storage Gateway per http://docs.aws.amazon.com/storagegateway/latest/userguide/CustomizeWindowsiSCSISettings.html

$ErrorActionPreference = 'SilentlyContinue'

# Confirm that shell is elevated
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator'))
{
	Write-Warning 'You do not have administrator rights. Please run PowerShell as administrator and try again.'
	
	break
}

# Get Microsoft iSCSI Initiator registry path
$path = (Get-ChildItem -Recurse 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4D36E97B-E325-11CE-BFC1-08002BE10318}' | ForEach-Object { Get-ItemProperty $_.pspath } `
| Where-Object driverdesc -EQ 'Microsoft iSCSI Initiator' | select pspath).pspath

# Set Microsoft iSCSI Initiator MaxRequestHold Time
Set-ItemProperty -Path $path\Parameters -Name MaxRequestHoldTime -Value '600'

# Set Disk TimeOutValue
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Disk' -Name TimeOutValue -Value '600'

# Confirm that changes were successful
if ((get-ItemProperty -Path $path\Parameters -Name MaxRequestHoldTime).MaxRequestHoldTime -ne '600' `
-or (get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Disk' -Name TimeOutValue).TimeOutValue -ne '600')
{
	Write-Warning 'Changes were unsuccessful'
}
else
{
	Write-Output "Changes were successful`n"
	
	# Prompt whether or not to reboot
	do
	{
		$answer = Read-Host 'Reboot required for changes to take effect. Would you like to reboot now?'
		
		if ('yes', 'no', 'y', 'n' -notcontains $answer) { Write-Output 'Please enter Yes or No' }
	}
	Until ('yes', 'no', 'y', 'n' -contains $answer)
	
	# Reboot if answer was yes
	if ('yes', 'y' -contains $answer)
	{
		Write-Output "`nRebooting computer..."
		Start-Sleep -Seconds 5
		Restart-Computer
	}
}
