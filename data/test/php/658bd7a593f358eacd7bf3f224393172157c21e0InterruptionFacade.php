<?php

namespace Subscribo\TransactionPluginManager\Facades;

use Subscribo\TransactionPluginManager\Interfaces\InterruptionFacadeInterface;
use Subscribo\TransactionPluginManager\Traits\TransparentFacadeTrait;
use Subscribo\ModelCore\Models\ActionInterruption;

/**
 * Class InterruptionFacade
 *
 * @package Subscribo\TransactionPluginManager
 */
class InterruptionFacade implements InterruptionFacadeInterface
{
    use TransparentFacadeTrait;

    /** @var \Subscribo\ModelCore\Models\ActionInterruption  */
    protected $instanceOfObjectBehindFacade;

    /** @var string  */
    protected static $classNameOfObjectBehindFacade = '\\Subscribo\\ModelCore\\Models\\ActionInterruption';

    /**
     * @param ActionInterruption $actionInterruption
     */
    public function __construct(ActionInterruption $actionInterruption)
    {
        $this->instanceOfObjectBehindFacade = $actionInterruption;
    }

    /**
     * @return string
     */
    public function getHash()
    {
        return $this->instanceOfObjectBehindFacade->hash;
    }

    /**
     * @return \Subscribo\ModelCore\Models\ActionInterruption
     */
    public function getActionInterruptionModelInstance()
    {
        return $this->instanceOfObjectBehindFacade;
    }
}
