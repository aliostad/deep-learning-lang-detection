<?php

/**
 * [AutoSave]自動保存コンフィグコントローラー
 *
 * @copyright Copyright 2014 - , Nextat Inc.
 * @link       http://nextat.co.jp
 * @package    nextat.bcplugins.auto_save
 * @since      baserCMS v 3.0.0
 * @version    0.9.1
 * @license    MIT License
 */
class AutoSaveConfigsController extends AutoSaveAppController {

    /**
     * クラス名
     *
     * @var string
     * @access public
     */
    public $name = 'AutoSaveConfigs';

    /**
     * モデル
     *
     * @var array
     * @access public
     */
    public $uses = array('AutoSave.AutoSaveTarget', 'AutoSave.AutoSaveConfig');

    /**
     * コンポーネント
     *
     * @var array
     * @access public
     */
    public $components = array('BcAuth');

    /**
     * サブメニューエレメント
     *
     * @var 	array
     * @access 	public
     */
    public $subMenuElements = array('auto_save');

    /**
     * パンくずナビ
     *
     * @var string
     * @access public
     */
    public $crumbs = array(
	array('name' => 'プラグイン管理', 'url' => array('plugin' => '', 'controller' => 'plugins', 'action' => 'index')),
	array('name' => '自動保存管理', 'url' => array('plugin' => 'auto_save', 'controller' => 'auto_save_configs', 'action' => 'edit'))
    );

    /**
     * [ADMIN] 設定処理
     *
     * @return void
     * @access public
     */
    public function admin_edit() {
	if (!$this->data) {
	    //設定の読み込み
	    $targets = $this->AutoSaveTarget->find('all');
	    $configs = $this->AutoSaveConfig->find('all');
	    //View側で使えるようにする
	    $this->set('targets', $targets);
	    $this->set('configs', $configs);
	} else {
	    if ($this->AutoSaveTarget->saveAll($this->data['AutoSaveTarget']) && $this->AutoSaveConfig->saveAll($this->data['AutoSaveConfig'])) {
		// 保存が成功した場合は、完了メッセージを設定し、リダイレクト
		$this->Session->setFlash('保存しました。');
		$this->redirect(array('plugin' => 'auto_save', 'controller' => 'auto_save_configs', 'action' => 'edit'));
	    } else {
		// 失敗した場合は完了メッセージの設定のみ
		$this->setMessage('エラーが発生しました。内容を確認してください。', true);
	    }
	}
	$this->pageTitle = '自動保存設定';
    }

}
