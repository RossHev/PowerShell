# A quick-and-dirty script to add usernames from a text file (one per line) to an AD group

Import-Module ActiveDirectory

# Location of text file
$txtPath = 'C:\temp\UserList.txt'

# Name of AD group that users will be added to
$groupName = 'My AD Group'

# Make sure that text file exists
if (!(Test-Path $txtPath))
{
	Write-Error 'Text file not found or is not accessible'
	
	break
}

# Make sure that AD group exists
if (!(Get-ADGroup -Filter { SamAccountName -eq $groupName }))
{
	Write-Error 'Specified Active Directory group was not found'
	
	break
}

# Get usernames from text file, populate $userList
$userList = Get-Content $txtPath

# Add users to group
Add-ADGroupMember $groupName -Members $userList -Verbose