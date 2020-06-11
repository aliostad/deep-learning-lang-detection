<?php
namespace Alchemy\Repositories;

use Thirteen\Repositories\Eloquent\Repository as ThirteenRepository;
use Alchemy\Contracts\Repositories\Repository as RepositoryInterface;

/**
 * Class  Repository
 *
 * @package     Alchemy\Repositories
 * @author      Jaggy Gauran <poke@jag.gy>
 * @license     http://opensource.org/licenses/MIT The MIT License (MIT)
 * @version     Release: 0.1.2
 * @link        http://github.com/thirteen/alchemy
 * @since       Class available since Release 0.1.0
 */
abstract class Repository extends ThirteenRepository implements RepositoryInterface
{
}
