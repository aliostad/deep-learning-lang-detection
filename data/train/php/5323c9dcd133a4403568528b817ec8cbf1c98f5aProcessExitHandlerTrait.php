<?php

namespace Thruster\Components\ProcessExitHandler;

/**
 * Trait ProcessExitHandlerTrait
 *
 * @package Thruster\Components\ProcessExitHandler
 * @author  Aurimas Niekis <aurimas@niekis.lt>
 */
trait ProcessExitHandlerTrait
{
    /**
     * @var ProcessExitHandler
     */
    protected $processExitHandler;

    /**
     * @return ProcessExitHandler
     */
    public function getProcessExitHandler()
    {
        return $this->processExitHandler;
    }

    /**
     * @param ProcessExitHandler $processExitHandler
     *
     * @return $this
     */
    public function setProcessExitHandler($processExitHandler)
    {
        $this->processExitHandler = $processExitHandler;

        return $this;
    }
}
