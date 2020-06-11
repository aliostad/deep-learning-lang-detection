<?php
/**
 * Created by PhpStorm.
 * User: dhiraj.gangoosirdar
 * Date: 3/17/2015
 * Time: 2:46 PM
 */

namespace com\checkout\ApiServices;

use com\checkout\helpers\ApiUrls;
use com\checkout\helpers\AppSetting;

class BaseServices
{
    /** @var AppSetting */
    protected $_apiSetting = null;
    /** @var ApiUrls */
    protected $_apiUrl = null;

    public function __construct(AppSetting $apiSetting, ApiUrls $apiUrl = null)
    {

        $this->setApiSetting($apiSetting);
        if (!$this->getApiUrl() && !$apiUrl) {
            $apiUrl = new ApiUrls();
            $apiUrl->setBaseApiUri($apiSetting->getBaseApiUri());
        }
        $this->setApiUrl($apiUrl);
    }

    /**
     * @return \com\checkout\helpers\AppSetting
     */
    public function getApiSetting()
    {
        return $this->_apiSetting;
    }

    /**
     * @param \com\checkout\helpers\AppSetting $apiSetting
     */
    public function setApiSetting($apiSetting)
    {
        $this->_apiSetting = $apiSetting;
    }

    /**
     * @return string
     */
    public function getApiUrl()
    {
        return $this->_apiUrl;
    }

    /**
     * @param string $apiUrl
     */
    public function setApiUrl($apiUrl)
    {
        $this->_apiUrl = $apiUrl;
    }
}
