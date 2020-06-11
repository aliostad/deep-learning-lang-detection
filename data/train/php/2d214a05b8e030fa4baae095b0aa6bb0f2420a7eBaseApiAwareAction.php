<?php

/**
 * @copyright wiseape GmbH
 * @author Ruben Rögels
 * @license LGPL-3.0+
 */

namespace Wiseape\Payum\SofortUberweisung\Action\Api;

use Payum\Core\Action\ActionInterface;
use Payum\Core\ApiAwareInterface;
use Payum\Core\Exception\UnsupportedApiException;
use Wiseape\Payum\SofortUberweisung\Api;

abstract class BaseApiAwareAction implements ActionInterface, ApiAwareInterface {

    /**
     * @var \Wiseape\Payum\SofortUberweisung\Api
     */
    protected $api;

    /**
     * {@inheritdoc}
     */
    public function setApi($api) {
        if(false == $api instanceof Api) {
            throw new UnsupportedApiException('Not supported.');
        }

        $this->api = $api;
    }

}