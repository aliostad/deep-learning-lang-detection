<?php
/**
 * File containing the RepositoryAwareInterface interface.
 *
 * @copyright Copyright (C) 1999-2012 eZ Systems AS. All rights reserved.
 * @license http://ez.no/licenses/gnu_gpl GNU General Public License v2.0
 * @version 2012.9
 */

namespace eZ\Publish\Core\MVC;

use eZ\Publish\API\Repository\Repository;

interface RepositoryAwareInterface
{
    /**
     * @param \eZ\Publish\API\Repository\Repository $repository
     * @return void
     */
    public function setRepository( Repository $repository );
}
