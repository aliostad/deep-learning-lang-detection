<?php

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of NoticeAction
 *
 * @author zq
 */
class NoticeAction extends ZBaseAction {

    //put your code here
    //tt-天通，gd-广东，gj-青岛
    public function notice() {
        global $q_t;
        if ($q_t == 'tt') {
            $facade = new BTTNoticeFacade();
            echo json_encode($facade->getNotice());
        } elseif ($q_t == 'gd') {
            $facade = new BGDNoticeFacade();
            echo json_encode($facade->getNotice());
        } elseif ($q_t == 'gj') {
            $facade = new BGJNoticeFacade();
            echo json_encode($facade->getNotice());
        }
    }

    public function detail() {
        //%26
        global $q_t, $q_url;

        if ($q_t == 'tt') {
            $facade = new BTTNoticeFacade();
            $res = $facade->getDetail($q_url);
        } elseif ($q_t == 'gd') {
            $facade = new BGDNoticeFacade();
            //http://www.pmec.com/contents/16/10356.html
            $res = $facade->getDetail($q_url);
        } elseif ($q_t == 'gj') {
            $facade = new BGJNoticeFacade();
            $res = $facade->getDetail($q_url);
        }
        renderView("_tag", "details", $res);
    }

}
?>
