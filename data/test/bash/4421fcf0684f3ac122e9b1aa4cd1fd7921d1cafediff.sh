# Compare content of 2 directories or update centers.

if [ $# -ne 2 ]; then
  command_usage "diff <src_update_center_id|local_dir> <dst_update_center_id|local_dir>" >&2
  exit 1
fi

if [[ "$1" == */* ]]; then
  lhs_list="$(list_plugins_in_dir "$1")" # Local dir
else
  lhs_list="$(invoke_remote "list" "$1")" # Remote UC
fi

if [[ "$2" == */* ]]; then
  rhs_list="$(list_plugins_in_dir "$2")" # Local dir
else
  rhs_list="$(invoke_remote "list" "$2")" # Remote UC
fi

sdiff -s <(echo -e "$lhs_list") <(echo -e "$rhs_list")
