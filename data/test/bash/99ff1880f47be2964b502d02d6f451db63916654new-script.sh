# Description:
# new-script.sh - generate a script template for a new shell script
# usage: new-script.sh <script name> {required parameters}

function append {
  echo "$1" >> $name
}

if [ -z $1 ]; then
  echo "Usage: $(basename $0) <script name> {required parameters}"
  echo "Generates a script template with some defaults"
else
  # gather information
  pcount=$(($? - 1))
  name=$1
  
  while shift && [ -n "$1" ]; do
    paramdesc="$paramdesc <$1>"
  done
  
  # don't ignore already existing files
  if [ -f $name ]; then
    read -p "A file with that name already exists. Should it be overwritten? (y/n)" yn
    [ "$yn" != "y" ] && exit 0
  fi
  
  # write file
  echo "#!/bin/bash" > $name
  append "# Description:"
  append "# $name - short description"
  append "# usage: $name$paramdesc"
  append "# Detailed Description"
  append ""
  append "# Script initialization"
  append "[ -z \$LINUX_UTILS_LIB ] && LINUX_UTILS_LIB=\$(dirname \$0)/lib # Resolve libs"
  append "[ -d \$LINUX_UTILS_LIB ] || {"
  append "  echo \"can't find linux_utils/lib directory!\""
  append "  echo \"possible fix: export \\\$LINUX_UTILS_LIB in .bashrc\""
  append "  exit 127"
  append "}"
  append ""
  append "# Script start"
  append "source \$LINUX_UTILS_LIB/colors.sh"
  append ""
  append "if [ \$# -lt $pcount ]; then"
  append "  echo \"usage: \$(basename \$0)$paramdesc\""
  append "  echo \"-- description --\""
  append "  exit 0"
  append "fi"
  append ""
  append ""
  append "# Script logic"
  append ""
  append ""
fi
