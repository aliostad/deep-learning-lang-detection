<?php

namespace jamesvweston\EasyPost;


use jamesvweston\EasyPost\Api\AddressApi;
use jamesvweston\EasyPost\Api\ApiKeyApi;
use jamesvweston\EasyPost\Api\BatchApi;
use jamesvweston\EasyPost\Api\CarrierAccountApi;
use jamesvweston\EasyPost\Api\CarrierTypeApi;
use jamesvweston\EasyPost\Api\CustomsInfoApi;
use jamesvweston\EasyPost\Api\CustomsItemApi;
use jamesvweston\EasyPost\Api\InsuranceApi;
use jamesvweston\EasyPost\Api\OrderApi;
use jamesvweston\EasyPost\Api\ParcelApi;
use jamesvweston\EasyPost\Api\PickupApi;
use jamesvweston\EasyPost\Api\ShipmentApi;
use jamesvweston\EasyPost\Api\TrackerApi;
use jamesvweston\EasyPost\Api\UserApi;

class EasyPostClient
{

    /**
     * @var EasyPostConfiguration
     */
    protected $easyPostConfiguration;


    /**
     * @var AddressApi
     */
    public $addressApi;

    /**
     * @var ApiKeyApi
     */
    public $apiKeyApi;

    /**
     * @var BatchApi
     */
    public $batchApi;

    /**
     * @var CarrierAccountApi
     */
    public $carrierAccountApi;

    /**
     * @var CarrierTypeApi
     */
    public $carrierTypeApi;

    /**
     * @var CustomsInfoApi
     */
    public $customsInfoApi;

    /**
     * @var CustomsItemApi
     */
    public $customsItemApi;

    /**
     * @var InsuranceApi
     */
    public $insuranceApi;

    /**
     * @var OrderApi
     */
    public $orderApi;

    /**
     * @var ParcelApi
     */
    public $parcelApi;

    /**
     * @var PickupApi
     */
    public $pickupApi;

    /**
     * @var ShipmentApi
     */
    public $shipmentApi;

    /**
     * @var TrackerApi
     */
    public $trackerApi;

    /**
     * @var UserApi
     */
    public $userApi;

    public function __construct(EasyPostConfiguration $easyPostConfiguration)
    {
        $this->easyPostConfiguration    = $easyPostConfiguration;

        $this->addressApi               = new AddressApi($this->easyPostConfiguration);
        $this->apiKeyApi                = new ApiKeyApi($this->easyPostConfiguration);
        $this->batchApi                 = new BatchApi($this->easyPostConfiguration);
        $this->carrierAccountApi        = new CarrierAccountApi($this->easyPostConfiguration);
        $this->carrierTypeApi           = new CarrierTypeApi($this->easyPostConfiguration);
        $this->customsInfoApi           = new CustomsInfoApi($this->easyPostConfiguration);
        $this->customsItemApi           = new CustomsItemApi($this->easyPostConfiguration);
        $this->insuranceApi             = new InsuranceApi($this->easyPostConfiguration);
        $this->orderApi                 = new OrderApi($this->easyPostConfiguration);
        $this->parcelApi                = new ParcelApi($this->easyPostConfiguration);
        $this->pickupApi                = new PickupApi($this->easyPostConfiguration);
        $this->shipmentApi              = new ShipmentApi($this->easyPostConfiguration);
        $this->trackerApi               = new TrackerApi($this->easyPostConfiguration);
        $this->userApi                  = new UserApi($this->easyPostConfiguration);
    }

    /**
     * @return EasyPostConfiguration
     */
    public function getEasyPostConfiguration()
    {
        return $this->easyPostConfiguration;
    }

    /**
     * @param EasyPostConfiguration $easyPostConfiguration
     */
    public function setEasyPostConfiguration($easyPostConfiguration)
    {
        $this->easyPostConfiguration = $easyPostConfiguration;
    }

}