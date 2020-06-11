<?php
namespace Brainwave\Workbench;

/**
 * Narrowspark - a PHP 5 framework
 *
 * @author      Daniel Bannert <info@anolilab.de>
 * @copyright   2014 Daniel Bannert
 * @link        http://www.narrowspark.de
 * @license     http://www.narrowspark.com/license
 * @version     0.9.3-dev
 * @package     Narrowspark/framework
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 * Narrowspark is an open source PHP 5 framework, based on the Slim framework.
 *
 */

use \Brainwave\Support\Str;

/**
 * StaticalProxyResolver
 *
 * @package Narrowspark/framework
 * @author  Daniel Bannert
 * @since   0.9.1-dev
 *
 */
class StaticalProxyResolver
{
    /**
     * Resolve a facade quickly to its root class
     *
     * @param  string $facade
     * @return resolved class
     */
    public function resolve($facade)
    {
        if ($this->isFacade($this->getFacadeNameFromInput($facade))) {
            $rootClass = get_class($facade::getFacadeRoot());
            return "The registered facade '{$this->getFacadeNameFromInput($facade)}' maps to {$rootClass}";
        } else {
            return "Facade not found";
        }
    }

    /**
     * [getFacadeNameFromInput description]
     *
     * @param  string $facadeName [description]
     * @return [type]             [description]
     */
    public function getFacadeNameFromInput($facadeName)
    {
        if ($this->isUppercase($facadeName)) {
            return $facadeName;
        } else {
            return ucfirst(Str::camel(strtolower($facadeName)));
        }
    }

    /**
     * [isFacade description]
     *
     * @param  string  $facade [description]
     * @return boolean         [description]
     */
    public function isFacade($facade)
    {
        if (class_exists($facade)) {
            return array_key_exists('Brainwave\Workbench\StaticalProxyManager', class_parents($facade));
        } else {
            return false;
        }
    }

    /**
     * [isUppercase description]
     *
     * @param  string  $string [description]
     * @return boolean         [description]
     */
    private function isUppercase($string)
    {
        return (strtoupper($string) == $string);
    }
}
