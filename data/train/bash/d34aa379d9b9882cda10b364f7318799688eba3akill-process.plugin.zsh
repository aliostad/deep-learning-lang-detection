# Kill a process by name
function killname() {
  process_name=$1
  len=${#process_name}
  new_process_name="[${process_name:0:1}]${process_name:1:$len}"
  processes=$(ps -A | grep -i $new_process_name)
  awk '{ print "Found: "$0 }' <($processes)
  if [[ -n $processes ]]; then
    if [ $len = 1 ]; then
      pppurple "Do you wish to kill these processes? (y/n) "
    else
      pppurple "Do you wish to kill this process? (y/n) "
    fi
    read resp;
    case $resp in
      [Yy]* ) ps -A | grep -i $new_process_name | awk '{print $1}' | xargs kill -9;;
      [Nn]* ) pppurple "Goodbye"; return;;
    esac
  else
    ppred -i "No process found with the name "
    pplightred "$1"
  fi
}
