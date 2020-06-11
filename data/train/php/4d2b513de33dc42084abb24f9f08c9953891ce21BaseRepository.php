<?php

namespace CodebaseHq\Repository;

use CodebaseHq\Api;

class BaseRepository
{

    /**
     * @var Api
     */
    protected $api;

    /**
     * Class constructor.
     *
     * Requires instance of CodebaseHq\Api to be injected
     *
     * @param \CodebaseHq\Api $api
     */
    public function __construct(Api $api)
    {
        $this->setApi($api);
    }

    /**
     * @param \CodebaseHq\Api $api
     * @return Ticket provides fluent interface
     */
    public function setApi($api)
    {
        $this->api = $api;
        return $this;
    }

    /**
     * @return \CodebaseHq\Api
     */
    public function getApi()
    {
        return $this->api;
    }


}
