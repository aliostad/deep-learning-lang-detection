<?php
/**
 * Created by PhpStorm.
 * User: lia
 * Date: 15/10/15
 * Time: 20:59
 */

namespace Cube\Poo\Facade;

trait DrivableHelper
{
    /**
     * @var Facade
     */
    protected $facade;

    /**
     * @param Facade|FacadeBehavior $facade
     */
    public function __construct(FacadeBehavior $facade)
    {
        $this->facade = $facade;
    }

    /**
     * @return Facade
     */
    final public function getFacade()
    {
        return $this->facade;
    }

    /**
     * @return Facade
     */
    final public static function newFacade()
    {
        return Facade::instance();
    }
}