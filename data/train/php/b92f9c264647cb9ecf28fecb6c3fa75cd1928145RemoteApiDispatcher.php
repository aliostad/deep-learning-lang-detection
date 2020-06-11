<?php
namespace ApiBundle\Dispatcher;

use ApiBundle\Api\Api;

/**
 * Class RemoteDispatcher
 * @package ApiBundle\Dispatcher
 */
Class RemoteApiDispatcher implements DispatcherInterface
{
    /**
     * @var Api
     */
    private $api;

    /**
     * @var string
     */
    private $routeName;

    /**
     * @param Api $api
     */
    public function __construct(Api $api, $routeName)
    {
        $this->api          = $api;
        $this->routeName    = $routeName;
    }

    /**
     * @param $eventKey
     * @param $eventValue
     * @return mixed
     */
    public function dispatch($eventKey, $eventValue)
    {
        $this->api->callMethod($this->routeName, [
            'eventkey'      => $eventKey,
            'eventValue'    => $eventValue,
        ]);
    }
}