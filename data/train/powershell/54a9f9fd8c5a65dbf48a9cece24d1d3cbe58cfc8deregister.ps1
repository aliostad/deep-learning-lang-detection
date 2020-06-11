# Copyright (c) 2010 RightScale Inc
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Param($ACCESSKEYID,$SECRETACCESSKEY,$ELBNAME)

#stop and fail script when a command fails
$ErrorActionPreference="Stop"

#check to see if this powershell script was called from a Chef recipe
if (get-command Get-NewResource -ErrorAction SilentlyContinue)
{
	$accessKeyID = Get-NewResource access_key_id
	$secretAccessKey = Get-NewResource secret_access_key
    $elbName = Get-NewResource elb_name
    #check the required provider parameters
	if ($accessKeyID -eq $null -or $secretAccessKey -eq $null -or $elbName -eq $null){ 
		throw("Required parmeters are missing. Please provide: access_key_id, secret_access_key and elb_name")
	}
}
else
{
	#check the required script parameters
	if ($accessKeyID -eq $null -or $secretAccessKey -eq $null -or $elbName -eq $null){ 
		throw("Required parameters are missing`nUSAGE: {0} -ACCESSKEYID id -SECRETACCESSKEY key -ELBNAME name`n" -f $myinvocation.mycommand.name)
	}
}

$elb_config = New-Object -TypeName Amazon.ElasticLoadBalancing.AmazonElasticLoadBalancingConfig
	
$az = $env:EC2_PLACEMENT_AVAILABILITY_ZONE
$region = $az.substring(0,$az.length-1)

Write-Output "*** Instance is in region: [$region]"

[void]$elb_config.WithServiceURL("https://elasticloadbalancing.$region.amazonaws.com")

#create elb client based on the ServiceURL(region)
$client_elb=[Amazon.AWSClientFactory]::CreateAmazonElasticLoadBalancingClient($accessKeyID,$secretAccessKey,$elb_config)

$elb_deregister_request = New-Object -TypeName Amazon.ElasticLoadBalancing.Model.DeregisterInstancesFromLoadBalancerRequest

$instance_object=New-Object -TypeName Amazon.ElasticLoadBalancing.Model.Instance
$instance_object.InstanceId=$env:EC2_INSTANCE_ID

$elb_deregister_request.WithLoadBalancerName($elbName)
$elb_deregister_request.WithInstances($instance_object)

$elb_register_response=$client_elb.DeregisterInstancesFromLoadBalancer($elb_deregister_request)

write-output $elb_register_response