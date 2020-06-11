<?php

namespace YandexMoney3;


require_once(__DIR__ . '/Utils/ApiNetworkClient.php');
require_once(__DIR__ . '/Utils/ApiFacade.php');
require_once(__DIR__ . '/Utils/MWSApiFacade.php');


use YandexMoney3\Utils\ApiNetworkClient;
use YandexMoney3\Utils\ApiFacade;
use YandexMoney3\Utils\MWSApiFacade;

class YandexMoney3 
{
    public static function getApiNetworkClient()
    {
        return new ApiNetworkClient();
    }

    public static function getApiFacade()
    {
        return new ApiFacade();
    }
    
    public static function getMwsApiFacade($options = array())
    {
        return new MWSApiFacade($options);
    }
}