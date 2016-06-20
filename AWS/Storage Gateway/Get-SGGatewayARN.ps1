# This script will get the ARN of the specified AWS Storage Gateway.
# If a region is specified, it will look only in that region.
# If no region is specified, it will loop through all regions until a match is found.

param ([Parameter(Mandatory = $true)]
	[string]$Name,
	[string]$Region,
	[switch]$IncludeRegion)

# AWS Storage Gateway regions. Regions can be reordered/removed in the interest of saving clock cycles.
$awsRegionList = 'us-east-1', 'us-west-1', 'us-west-2', 'eu-west-1', 'eu-central-1', 'ap-northeast-1', 'ap-northeast-2',
'ap-southeast-1', 'ap-southeast-2', 'sa-east-1'

# Create object if -IncludRegion is specified
if ($IncludeRegion) { $gatewayInfo = new-object psobject }

if ($region) # region specified, only the region in $Region will be searched
{
	$arn = (Get-SGGateway -Region $region | Where-Object GatewayName -eq $Name).GatewayArn
	
	if ($IncludeRegion) # -IncludeRegion specified
	{
		$gatewayInfo | Add-Member -MemberType NoteProperty -Name 'ARN' -Value $arn
		$gatewayInfo | Add-Member -MemberType NoteProperty -Name 'Region' -Value $Region
		
		return $gatewayInfo
	}
	else # -IncludeRegion not specified
	{
		return $arn
	}
}
else # region not specified, will loop through regions in $awsRegionList until a match is found
{
	foreach ($awsRegion in $awsRegionList)
	{
		$arn = (Get-SGGateway -Region $awsRegion | Where-Object GatewayName -eq $Name).GatewayArn
		
		# Exit loop when $arn is populated
		if ($arn)
		{
			if ($IncludeRegion) # -IncludeRegion specified
			{
				$gatewayInfo | Add-Member -MemberType NoteProperty -Name 'ARN' -Value $arn
				$gatewayInfo | Add-Member -MemberType NoteProperty -Name 'Region' -Value $AWSregion
				
				return $gatewayInfo
			}
			else # -IncludeRegion not specified
			{
				return $arn
			}
			break
		}
	}
}


