<?php


namespace bloody_hell\vk_api_wrapper;


use bloody_hell\vk_api_wrapper\models\User;
use VK\VK;

class VkApi
{
    /**
     * @var VK
     */
    private $_api;

    public function __construct(VK $api)
    {
        $this->_api = $api;
    }

    /**
     * @return \VK\VK
     */
    public function getApi()
    {
        return $this->_api;
    }

    /**
     * @var DatabaseApi
     */
    private $_db_api;

    /**
     * @var UsersApi
     */
    private $_user_api;

    /**
     * @var PhotosApi
     */
    private $_photos_api;

    /**
     * @return DatabaseApi
     */
    public function db()
    {
        if(!$this->_db_api){
            $this->_db_api = new DatabaseApi($this);
        }

        return $this->_db_api;
    }

    /**
     * @return UsersApi
     */
    public function users()
    {
        if(!$this->_user_api){
            $this->_user_api = new UsersApi($this);
        }

        return $this->_user_api;
    }

    /**
     * @return PhotosApi
     */
    public function photos()
    {
        if(!$this->_photos_api){
            $this->_photos_api = new PhotosApi($this);
        }

        return $this->_photos_api;
    }

    public function api($method, $parameters = array(), $format = 'array')
    {
        return $this->getApi()->api($method, $parameters, $format);
    }
} 