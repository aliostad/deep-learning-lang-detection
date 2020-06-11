<?php

namespace PrivatBank\Root\Chunk;

use PrivatBank\Root\Error\ErrorHandlerInterface as ErrorHandlerInterface,
    PrivatBank\Root\Error\ErrorHandler as ErrorHandler;

trait ErrorAware
{
    /**
     * Serves runtime errors
     *
     * @type PrivatBank\Root\Error\ErrorHandlerInterface
     */
    protected $_errorHandler;

    public function serErrorHandler(ErrorHandlerInterface $errorHandler = null)
    {
        $this->_errorHandler = is_null($errorHandler) ? new ErrorHandler() : $errorHandler;
    }

    public function getErrorHandler()
    {
        return $this->_errorHandler;
    }

}