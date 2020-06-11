<?php

namespace Thruster\Components\PosixSignalHandler;

/**
 * Trait SignalHandlerTrait
 *
 * @package Thruster\Components\PosixSignalHandler
 * @author  Aurimas Niekis <aurimas@niekis.lt>
 */
trait SignalHandlerTrait
{
    /**
     * @var SignalHandler
     */
    protected $signalHandler;

    /**
     * @return SignalHandler
     */
    public function getSignalHandler()
    {
        return $this->signalHandler;
    }

    /**
     * @param SignalHandler $signalHandler
     *
     * @return $this
     */
    public function setSignalHandler($signalHandler)
    {
        $this->signalHandler = $signalHandler;

        return $this;
    }
}
