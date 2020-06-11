#!/bin/bash
#可用local在函数中声明局部变量，局部变量将仅在函数的作用范围内有效。
#此外，函数可以访问全局作用范围内的其他shell变量。如果一个局部变量和
#一个全局变量的名字相同，前者就会覆盖后者，但仅限于函数的作用范围之内。
sample_text="global variale"
foo(){
	local sample_text="local variable"
	echo "Function foo is executing"
	echo $sample_text
}

echo "script starting"
echo $sample_text

foo

echo "script ended"
echo $sample_text

exit 0
