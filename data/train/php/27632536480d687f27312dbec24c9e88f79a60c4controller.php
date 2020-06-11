<?php
class daleiController {
	//获取擂台信息
	function hqltxx($daleiInfo) {
		$playersid = $daleiInfo['playersid'];
		$showValue = daleiModel::hqltxx($playersid);
		ClientView::show($showValue);
	}

	// 刷新对手
	function sxds($daleiInfo){
		$playersid = $daleiInfo['playersid'];
		$type = _get('type');
		$showValue = daleiModel::sxds($playersid, $type);
		ClientView::show($showValue);
	}
	
	// 天梯对手
	function wdph($daleiInfo) {
		$playersid = $daleiInfo['playersid'];
		$showValue = daleiModel::getLadder($playersid);
		ClientView::show($showValue);
	}
	
	//top10
	function qybm($daleiInfo) {
		$playersid = $daleiInfo['playersid'];
		$showValue = daleiModel::top10($playersid);
		ClientView::show($showValue);
	}
	
	//top10
	function pm($daleiInfo) {
		$playersid = $daleiInfo['playersid'];
		$showValue = daleiModel::top10($playersid);
		ClientView::show($showValue);
	}	
	
	//升级爵位
	function tsjw($daleiInfo) {
		$playersid = $daleiInfo['playersid'];
		$showValue = daleiModel::tsjw($playersid);
		ClientView::show($showValue);
	}
	
	//打擂台
	function dlt($daleiInfo) {
		$playersid = $daleiInfo['playersid'];
		$type = _get('lx');
		$showValue = daleiModel::dlt($playersid,$daleiInfo['tuid'], $type);
		ClientView::show($showValue);
	}
  
	// 擂台回放
	function lthf($daleiInfo) {
		$showValue = daleiModel::lthf($daleiInfo['playersid'],$daleiInfo['msgid']);
		ClientView::show($showValue);
	}
  
	// 增加次数
	function zjcs($daleiInfo) {
		$showValue = daleiModel::zjcs($daleiInfo['playersid']);
		ClientView::show($showValue);
	}
  
	// 兑换材料
	function dhcl($daleiInfo) {
		$showValue = daleiModel::dhcl($daleiInfo['playersid']);
		ClientView::show($showValue);
	}
  
	// 加速cd
	function jscd($daleiInfo) {
		$showValue = daleiModel::jscd($daleiInfo['playersid'],$daleiInfo['tuid']);
		ClientView::show($showValue);
	}

	// 查看对手阵容
	function hqdlzr($daleiInfo){
		$tuid = _get('tuid');
		$showValue = daleiModel::hqdlzr($daleiInfo['playersid'], $tuid);
		ClientView::show($showValue);
	}
	//兑换列表
	function dhlb() {
		$showValue = daleiModel::dhlb();
		ClientView::show($showValue);		
	}
	//积分兑换
	function dh($daleiInfo) {
		$playersid = $daleiInfo['playersid'];
		$id = _get('id');
		$showValue = daleiModel::jfdh($id,$playersid);
		ClientView::show($showValue);
	}
}
