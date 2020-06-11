<?php
/**
 * Orm
 * @author Petr Procházka (petr@petrp.cz)
 * @license "New" BSD License
 */

namespace Orm;

/**
 * Helper for repository.
 * @author Petr Procházka
 * @package Orm
 * @subpackage Repository\Helpers
 */
class RepositoryHelper extends Object
{

	/** @var array class => name */
	private $normalizeRepositoryCache = array();

	/**
	 * Lowercase nazev tridy bez sufixu Repository
	 * Drive repositoryName.
	 * @param IRepository
	 * @return string
	 */
	public function normalizeRepository(IRepository $repository)
	{
		$repositoryClass = get_class($repository);
		if (!isset($this->normalizeRepositoryCache[$repositoryClass]))
		{
			$name = strtolower($repositoryClass);
			if (substr($name, -10) === 'repository')
			{
				$name = substr($name, 0, strlen($name) - 10);
			}
			$this->normalizeRepositoryCache[$repositoryClass] = $name;
		}
		return $this->normalizeRepositoryCache[$repositoryClass];
	}

}
