<?php

Page::loadModule('repository');
class Module_browser_osversions extends RepositoryModule {
	public function run() {
		if (!isset($this->page->path[2])) return;
		$repository_name = $this->page->path[2];
		$repository = new Repository($repository_name);
		$osversions = $repository->osversions();

		$ret = '<label for="browser_osversions">OS versions:</label>';
		$ret .= '<ul id="browser_osversions">';
		foreach($osversions as $r) {
			$ret .= '<li><a href="/browser/' . $repository_name . '/' . $r . '">' . $r . '</a></li>';
		}
		$ret .= '</ul>';
		return $ret;

	}
}
