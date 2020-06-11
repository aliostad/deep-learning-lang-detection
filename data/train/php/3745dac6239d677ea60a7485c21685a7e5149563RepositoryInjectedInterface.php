<?php

namespace Esensi\Core\Contracts;

use Esensi\Core\Repositories\Repository;

/**
 * Interface for injecting repositories into a class
 *
 * @package Esensi\Core
 * @author Daniel LaBarge <daniel@emersonmedia.com>
 * @copyright 2015 Emerson Media LP
 * @license https://github.com/esensi/core/blob/master/LICENSE.txt MIT License
 * @link http://www.emersonmedia.com
 */
interface RepositoryInjectedInterface
{
    /**
     * Get the specified repository by name
     *
     * @param string $name (optional) of repository
     * @return Esensi\Core\Repository\Repository
     */
    public function getRepository( $name = null );

    /**
     * Set the specified repository by name
     *
     * @param \Esensi\Core\Repository\Repository $repository
     * @param string $name (optional) of repository
     * @return void
     */
    public function setRepository( Repository $repository, $name = null );

}
