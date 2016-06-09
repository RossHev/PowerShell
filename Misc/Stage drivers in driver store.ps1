# Path to inf files
$driverPath = 'C:\Drivers'

# Get all inf files within $driverPath
$infList = Get-ChildItem $driverPath -Recurse -Filter *.inf | Select-Object FullName

# Use pnputil to stage drivers in driver store
foreach ($inf in $infList)
{
	$cmd = -join ('pnputil -a "', $inf.FullName, '"')
	
	Invoke-Expression $cmd
}