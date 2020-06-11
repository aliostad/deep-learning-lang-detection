#!/bin/sh

InstanceId=`aws ec2 --profile $1 describe-instances --filter "Name=tag:Name,Values=$2" |jq -r '.Reservations[].Instances[].InstanceId'`

case "$3" in
   "deregister" ) 
      OutOfService=`aws elb --profile default describe-instance-health --load-balancer-name elb-test1 |jq -r ".InstanceStates[].State == \"OutOfService\""`
      if [ $OutOfService == true ]; then
         echo "OutOfService exists. To Exit."
         exit 1;
      fi

      LoadBalancerName=`aws elb --profile $1 describe-load-balancers |jq -r ".LoadBalancerDescriptions[] | select(.Instances[].InstanceId==\"$InstanceId\")" |jq -r '.LoadBalancerName'`
      echo $LoadBalancerName > ${InstanceId}.txt
      SubCommand="deregister-instances-from-load-balancer"
   ;;

   "register" )
      LoadBalancerName=`cat ${InstanceId}.txt`
      rm -f ${InstanceId}.txt
      SubCommand="register-instances-with-load-balancer"
   ;;
esac

for ELB in ${LoadBalancerName[@]}
do
      aws elb $SubCommand --load-balancer-name $ELB --instances $InstanceId
done
