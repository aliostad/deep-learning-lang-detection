<?php
/**
 * @copyright   2010-2014, The Titon Project
 * @license     http://opensource.org/licenses/bsd-license.php
 * @link        http://titon.io
 */

namespace Titon\Db;

/**
 * Permits a class to interact with a repository.
 *
 * @package Titon\Db
 */
trait RepositoryAware {

    /**
     * Repository object instance.
     *
     * @type \Titon\Db\Repository
     */
    protected $_repository;

    /**
     * Return the repository.
     *
     * @return \Titon\Db\Repository
     */
    public function getRepository() {
        return $this->_repository;
    }

    /**
     * Set the repository.
     *
     * @param \Titon\Db\Repository $repository
     * @return $this
     */
    public function setRepository(Repository $repository) {
        $this->_repository = $repository;

        return $this;
    }

}