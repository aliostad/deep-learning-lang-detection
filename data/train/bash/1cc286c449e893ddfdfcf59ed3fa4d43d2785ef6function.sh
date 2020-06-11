#!/bin/bash

echo " Use of function in shell script"

#####Simple function
Hello() {
echo "Welcome function Hello"
}
###invoke function
Hello


#######Pass parameter to function

para() {
echo "Welcome $1 "
}

#####Invoke para

para Fahim


######Return value from function

ret(){
echo "Return value from function"
echo "Maximum numeric return is 255"
var=fahim
return 255

}

####invoke ret function
echo "Before calling ret $var"
ret
#echo "After Calling return $var"
####capture return value 
ret_value=$?

echo " Return value is $ret_value "
echo $var


