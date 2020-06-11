<?php
/**
 * File containing the RepositoryAware class.
 *
 * @copyright Copyright (C) 1999-2012 eZ Systems AS. All rights reserved.
 * @license http://ez.no/licenses/gnu_gpl GNU General Public License v2.0
 * @version 2012.9
 */

namespace eZ\Publish\Core\MVC;

use eZ\Publish\API\Repository\Repository;

abstract class RepositoryAware implements RepositoryAwareInterface
{
    /**
     * @var \eZ\Publish\API\Repository\Repository
     */
    protected $repository;

    /**
     * @param \eZ\Publish\API\Repository\Repository $repository
     */
    public function setRepository( Repository $repository )
    {
        $this->repository = $repository;
    }
}
