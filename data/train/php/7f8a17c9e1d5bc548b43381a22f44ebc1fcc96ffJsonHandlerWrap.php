<?php namespace GM\WPS;

use Whoops\Handler\HandlerInterface;

class JsonHandlerWrap implements HandlerWrapInterface {

    private $handler;

    function __construct( HandlerInterface $handler ) {
        $this->handler = $handler;
    }

    public function getHandler() {
        return $this->handler;
    }

    public function setup() {
        if ( ! $this->isAjaxRequest() ) {
            return;
        }
        $handler = $this->getHandler();
        $handler->addTraceToOutput( TRUE );
        $handler->onlyForAjaxRequests( TRUE );
        return $handler;
    }

    private function isAjaxRequest() {
        return defined( 'DOING_AJAX' ) && DOING_AJAX;
    }

}