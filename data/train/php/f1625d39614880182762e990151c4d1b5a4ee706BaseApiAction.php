<?php

namespace Ekyna\Component\Payum\Sips\Action\Api;

use Ekyna\Component\Payum\Sips\Api\Api;
use Payum\Core\Action\GatewayAwareAction;
use Payum\Core\ApiAwareInterface;
use Payum\Core\Exception\UnsupportedApiException;

/**
 * Class BaseApiAction
 * @package Ekyna\Component\Payum\Sips\Action\Api
 * @author Étienne Dauvergne <contact@ekyna.com>
 */
abstract class BaseApiAction extends GatewayAwareAction implements ApiAwareInterface
{
    /**
     * @var Api
     */
    protected $api;

    /**
     * {@inheritDoc}
     */
    public function setApi($api)
    {
        if (false == $api instanceof Api) {
            throw new UnsupportedApiException('Not supported.');
        }

        $this->api = $api;
    }
}