<?php

namespace Ekyna\Component\Payum\Payzen\Action\Api;

use Ekyna\Component\Payum\Payzen\Api\Api;
use Payum\Core\Action\ActionInterface;
use Payum\Core\ApiAwareInterface;
use Payum\Core\Exception\UnsupportedApiException;
use Payum\Core\GatewayAwareInterface;
use Payum\Core\GatewayAwareTrait;

/**
 * Class AbstractApiAction
 * @package Ekyna\Component\Payum\Payzen\Action\Api
 * @author  Etienne Dauvergne <contact@ekyna.com>
 */
abstract class AbstractApiAction implements ActionInterface, GatewayAwareInterface, ApiAwareInterface
{
    use GatewayAwareTrait;

    /**
     * @var Api
     */
    protected $api;


    /**
     * @inheritDoc
     */
    public function setApi($api)
    {
        if (false == $api instanceof Api) {
            throw new UnsupportedApiException('Not supported.');
        }

        $this->api = $api;
    }
}
