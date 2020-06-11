<?php
namespace Fwlib\Auth;

/**
 * @copyright   Copyright 2015 Fwolf
 * @license     http://www.gnu.org/licenses/lgpl.html LGPL-3.0+
 */
trait SessionHandlerAwareTrait
{
    /**
     * @var SessionHandlerInterface
     */
    protected $sessionHandler = null;


    /**
     * Getter of $sessionHandler
     *
     * @return  SessionHandlerInterface
     */
    public function getSessionHandler()
    {
        return $this->sessionHandler;
    }


    /**
     * Setter of $sessionHandler
     *
     * @param   SessionHandlerInterface $sessionHandler
     * @return  static
     */
    public function setSessionHandler(SessionHandlerInterface $sessionHandler)
    {
        $this->sessionHandler = $sessionHandler;

        return $this;
    }
}
