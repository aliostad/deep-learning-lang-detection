<?php

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of NoticeDetailController
 * 交易所公告详情控制器
 * @author zq
 */
class NoticeDetailController extends ZBaseController {

    //put your code here
    /**
     * 交易所公告详情
     * @param NoticeDetailRequestData $data
     */
    public function act($data) {
        if ($data->t == 'tt') {
            $facade = new BTTNoticeFacade();
            $res = $facade->getDetail($data->url);
        } elseif ($data->t == 'gd') {
            $facade = new BGDNoticeFacade();
            //http://www.pmec.com/contents/16/10356.html
            $res = $facade->getDetail($data->url);
        } elseif ($data->t == 'gj') {
            $facade = new BGJNoticeFacade();
            $res = $facade->getDetail($data->url);
        }
        renderView("_tag", "details", $res);
    }

}

/**
 * 交易所公告详情请求参数
 */
class NoticeDetailRequestData {

    /**
     * 交易所代码
     * @var string 
     */
    public $t;

    /**
     * 详情原始地址
     * @var string 
     */
    public $url;

}
