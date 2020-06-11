#Function to create load Balancer

Param (
    [String]$ELBName,
    [Tnteger]$ELBIntPort,
    [Integer]$ELBEc2Port
)



function CreateELB ($ELBName,$ELBIntPort,$ELBEc2Port)
{
  New-ELBLoadBalancer -LoadBalancerName $ELBName -Listeners @($HTTPListener, $HTTPSListener) -SecurityGroups @($sgId) -Subnets @($sn1Id, $sn2Id) -Scheme ‘internet-facing’
}

# Create HTTP Listener
$HTTPListener = New-Object -TypeName ‘Amazon.ElasticLoadBalancing.Model.Listener’
$HTTPListener.Protocol = ‘http’
$HTTPListener.InstancePort = 80
$HTTPListener.LoadBalancerPort = 80

#Create HTTPS Listener
$HTTPSListener = New-Object -TypeName ‘Amazon.ElasticLoadBalancing.Model.Listener’
$HTTPSListener.Protocol = ‘http’
$HTTPSListener.InstancePort = 443
$HTTPSListener.LoadBalancerPort = 80
$HTTPSListener.SSLCertificateId = ‘YourSSL’

# Create Load Balancer
New-ELBLoadBalancer -LoadBalancerName ‘YourLoadBalancerName’ -Listeners @($HTTPListener, $HTTPSListener) -SecurityGroups @($sgId) -Subnets @($sn1Id, $sn2Id) -Scheme ‘internet-facing’

# Create Load Balancer
New-ELBLoadBalancer -LoadBalancerName ‘YourLoadBalancerName’ -Listeners @($HTTPListener, $HTTPSListener) -SecurityGroups @(‘SecurityGroupId’) -Subnets @(‘subnetId1’, ‘subnetId2’) -Scheme ‘internet-facing’

# Associate Instances with Load Balancer
Register-ELBInstanceWithLoadBalancer -LoadBalancerName ‘YourLoadBalancerName’ -Instances @(‘instance1ID’, ‘instance2ID’)

# Create Application Cookie Stickiness Policy
New-ELBAppCookieStickinessPolicy -LoadBalancerName ‘YourLoadBalancerName’ -PolicyName ‘SessionName’ -CookieName ‘CookieName’

# Set the Application Cookie Stickiness Policy to Load Balancer
Set-ELBLoadBalancerPolicyOfListener -LoadBalancerName ‘YourLoadBalancerName’ -LoadBalancerPort 80 -PolicyNames ‘SessionName’


New-ELBLoadBalancer -LoadBalancerName my-test-loadbalancer -AvailabilityZone us-east-1b -Listener @{ LoadBalancerPort=80;InstancePort=80;Protocol="http";InstanceProtocol="http" }
