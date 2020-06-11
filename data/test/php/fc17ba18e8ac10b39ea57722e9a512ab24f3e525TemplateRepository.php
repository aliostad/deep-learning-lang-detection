<?php

class Tx_SitemgrTemplate_Domain_Repository_TemplateRepository
	extends Tx_SitemgrTemplate_Domain_Repository_TemplateAbstractRepository {
	private $repositoriesToInclude = array(
		'Tx_SitemgrTemplate_Domain_Repository_TemplateTemplavoilaFrameworkRepository',
		'Tx_SitemgrTemplate_Domain_Repository_TemplateTemplavoilaRepository'
	);
	function __construct() {
		foreach($this->repositoriesToInclude as $repository) {
			$repository = t3lib_div::makeInstance($repository);
			$this->templates = array_merge($this->templates, $repository->getAllTemplates());
		}
	}
}