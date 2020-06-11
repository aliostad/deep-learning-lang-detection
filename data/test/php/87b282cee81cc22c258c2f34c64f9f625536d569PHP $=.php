<?php


//连续赋值很多编程语言均支持，比如：JAVASCRIPT。
//连续赋值不是指循环赋值，请看下例：
$a=$b=$c=200;
var_dump($a);
var_dump($b);
var_dump($c);
$a=$b=$c="test";
var_dump($a);
var_dump($b);
var_dump($c);
$a=$b=$c=array('aaaa','bbbb');
var_dump($a);
var_dump($b);
var_dump($c);
//PHP与JAVASCRIPT一样，是支持连续赋值的。在PHP官方文档中，有这样的例子：
$a = ($b = 4) + 5; // $a 现在成了 9，而 $b 成了 4。
//上例说明，连续赋值并不是简单的连续，你可以通过()来改变运算符的优先级。
//但远不只如此，PHP连续赋值还支持组合赋值运算。比如：
$a .= $b .= "foo";
//等价于
$a .= ($b .= "foo");
//也就是
$b .= "foo";
$a .= $b;
//那么，程序员均喜欢的，不用第三个变量，交换两个变量的值，PHP中，就可以用以下一行代码实现：
$a=20;
$b=30;
$a ^= $b ^= $a ^= $b;
var_dump($a);
var_dump($b);



?>
