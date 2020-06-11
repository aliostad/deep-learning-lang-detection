<?php

namespace App\Http\Middleware;

use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken as BaseVerifier;

class VerifyCsrfToken extends BaseVerifier
{
    /**
     * The URIs that should be excluded from CSRF verification.
     *
     * @var array
     */
     protected $except = [
         'api/user',
         'api/user/*',
         'api/company',
         'api/company/*',
         'api/bt',
         'api/bt/*',
         'api/jop',
         'api/jop/*',
         'api/company/data',
         'api/company/data/*',
         'api/login',
         'api/login/*',
         'api/search',
         'api/search/*',

     ];
}
