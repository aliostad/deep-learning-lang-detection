#!/bin/bash


repo_user="root";
repo_host="dist.roth.cm";
repo_port="22";
repo_dir="/opt/nginx/base/apps/dist";
ctl_dir="$HOME/.ssh/ctl";
ctl_path="$ctl_dir/%L-%r@%h:%p";
source "package.sh";
mkdir -p "$ctl_dir";
ssh -nNf -o "ControlMaster=yes" -o "ControlPath=$ctl_path" -p "$repo_port" "$repo_user@$repo_host";
for artifact in "${artifacts[@]}";
do
	group="roth/lib/js";
	cd ../"$artifact";
	if [ -f "project.sh" ];
	then
		source "project.sh";
		repo_dest="$repo_dir/$group/$artifact/$version";
		ssh -o "ControlPath=$ctl_path" -p "$repo_port" "$repo_user@$repo_host" "mkdir -p \"$repo_dest\"";
		scp -o "ControlPath=$ctl_path" -P "$repo_port" -r "target"/* "$repo_user@$repo_host":"$repo_dest";
	fi
done
ssh -O exit -o "ControlPath=$ctl_path" -p "$repo_port" "$repo_user@$repo_host";

