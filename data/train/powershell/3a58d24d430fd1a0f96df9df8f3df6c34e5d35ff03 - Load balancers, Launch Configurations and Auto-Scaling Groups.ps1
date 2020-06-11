# First we will create a load balancer and associate it with both of our subnets, so it is ready to intercept requests from clients to those subnets and route across them
# Our load balancer will listen for port 80 traffic, and forward it on to backend machines on the same port.
$listener = New-Object Amazon.ElasticLoadBalancing.Model.Listener("HTTP", 80, 80)

$loadBalancerParameters = @{
    LoadBalancerName = "defaultLoadBalancer";
    AvailabilityZone = @("ap-southeast-2a","ap-southeast-2b");
    Listener = $listener
    SecurityGroup = "sg-9489ecf1";
}

New-ELBLoadBalancer @loadBalancerParameters

Get-ELBLoadBalancer

# Remove-ELBLoadBalancer -LoadBalancerName "defaultLoadBalancer" -Force

# Create a launch configuration
# This defines the shapes of the instances that will be launched within an Auto Scale group
$launchConfigurationParameters = @{
    LaunchConfigurationName = "defaultScalingGroupLaunchConfiguration"
    ImageId = "ami-f9760dc3";
    InstanceType = "t2.micro";
    KeyName = "default_key_pair";
    SecurityGroup = "sg-9489ecf1";
}

New-ASLaunchConfiguration @launchConfigurationParameters

Get-ASLaunchConfiguration

# Remove-ASLaunchConfiguration -LaunchConfigurationName "defaultScalingGroupLaunchConfiguration"

# Lets take a look at what availability zones we have available in our region, we want to be across at least two of them to be resilient.
Get-EC2AvailabilityZone

# Create an auto scale group based on this launch configuration

$autoScaleGroupParameters = @{
    AutoScalingGroupName = "defaultScalingGroup";
    LaunchConfigurationName = "defaultScalingGroupLaunchConfiguration";
    LoadBalancerName = "defaultLoadBalancer";
    MinSize = 4;
    MaxSize = 8;
    AvailabilityZone = @("ap-southeast-2a","ap-southeast-2b");
}

New-ASAutoScalingGroup @autoScaleGroupParameters

Get-ASAutoScalingGroup

# Remove-ASAutoScalingGroup -AutoScalingGroupName "defaultScalingGroup" -ForceDelete $true -Force