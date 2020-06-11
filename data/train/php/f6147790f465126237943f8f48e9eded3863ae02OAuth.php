<?php

// +----------------------------------------------------------------------
// | date: 2016-03-11
// +----------------------------------------------------------------------
// | OAuth.php: 登录
// +----------------------------------------------------------------------
// | Author: yangyifan <yangyifanphp@gmail.com>
// +----------------------------------------------------------------------

namespace Yangyifan\OAuth\Facades;

use Illuminate\Support\Facades\Facade;

class OAuth extends Facade
{
    protected static function getFacadeAccessor()
    {
        return 'oauth';
    }
}