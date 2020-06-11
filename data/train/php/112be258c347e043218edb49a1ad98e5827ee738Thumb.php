<?php
/**
 * Created by Feki Webstudio - 2016. 03. 04. 10:18
 * @author Zsolt
 * @copyright Copyright (c) 2016, Feki Webstudio Kft.
 */

namespace FekiWebstudio\Thumbnailer\Facades;

use Illuminate\Support\Facades\Facade;

/**
 * Class ThumbFacade is a Laravel Facade for the thumbnail manager.
 *
 * @package FekiWebstudio\Thumbnailer
 */
class Thumb extends Facade
{
    /**
     * {@inheritdoc}
     */
    protected static function getFacadeAccessor()
    {
        return 'thumb';
    }
}