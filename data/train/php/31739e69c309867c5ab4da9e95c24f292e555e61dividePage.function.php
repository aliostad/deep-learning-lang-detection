<?php

/*
 * $indexSelect,$max,$show  is required.
 * 
 * 
 */
function getIndexValue(&$indexSelect,&$begin,&$end,&$max,$originShow = 5)
{
	if($indexSelect>$max)
	{
		$indexSelect=$max;
	}
	$show=$originShow;
	if($show>=$max)
	{
		$show=$max;
		$begin=1;
		$end=$max;
		return;
	}
	$show-=1;
	if((int)$show%2)
	{
		$show-=1;
	}
	$end=$max;
	if($indexSelect>$max)
	{
		$indexSelect = $max;
	}

	if($indexSelect-$show/2>0)
	{
		$begin = $indexSelect-$show/2;
	}else
	{
		$begin = 1;
		$end = $originShow;
		return;
	}
	if($indexSelect+$show/2<$max)
	{
		$end = $indexSelect+$show/2;
	}
	else
	{
		$begin = $max-$originShow+1;
		$end = $max;
		return;
	}
}