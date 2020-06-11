<?php
/**
 * Created by PhpStorm.
 * User: lia
 * Date: 15/10/15
 * Time: 15:16
 */

namespace Cube\Http;

use Cube\Http\Router\RouterFacade;
use Cube\Poo\Facade\FacadeWrapper;

class HttpFacade
    extends    FacadeWrapper
    implements HttpBehavior
{
    /**
     * @param string $className
     * @return RouterFacade
     */
    public function router($className = Http::Router)
    {
        return RouterFacade::single($className)
            ->setParentFacade($this)
            ->map($className)
            ;
    }
}