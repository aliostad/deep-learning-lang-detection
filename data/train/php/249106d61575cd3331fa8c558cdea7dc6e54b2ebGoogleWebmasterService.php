<?php

namespace Networking\Service;

use Google_Client;
use Google_Service_Calendar;
use Google_Service_People;
use Google_Service_Webmasters;

/**
 * Class GoogleWebmasterService
 *
 * PHP Version 5
 *
 * @category  PHP
 * @package   Networking\Service
 * @author    Simplicity Trade GmbH <it@simplicity.ag>
 * @copyright 2014-2016 Simplicity Trade GmbH
 * @license   Proprietary http://www.simplicity.ag
 */
class GoogleWebmasterService
{
    /**
     * @var Google_Service_Webmasters
     */
    protected $webmasterService;

    /**
     * GoogleClientService constructor.
     * @param Google_Service_Webmasters $webmasterService
     */
    public function __construct(Google_Service_Webmasters $webmasterService)
    {
        $this->webmasterService = $webmasterService;
    }
}
