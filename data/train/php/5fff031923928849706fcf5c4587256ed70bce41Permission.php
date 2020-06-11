<?php

namespace FluxAPI;


abstract class Permission implements PermissionInterface
{
    protected $_api;

    public function __construct(\FluxAPI\Api $api)
    {
        $this->_api = $api;
    }

    public function hasModelAccess($model_name, \FluxAPI\Model $model = NULL, $action = NULL)
    {
        return $this->_api['permissions']->getDefaultAccess();
    }

    public function hasControllerAccess($controller_name, $action = NULL)
    {
        return $this->_api['permissions']->getDefaultAccess();
    }
}