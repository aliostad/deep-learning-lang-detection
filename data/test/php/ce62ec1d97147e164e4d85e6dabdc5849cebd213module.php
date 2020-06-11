<?php
Page::loadModule('repository');
Page::loadModule('pkglist');

class Module_lastupdates extends RepositoryModule {
	public function run() {
		$default_repository = Settings::get('default_repository');
		$query = [];
		if ($default_repository) $query['repositories.repository'] = $default_repository;
		
		$ret = '<h1>Latest updates in ' . $default_repository . '</h1>';

		$packages = self::db()->packages->find($query)->sort(['add_date' => -1]);
		$ret .= Module_pkglist::getList($packages, 20, 0, 'Complex', false);
		return $ret;
	}
}
