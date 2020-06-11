<?php
/**
 * This file provides the ServiceProvider for the OAuth Laravel implementation.
 *
 * @author      Steve Crockett <crockett95@gmail.com>
 * @version     0.0.0
 * @package     Crockett95\OAuth
 * @subpackage  Facade
 * @license     http://opensource.org/licenses/MIT  MIT
 */

namespace Crockett95\OAuth\Facades;

use Illuminate\Support\Facades\Facade;

/**
 * The facade class
 */
class OAuth extends Facade
{

    /**
     * Returns the IoC binding for the facade
     *
     * @return  string  Laravel IoC binding name
     */
    protected static function getFacadeAccessor()
    {
        return 'oauth';
    }
}