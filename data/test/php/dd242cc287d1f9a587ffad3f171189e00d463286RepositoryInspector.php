<?php
/**
 * RepositoryInspector
 */
use Sledgehammer\Repository;
/**
 * Allows the RepositoryDataSource to inspect the ModelConfig classes in a Repository.
 * @package SledgehammerPlugin
 */
class RepositoryInspector extends Repository {

	/**
	 *
	 * @param \Sledgehammer\Repository $repository
	 * @param string $model
	 * @return \Sledgehammer\ModelConfig|array
	 */
	static function getModelConfig($repository, $model = null) {
		if ($model === null) {
			return $repository->configs;
		}
		return $repository->_getConfig($model);
	}
}

?>
