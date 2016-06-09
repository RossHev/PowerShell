# This script will calculate the md5 checksum of the specified file.
# If -Compare is specified, it will compare the that string with the calculated hash and inform you whether or not they match.

param ([Parameter(Mandatory = $true)]
	[string]$Path,
	[string]$Compare)

$md5Sum = (Get-FileHash -Algorithm MD5 -Path $Path).hash

if ($Compare)
{
	if ($md5Sum -eq $Compare)
	{
		Write-Output 'The hashes match'
	}
	else
	{
		Write-Output 'The hashes do not match'
	}
}

return $md5Sum