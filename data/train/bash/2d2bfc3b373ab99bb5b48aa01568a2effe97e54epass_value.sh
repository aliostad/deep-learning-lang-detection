#!/bin/bash
clear 
# write a function
fresh(){
   # t stores $1 argument passed to fresh()
   t=$1
   echo "fresh(): \$0 is $0"
   echo "fresh(): \$1 is $1"
   echo "fresh(): \$t is $t"
   echo "fresh(): total args passed to me $#"
   echo "fresh(): all args (\$@) passed to me -\"$@\""
   echo "fresh(): all args (\$*) passed to me -\"$*\""
}
 
# invoke the function with "Tomato" argument
echo "**** calling fresh() 1st time ****"
fresh Tomato
 
# invoke the function with total 3 arguments
echo "**** calling fresh() 2nd time ****"
fresh Pradeep Manjunath Prasad
