<?php

namespace UserlandSession\Util;

/**
 * Adapter for various tasks in PHP 5.3
 */
class Php53Adapter
{
    /**
     * Use a SessionHandlerInterface object as a native session handler
     *
     * @param \SessionHandlerInterface $handler
     *
     * @return bool
     */
    public static function setSaveHandler(\SessionHandlerInterface $handler)
    {
        return session_set_save_handler(
            array($handler, 'open'),
            array($handler, 'close'),
            array($handler, 'read'),
            array($handler, 'write'),
            array($handler, 'destroy'),
            array($handler, 'gc')
        );
    }
}