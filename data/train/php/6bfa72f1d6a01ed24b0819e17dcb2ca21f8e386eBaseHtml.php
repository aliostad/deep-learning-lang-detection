<?php
namespace CashbackApi\Restrictions\Html;

use CashbackApi\BaseApi;
use CashbackApi\Reseller\BaseReseller;
use CashbackApi\Whitelabel\BaseWhitelabel;


/**
 * Class BaseHtml
 * @package CashbackApi\Restrictions\Html
 */
abstract class BaseHtml
{
    protected $output = '';
    public static $typesList = false;
    /**
     * @var null|BaseApi|BaseReseller|BaseWhitelabel
     */
    protected $api = null;

    public function __construct(BaseApi $api = null)
    {
        if (isset($api)) {
            $this->setApi($api);
        }
        $api = $this->getApi();
        if ($api == null) {
            return;
        }
        static::$typesList = $api->getApiRestrictions()->getRestrictionTypesForList(true);
    }

    /**
     * @return bool
     */
    public function getTypesList()
    {
        return static::$typesList;

    }

    public function html($return = false)
    {
        if ($return) {
            return $this->output;
        }
        echo $this->output;
    }

    public static function getTypesListArray()
    {
        $returnValue = [];
        if (static::$typesList) {
            foreach (static::$typesList as $type) {
                $returnValue[] = $type->type;
            }
        }
        return $returnValue;
    }

    /**
     * @return null
     */
    public function getApi()
    {
        return $this->api;
    }

    /**
     * @param null $api
     */
    public function setApi(BaseApi $api)
    {
        $this->api = $api;
    }
}