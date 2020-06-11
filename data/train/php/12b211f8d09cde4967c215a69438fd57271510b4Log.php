<?php

namespace Elixir\Facade;

use Elixir\Facade\FacadeAbstract;

/**
 * @author Cédric Tanghe <ced.tanghe@gmail.com>
 */

class Log extends FacadeAbstract
{
    /**
     * @var integer
     */
    const EMERG = 0;
    
    /**
     * @var integer
     */
    const ALERT = 1;
    
    /**
     * @var integer
     */
    const CRIT  = 2;
    
    /**
     * @var integer
     */
    const ERR = 3;
    
    /**
     * @var integer
     */
    const WARN = 4;
    
    /**
     * @var integer
     */
    const NOTICE = 5;
    
    /**
     * @var integer
     */
    const INFO = 6;
    
    /**
     * @var integer
     */
    const DEBUG = 7;
    
    /**
     * @see FacadeAbstract::getFacadeAccessor()
     */
    protected static function getFacadeAccessor()
    {
        return 'logger';
    }
}
