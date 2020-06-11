<?php require('./inc.main.php'); ?><?php
$error = NULL;
$id = (int) wgPost::getValue('id');
$save['id'] = (int) wgPost::getValue('id');
$save['system_websites_id'] = (int) wgPost::getValue('system_websites_id');
$save['system_language_id'] = (int) wgPost::getValue('system_language_id');
$save['pages_templates_id'] = (int) wgPost::getValue('pages_templates_id');
$save['revision'] = (int) wgPost::getValue('revision');
$save['name'] = (string) wgPost::getValue('name');
$save['identifier'] = (string) wgPost::getValue('identifier');
$save['title'] = (string) wgPost::getValue('title');
$save['heading1'] = (string) wgPost::getValue('heading1');
$save['heading2'] = (string) wgPost::getValue('heading2');
$save['heading3'] = (string) wgPost::getValue('heading3');
$save['rewrite'] = (string) wgPost::getValue('rewrite');
$save['keywords'] = (string) wgPost::getValue('keywords');
$save['description'] = (string) wgPost::getValue('description');
$save['addtext1'] = (string) wgPost::getValue('addtext1');
$save['addtext2'] = (string) wgPost::getValue('addtext2');
$save['enabled'] = (int) wgPost::getValue('enabled');
$save['master'] = (int) wgPost::getValue('master');
$save['parentid'] = (int) wgPost::getValue('parentid');
$save['home'] = (int) wgPost::getValue('home');
$save['sort'] = (int) wgPost::getValue('sort');
$save['head'] = (string) wgPost::getValue('head');
$save['page'] = (string) wgPost::getValue('page');
$save['note'] = (string) wgPost::getValue('note');
$save['redirect1'] = (int) wgPost::getValue('redirect1');
$save['redirect2'] = (int) wgPost::getValue('redirect2');
$save['redirect3'] = (string) wgPost::getValue('redirect3');
$save['redirect4'] = (string) wgPost::getValue('redirect4');

if (wgPost::isValue('id')) {
	if ((bool) $id) {
		$save['where'] = $id;
		$res = (bool) PagesModel::doUpdate($save);
		if (!$res) $error = 'Unable to update entry.';
	}
	else {
		$id = PagesModel::doInsert($save);
		$res = (bool) $id;
		if (!$res) $error = 'Unable to insert entry.';
	}
}
else {
	$res = false;
	$error = 'No data has been sent.';
}
?>{
	"result": <?php echo (int) $res; ?>,
	"error": "<?php echo $error; ?>"
}<?php ?>