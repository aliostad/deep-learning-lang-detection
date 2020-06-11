<?php

/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * ssss
 */
class NoticeListController extends ZBaseController {

    //put your code here
    /**
     * 交易所列表
     * @param NoticeListRequestData $data
     */
    public function act($data) {
        if ($data->t == 'tt') {
            $facade = new BTTNoticeFacade();
            $res = $facade->getNotice();
        } elseif ($data->t == 'gd') {
            $facade = new BGDNoticeFacade();
            //http://www.pmec.com/contents/16/10356.html
            $res = $facade->getNotice();
        } elseif ($data->t == 'gj') {
            $facade = new BGJNoticeFacade();
            $res = $facade->getNotice();
        }
        $data1['t'] = $data->t;
         $data1['r'] = $res;
        renderView("_tag", "list", $data1);
    }

}

/**
 * 交易所列表请求参数
 */
class NoticeListRequestData {

    /**
     * 交易所代码
     * @var string 
     */
    public $t;

   

}
