declare -A process status
process[1]="gcc itext.c -o itext"
process[2]="cp itext /usr/bin/"
process[3]="chmod +x /usr/bin/itext"
process[4]="rm itext"
status[1]=25
status[2]=50
status[3]=75
status[4]=100

case `whoami` in
root)
  for i in `seq 1 4`; do
    ${process[$i]} &>/dev/null
    if [[ $i == 1 ]] && [[ ! -f "./itext" ]]; then
      printf "\e[1;31mERROR\e[0m\terror compiling itext.c, please, report this bug.\n"
      exit
    fi
    printf "\rInstalling... [%i%%]" ${status[$i]}
    sleep 0.5
  done
  printf "\nDone\n"
  exit ;;
*)
  echo "Please run this with sudo privileges"
  exit
esac
