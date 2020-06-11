<?php

namespace Idevelopment\Timecontrol\Api\Facade;

use Illuminate\Support\Facades\Facade;

/**
 * Class TimecontrolApi
 *
 * @package Idevelopment\Timecontrol\Api\Facade
 * @author  Tim Joosten <Topairy@gmail.com>
 * @license https://github.com/tjoosten/timecontrol-api/blob/master/LICENSE GNU
 * @link    https://github.com/tjoosten/timecontrol-api
 */
class TimecontrolApi extends Facade
{
    /**
     * Register the facade.
     *
     * @return string
     */
    protected static function getFacadeAccessor()
    {
        return 'TimecontrolApi';
    }
}