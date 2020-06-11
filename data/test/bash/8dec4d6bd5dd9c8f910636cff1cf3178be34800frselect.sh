#!/bin/bash -x

ver="$1"
ldir="$( cd "$( dirname "$0" )" && pwd )"
rdir="$( cd "$( readlink -e -n "$0" | xargs dirname )" && pwd )"


lrule_cache="./rule_cache-${ver}"

if [[ -d "$lrule_cache" ]]
then
   declare -A model
   model_def="$(find "$ldir" -maxdepth 1 -type f -name 'model*\.aspect\.in' |
                xargs -I % sh -c "{ echo -n \"[\"%\"]=\"${lrule_cache}/model\$(basename '%' | sed -e 's/model\([[:digit:]]\{4\}\)\.aspect\.in/\1/').aspect\" \"; }")"
   eval model=($model_def)
 
   for i in "${!model[@]}"
   do
      ln -s -f "${model[$i]}" "$(basename "${i%.in}")"
   done
fi

