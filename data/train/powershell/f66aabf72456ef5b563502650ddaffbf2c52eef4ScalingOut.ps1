
#This script will add an Auto Scaling group to an existing VPC

param
(
    [string][parameter(mandatory=$true)]$VpcId,
    [string][parameter(mandatory=$true)]$ElbSubnet1Id,
    [string][parameter(mandatory=$true)]$ElbSubnet2Id,
    [string][parameter(mandatory=$true)]$WebSubnet1Id,
    [string][parameter(mandatory=$true)]$WebSubnet2Id,
    [string][parameter(mandatory=$true)]$ElbSecurityGroupId,
    [string][parameter(mandatory=$true)]$DefaultSecurityGroupId,
    [string][parameter(mandatory=$false)]$InstanceType = 't1.micro',
    [string][parameter(mandatory=$false)]$AmiId,
    [string][parameter(mandatory=$true)]$UserData,
    [string][parameter(mandatory=$false)]$KeyName = 'MyKey'
)

If([System.String]::IsNullOrEmpty($AmiId)){ $AmiId = (Get-EC2ImageByName -Name 'WINDOWS_2012_BASE')[0].ImageId}

#Create the load balancer rules
$HTTPListener = New-Object 'Amazon.ElasticLoadBalancing.Model.Listener'
$HTTPListener.Protocol = 'http'
$HTTPListener.LoadBalancerPort = 80
$HTTPListener.InstancePort = 80

#Create a new load balancer
New-ELBLoadBalancer -LoadBalancerName 'WebLoadBalancer' -Subnets $ElbSubnet1Id, $ElbSubnet2Id -Listeners $HTTPListener -SecurityGroups $DefaultSecurityGroupId, $ElbSecurityGroupId

#Create Launch Config
$UserData = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($UserData)) 
New-ASLaunchConfiguration -LaunchConfigurationName 'MyLaunchConfig' -ImageId $AmiId -KeyName $KeyName -SecurityGroups $DefaultSecurityGroupId -UserData $UserData -InstanceType $InstanceType

#Create Auto Scaling Group
New-ASAutoScalingGroup -AutoScalingGroupName 'MyAutoScalingGroup' -LaunchConfigurationName 'MyLaunchConfig' -MinSize 2 -MaxSize 8 -DesiredCapacity 2 -LoadBalancerNames 'WebLoadBalancer' -VPCZoneIdentifier "$WebSubnet1Id, $WebSubnet2Id" -HealthCheckType 'ELB' -HealthCheckGracePeriod (30*60) -DefaultCooldown (30*60)

#Create dimension to measure CPU across the entire auto scaling group
$Dimension = New-Object 'Amazon.CloudWatch.Model.Dimension'
$Dimension.Name = 'AutoScalingGroupName'
$Dimension.Value = 'MyAutoScalingGroup'

#Create a policy to add two instances
$ScaleOutArn = Write-ASScalingPolicy -PolicyName 'MyScaleOutPolicy' -AutoScalingGroupName 'MyAutoScalingGroup' -ScalingAdjustment 2 -AdjustmentType 'ChangeInCapacity' -Cooldown (30*60)
Write-CWMetricAlarm -AlarmName 'AS75' -AlarmDescription 'Add capacity when average CPU within the auto scaling group is more than 75%' -MetricName 'CPUUtilization' -Namespace 'AWS/EC2' -Statistic 'Average' -Period (60*5) -Threshold 75 -ComparisonOperator 'GreaterThanThreshold' -EvaluationPeriods 2 -AlarmActions $ScaleOutArn -Unit 'Percent' -Dimensions $Dimension

#Create a policy to remove two instances
$ScaleInArn = Write-ASScalingPolicy -PolicyName 'MyScaleInPolicy' -AutoScalingGroupName 'MyAutoScalingGroup' -ScalingAdjustment -2 -AdjustmentType 'ChangeInCapacity' -Cooldown (30*60)
Write-CWMetricAlarm -AlarmName 'AS25' -AlarmDescription 'Remove capacity when average CPU within the auto scaling group is less than 25%' -MetricName 'CPUUtilization' -Namespace 'AWS/EC2' -Statistic 'Average' -Period (60*5) -Threshold 25 -ComparisonOperator 'LessThanThreshold' -EvaluationPeriods 2 -AlarmActions $ScaleInArn -Unit 'Percent' -Dimensions $Dimension

