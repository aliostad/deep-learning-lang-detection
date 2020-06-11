<?php

// +----------------------------------------------------------------------
// | date: 2015-12-25
// +----------------------------------------------------------------------
// | PayFacade.php: 支付
// +----------------------------------------------------------------------
// | Author: yangyifan <yangyifanphp@gmail.com>
// +----------------------------------------------------------------------

namespace Yangyifan\Pay\Facades;

use Illuminate\Support\Facades\Facade;

class Pay extends Facade
{
    protected static function getFacadeAccessor()
    {
        return 'pay';
    }
}