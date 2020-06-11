<?php
/**
 * @license   http://opensource.org/licenses/BSD-3-Clause BSD-3-Clause
 * @copyright Copyright (c) 2014 Zend Technologies USA Inc. (http://www.zend.com)
 */

namespace ZF\Apigility\Documentation\Swagger;

use ZF\Apigility\Documentation\Api as BaseApi;

class Api extends BaseApi
{
    /**
     * @var BaseApi
     */
    protected $api;

    /**
     * @param BaseApi $api
     */
    public function __construct(BaseApi $api)
    {
        $this->api = $api;
    }

    /**
     * @return array
     */
    public function toArray()
    {
        $services = [];
        foreach ($this->api->services as $service) {
            $services[] = [
                'description' => ($description = $service->getDescription())
                ? $description
                : 'Operations for ' . $service->getName(),
                'path' => '/' . $service->getName()
            ];
        }

        return [
            'apiVersion' => $this->api->version,
            'swaggerVersion' => '1.2',
            /*
            'basePath' => '/api',
            'resourcePath' => '/' . $this->api->name,
            */
            'apis' => $services,
        ];
    }
}
