<?php

namespace PushoverLib;

/**
 * Message Api
 *
 * @package PushoverLib
 * @license MIT License
 */
class Pushover
{
    /** @var array */
    private $config = [
        'appToken' => null,
    ];

    /** @var array */
    private $api = [];

    /**
     * Set config and register api classes
     *
     * @param array $config
     */
    public function __construct($config = []) {
        if (is_array($config)) {
            $this->config = array_replace_recursive($this->config, $config);
        }

        $this->registerApi('\\PushoverLib\\Api\\Message');
        $this->registerApi('\\PushoverLib\\Api\\Receipt');
        $this->registerApi('\\PushoverLib\\Api\\ReceiptCancel');
        $this->registerApi('\\PushoverLib\\Api\\Sound');
        $this->registerApi('\\PushoverLib\\Api\\Validate');
        $this->registerApi('\\PushoverLib\\Api\\SubscriptionMigrate');
        $this->registerApi('\\PushoverLib\\Api\\Group');
        $this->registerApi('\\PushoverLib\\Api\\GroupAddUser');
        $this->registerApi('\\PushoverLib\\Api\\GroupDeleteUser');
        $this->registerApi('\\PushoverLib\\Api\\GroupDisableUser');
        $this->registerApi('\\PushoverLib\\Api\\GroupEnableUser');
        $this->registerApi('\\PushoverLib\\Api\\GroupRename');
        $this->registerApi('\\PushoverLib\\Api\\LicenseAssign');
    }

    /**
     * Call registered api class
     *
     * @param string $name
     * @param array $arguments
     *
     * @return Api\AbstractApi
     */
    public function __call($name, $arguments) {
        if (isset($this->api[$name])) {
            if (!empty($arguments)) {
                $arguments = $arguments[0];
            }

            return new $this->api[$name]($this->config, $arguments);
        }
    }

    /**
     * Register api class
     *
     * @param string $class
     */
    public function registerApi($class) {
        if (in_array('PushoverLib\\Api\\ApiInterface', class_implements($class))) {
            $name = lcfirst(substr($class, strrpos($class, '\\') + 1));

            $this->api[$name] = $class;
        }
    }
}
