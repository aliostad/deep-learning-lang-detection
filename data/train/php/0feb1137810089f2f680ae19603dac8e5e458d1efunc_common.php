<?php

/**
 *    isuiji_tally v0.1.0
 *    Plug-in for Discuz!
 *    Last Updated: 2013-10-20
 *    Author: shumyun
 *    Copyright (C) 2011 - forever isuiji.com Inc
 */

if(!defined('IN_DISCUZ')) {
	exit('Access Denied');
}

/**
 * 测试金额
 * @param float_type $cash
 */
function func_test_cash($cash) {
	if(!preg_match("/^\+?[0-9]+(.[0-9]{0,2})?$/", $cash) || $cash<=0)
		return false;
	return true;
}

/**
 * 初始化月中每天的数据
 * @param array_type $adata
 * @param int_type $daycount
 */
function func_setdefaultdaydata(&$adata, $daycount) {
	foreach ($adata as $k => $v) {
		$i = 0;
		while($i < $daycount) {
			$adata[$k][$i] = 0;
			$i++;
		}
	}
}

/**
 * 用户参数转换
 */
function UserParam_strtoarr($type) {
	$arr = array();
	switch($type) {
		case 'pay':
			$arr[0] = 'paytype';
			$arr[1] = 'categorytype';
			break;
		case 'earn':
			$arr[0] = 'earntype';
			$arr[1] = 'categorytype';
			break;
		case 'transfer':
			$arr[0] = 'categorytype';
			break;
		case 'borrow':
		case 'loan':
		case 'repay':
		case 'debt':
			$arr[0] = 'loandebt';
			$arr[1] = 'categorytype';
			break;
		default:
			return false;
	}
	return $arr;
}
 
/**
 * 账单名称转换(sqlstring <==> array)
 */
define('TITLE_OBJ', 0);
define('TITLE_ARR', 1);

function title_strtoarr($sqlstr, &$array) {
	if(!isset($sqlstr) || !empty($array)) return false;
	
	$strlength = strlen($sqlstr);
	if($sqlstr[0] !== '[' || $sqlstr[$strlength-1] !== ']') return false;
	
	$tmp = 0;
	$tmpstr = substr($sqlstr, 1, $strlength-2);
		
	$pointer =& $array;
	$pointer = Array();
	
	for ($i=0; $i<$strlength; $i++) {
	    switch ($tmpstr[$i]) {
	    	case '[':
	    		if($i <= $tmp) return false;

	    		$curstr = substr($tmpstr, $tmp, $i-$tmp);
	    		$pointer[$curstr] = Array('@parent' => &$pointer);
	    		$pointer =& $pointer[$curstr];
	    		$tmp = $i+1;//echo $curstr.'[';
	    		break;
	    	case '{':
	    		$ids = count($pointer);
	    		$pointer[$ids] = Array('@parent' => &$pointer);
	    		$pointer =& $pointer[$ids];
	    		$tmp = $i+1;//echo '{';
	    		break;
	    	case ',':
	    		$ids = count($pointer);
	    		if($tmp !== $i) {
	    			$curstr = substr($tmpstr, $tmp, $i-$tmp);//echo $curstr;
	    			if($ids == 1) //处理名称没有下级的情况
	    				$pointer[$curstr] = '.';
	    			else 
	    				$pointer[$ids-1] = $curstr;
	    		}
	    		$tmp = $i+1;//echo ',';
	    		break;
	    	case '}':
	    		$ids = count($pointer);
	    		if($tmp !== $i) {
	    			$curstr = substr($tmpstr, $tmp, $i-$tmp);//echo $curstr;
	    			$pointer[$ids-1] = $curstr;
	    		}
	    		$pcur =& $pointer;
	    		$pointer =& $pointer['@parent'];
	    		unset($pcur['@parent']);
	    		$tmp = $i+1;//echo '}';
	    		break;
	    	case ']':
	    		$pcur =& $pointer;
	    		$pointer =& $pointer['@parent'];
	    		unset($pcur['@parent']);
	    		$tmp = $i+1;//echo ']';
	    		break;
	    	default:
	    		break;
	    }
	}
	return true;
}

function _title_leveltostr(&$sqlstr, $curlev, $objorarr) {
		$str = '';
		if(!is_array($curlev)) return false;
		
		if($objorarr == TITLE_OBJ) {
			$str .= '{';
			foreach($curlev as $key => $data) {
				if($data === '.') {
					$str .= $key;
				} else if(is_array($data)) {
					//print_r($data);echo ';';
					$str .= $key.'[';
					if(!_title_leveltostr($str, $data, TITLE_ARR))
						return false;
					$str .= ']';
				} else {
				  	$str .= $data;
				}
				$str .= ',';
			}
			$sqlstr .= substr_replace($str, '}', -1, 1);	//',' => '}'
		} else if ($objorarr == TITLE_ARR) {
			foreach($curlev as $key => $data) {
				if(!is_array($data)|| !_title_leveltostr($str, $data, TITLE_OBJ))
					return false;
				$sqlstr .= $str;
			}
		}
		return true;
}

function title_arrtostr($array, &$sqlstr) {
	if(!is_array($array) || !empty($sqlstr)) return false;
	$sqlstr = '[';
	if(!_title_leveltostr($sqlstr, $array, TITLE_ARR)) return false;
	$sqlstr .= ']';
	return true;
}

/**
 * 账单数据转换json
 */
function title_arrtojs($array) {
	$str = '[';
	foreach ($array as $category) { //print_r($category);
		if ($category[2] == 'show') { 
			foreach ($category as $key => $label) {
				if($label == '.') {
					$str .= '{label:"'.$key.' '.$category[1].'",category:""},';
				} else if (is_array($label)) {
					foreach ($label as $data) {
						if ($data[2] == 'show') {
							foreach ($data as $name => $detail) {
								if($detail == '.')
									$str .= '{label:"'.$name.' '.$data[1].'",category:"'.$key.'"},';
							}
						}
					}
				}
			}
		}
	}
	$str = substr_replace($str, "]", -1);
	//$str .= ']';
	return $str;
}

/**
 * 变成预算需要的数组
 * @param type_array $array
 * @param type_bool $bTwo
 */
function title_tobudget($array, $bnum=true) {
	$result = array();
	foreach ($array as $category) { //print_r($category);
		foreach ($category as $key => $label) {
			if($label == '.') {
				$result[$key]['state'] = $category[2];
				if($bTwo) {
					$result[$key]['budget']    = 0;
					$result[$key]['realcash']  = 0;
					$result[$key]['_budget']   = 0;
					$result[$key]['_realcash'] = 0;
				}
			} else if (is_array($label)) {
				$result[$key]['state'] = $category[2];
				foreach ($label as $data) {
					foreach ($data as $name => $detail) {
						if($detail == '.') {
							$result[$key]['children'][$name]['state'] = $data[2];
							if($bTwo) {
								$result[$key]['children'][$name]['budget']    = 0;
								$result[$key]['children'][$name]['realcash']  = 0;
								$result[$key]['children'][$name]['_budget']   = 0;
								$result[$key]['children'][$name]['_realcash'] = 0;
							}
						}
					}
				}
			}
		}
	}
	return $result;
}

/**
 * 百分数所对应的颜色
 */
function budget_color($numerator, $denominator) {
	if(!$denominator)
		return false;
	$var = round($numerator*100/$denominator, 1);
	$num_red = $var*255/50;
	$num_red = $num_red>255 ? 'ff' : dechex($num_red);
	$num_red = strlen($num_red)==1 ? '0'.$num_red : $num_red;
	
	$num_green = 510 - $var*255/50;
	$num_green = $num_green>255 ? 255:$num_green;
	$num_green = $num_green<0 ? '00' : dechex($num_green);
	$num_green = strlen($num_green)==1 ? '0'.$num_green : $num_green;
	return $num_red.$num_green.'00';
}

/**
 * 账单归属转换(sqlstring <==> array)
 */
function catetype_strtoarr($sqlstr, &$array) {
	if(!isset($sqlstr) || !empty($array)) return false;
	
	$strlength = strlen($sqlstr);
	if($sqlstr[0] !== '[' || $sqlstr[$strlength-1] !== ']') return false;
	
	$tmpstr = substr($sqlstr, 1, $strlength-2);
	
	$array = explode(',', $tmpstr);
	return true;
}

/**
 * 账单归属转换(array <==> json)
 */
function catetype_arrtojs($array) {
	$str = '["';

	$str .= implode('","', $array);
	
	$str .= '"]';
	return $str;
}

/**
 * 检查账单名称
 */
function ac_array_str_exists($richcategory, $richname, $typearr) {
	if($richname === "")
		return false;
	if($richcategory === "") {
		foreach($typearr as $category) {
			if(array_key_exists($richname, $category)) {
				return true;
			}
		}
	} else {
		foreach($typearr as $category) {
			if(array_key_exists($richcategory, $category)) {
				if(is_array($category[$richcategory])){
					foreach($category[$richcategory] as $label) {
						if(array_key_exists($richname, $label))
							return true;
					}
				}
			}
		}
	}
	return false;
}


$titincome = '[{职业工薪[{工资,show,0}{奖金,show,0}{加班工资,show,0}{补助津贴,show,0}{其他,show,0}],show,0}{业余收入[{兼职收入,show,0}{稿费版税,show,0}{业余项目,show,0}{其他,show,0}],show,0}{人情收入[{礼金礼物,show,0}{获赠,show,0}{红包,show,0}{赡养费,show,0}{抚养费,show,0}{其他,show,0}],show,0}{博彩收入,show,0}{意外所有,show,0}{租金收入,show,0}{分红,show,0}{其他收入,show,0}]';

$titpay = '[{日常开销[{食品,show,0}{家具物品,show,0}{其他,show,0}],show,0}{餐费[{早餐,show,0} {午餐,show,0}{晚餐,show,0}{工作餐,show,0}{夜宵,show,0}{其他,show,0}],show,0}{交通[{公交,show,0}{出租车,show,0}{地铁,show,0}{飞机,show,0}{火车,show,0}{长途汽车,show,0}{汽油费,show,0}{停车费,show,0}{过路费,show,0}{养路费,show,0}{违章交费,show,0}{车辆维护,show,0} {车辆年检,show,0}{驾照年检,show,0}{车辆保险,show,0}{车库管理费,show,0}{其他,show,0}],show,0}{通讯费[{电话费,show,0}{手机费,show,0}{上网费,show,0}{邮寄费,show,0} {夜宵,show,0}{其他,show,0}],show,0}{医疗保健[{药品,show,0}{治疗费,show,0}{体检,show,0} {保健护理用品,show,0}{其他,show,0}],show,0}{悠闲娱乐[{宠物支出,show,0}{旅游度假,show,0}{娱乐费,show,0}{其他,show,0}],show,0}{物管[{电费,show,0}{燃气费,show,0}{水费,show,0}{暖气费,show,0}{房租,show,0}{有线电视费,show,0}{物业管理费,show,0}{卫生费,show,0}{其他,show,0}],show,0}{人情支出[{礼品礼金,show,0}{请客,show,0}{交际费用,show,0}{人情往来,show,0}{其他,show,0}],show,0}{美容健身[{健身,show,0}{美容美发,show,0}{化妆保养品,show,0}{其他,show,0}],show,0}{父母赡养[{每月供养,show,0}{医疗保健,show,0}{其他,show,0}],show,0}{教育培训[{文化用品,show,0}{报章杂志,show,0}{图书音像,show,0}{软件,show,0}{会费,show,0}{培训,show,0}{考证,show,0}{自考,show,0}{打字复印,show,0}{其他,show,0}],show,0}{维修保养[{电器,show,0}{房屋,show,0}{家具,show,0}{其他,show,0}],show,0}{生儿育女[{产检费,show,0}{生育费,show,0}{喂哺用具,show,0}{保姆费,show,0}{儿保费,show,0}{玩具,show,0}{托儿费,show,0}{学杂费,show,0}{其他,show,0}],show,0}{慈善捐助,show,0}{博彩支出,show,0}{意外损失,show,0}{其他支出,show,0}]';

?>