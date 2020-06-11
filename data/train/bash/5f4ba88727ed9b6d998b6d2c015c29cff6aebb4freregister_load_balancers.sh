#!/bin/bash
#
# Usage:
#   reregister_load_balancers.sh -s
#
# Description:
#   -s stsを利用して、AWSの環境変数を設定する
#
#   利用している環境変数
#     AWS_DEFAULT_REGION : aws-cli
#     AWS_ACCESS_KEY_ID : aws-cli
#     AWS_SECRET_ACCESS_KEY : aws-cli
#
#     DRY_RUN : dryrunモードで実行する
#     STAGE_LIST : 対象のLoadBalancerNameパターンを指定、改行で複数指定可能
#     EXCLUDE_STAGE : 除外したいLoadBalancerNameパターンを指定
#
##################################################
set -e 
set -o pipefail
##################################################
# PARAMETER
##################################################
FLG_S='FALSE'
while getopts 's' OPT
do
	case $OPT in
		's' )
		FLG_S='TRUE'
		;;
	esac
done
shift $(($OPTIND - 1))

### dry-run
FLG_D='FALSE'
if [ "${DRY_RUN}" == 'true' ];then
	FLG_D='TRUE'
fi

### sts
if [ "${FLG_S}" == 'TRUE' ];then
	. set_sts_credential.sh
fi

LOAD_BALANCERS_JSON=`aws elb describe-load-balancers \
	| jq -c -M '.LoadBalancerDescriptions[] | {LoadBalancerName:.LoadBalancerName, Instances:.Instances}'`

##################################################
# MAIN
##################################################
for stage in ${STAGE_LIST}
do
	load_balancers_count=0
	for load_balancer_json in ${LOAD_BALANCERS_JSON}
	do
		### 実行対象LoadBalancerNameの判別
		tag_name_exists=`echo -n "${load_balancer_json}" | jq -r --arg stage "${stage}-" 'select(contains({LoadBalancerName:$stage}))' | wc -l`
		exclude_tag_name_exists=`echo -n "${load_balancer_json}" | jq -r --arg stage "${EXCLUDE_STAGE}-" 'select(contains({LoadBalancerName:$stage}))' | wc -l`
		instances_exists=`echo -n "${load_balancer_json}" | jq -r '.Instances | length' | wc -l`
		if [ ${tag_name_exists} -eq 0 -o ${exclude_tag_name_exists} -ne 0 -o ${instances_exists} -eq 0 ];then
			continue
		fi

		echo "add: ${load_balancer_json}"
		load_balancers_count=`expr ${load_balancers_count} + 1`
		load_balancer=`echo -n "${load_balancer_json}" | jq -r '.LoadBalancerName'`
		instances=`echo -n "${load_balancer_json}" | jq -c -M '.Instances'`

		echo "aws elb deregister-instances-from-load-balancer --load-balancer-name ${load_balancer} --instances ${instances}"
		echo "aws elb register-instances-with-load-balancer --load-balancer-name ${load_balancer} --instances ${instances}"
		### dry-run
		if [ "${FLG_D}" == 'TRUE' ];then
			continue
		fi
		aws elb deregister-instances-from-load-balancer --load-balancer-name ${load_balancer} --instances ${instances}
		aws elb register-instances-with-load-balancer --load-balancer-name ${load_balancer} --instances ${instances}
	done

	### LoadBalancerNameにマッチなしの場合は警告出力
	if [ ${load_balancers_count} -eq 0 ];then
		echo "${stage} not matched!!"
		continue
	fi
done

