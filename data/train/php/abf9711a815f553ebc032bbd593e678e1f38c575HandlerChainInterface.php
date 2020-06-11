<?php

namespace DeviceDetectorIO\DeviceDetector\Rule\Configuration\Handler;

/**
 * Interface HandlerChainInterface
 * @package DeviceDetectorIO\DeviceDetector\Rule\Configuration\Handler
 */
interface HandlerChainInterface extends HandlerInterface
{
    /**
     * @param HandlerInterface $handler
     * @return bool
     */
    public function addHandler(HandlerInterface $handler);

    /**
     * @param HandlerInterface $handler
     * @return bool
     */
    public function hasHandler(HandlerInterface $handler);

    /**
     * @param HandlerInterface $handler
     * @return bool
     */
    public function removeHandler(HandlerInterface $handler);

    /**
     * @return bool
     */
    public function removeAll();

    /**
     * @return array<HandlerInterface>
     */
    public function getHandlers();
}
