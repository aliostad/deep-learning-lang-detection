<?php
/**
 * Created by PhpStorm.
 * User: iat
 * Date: 10/7/14
 * Time: 2:01 PM
 */
var_dump(null == false);//bool(true)
var_dump(false == '');//bool(true)
var_dump('' == 0);//bool(true)
var_dump(0 == null);//bool(true)

var_dump(1 == true);//bool(true)
var_dump(true == 'a');//bool(true)
var_dump(1 == 'a');//bool(false)

//null number,null转为0
/*var_dump(null == 0);//true
var_dump(null == 1);//false
var_dump(0 == null);//true
var_dump(1 == null);//false*/

//null string,null 转换成''再进行比较
/*var_dump(null == '');//true
var_dump(null == '0');//false
var_dump(null == '1');
var_dump(null == 'a');
var_dump('' == null);
var_dump('0' == null);
var_dump('1' == null);*/

//null bool, null转为false
/*var_dump(null == false);
var_dump(null == true);
var_dump(false == null);
var_dump(true == null);*/

//number string,string转为数字
/*var_dump(0 == '0');
var_dump(0 == '1');
var_dump(0 == 'a');
var_dump(0 == '0a');*/

//number bool，0为false,其它为true
/*var_dump(0 == false);
var_dump(1 == true);*/

/*var_dump('' == false);
var_dump('1' == true);
var_dump('a' == true);*/