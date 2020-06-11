#!/bin/bash


ASG=`aws autoscaling describe-auto-scaling-groups --query AutoScalingGroups[].AutoScalingGroupName`

aws autoscaling update-auto-scaling-group --auto-scaling-group-name "$ASG" --min-size 0 --desired-capacity 0

aws ec2 wait instance-terminated

LB=`aws elb describe-load-balancers --query LoadBalancerDescriptions[].LoadBalancerName`

aws autoscaling detach-load-balancers --auto-scaling-group-name "$ASG" --load-balancer-names "$LB"

until aws autoscaling delete-auto-scaling-group --auto-scaling-group-name "$ASG"
do
	echo "retrying autoscale delete"
	sleep 2
done

LC=`aws autoscaling describe-launch-configurations --query LaunchConfigurations[].LaunchConfigurationName`

aws autoscaling delete-launch-configuration --launch-configuration-name "$LC"

aws elb delete-load-balancer --load-balancer-name "$LB"
