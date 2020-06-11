<?php

namespace ArenaPl\ApiCall;

use ArenaPl\ApiCallExecutor\ApiCallExecutorInterface;

class ApiCallFactory
{
    /**
     * Every API call class has this namespace.
     */
    const API_CALL_NAMESPACE = '\\ArenaPl\\ApiCall\\';

    /**
     * @var ApiCallExecutorInterface
     */
    protected $apiCallExecutor;

    /**
     * @var string[]
     */
    protected $resolvedClasses = [];

    /**
     * @param ApiCallExecutorInterface $apiCallExecutor
     *
     * @return self
     */
    public function __construct(ApiCallExecutorInterface $apiCallExecutor)
    {
        $this->apiCallExecutor = $apiCallExecutor;

        return $this;
    }

    /**
     * Returns API Call objects.
     *
     * @param string $apiCallClass class name
     *
     * @return ApiCallInterface
     *
     * @throws \InvalidArgumentException when wrong class name provided
     */
    public function getApiCall($apiCallClass)
    {
        if (!isset($this->resolvedClasses[$apiCallClass])) {
            $this->resolvedClasses[$apiCallClass] = $this->resolveApiCallClass($apiCallClass);
        }

        return new $this->resolvedClasses[$apiCallClass]($this->apiCallExecutor);
    }

    /**
     * @param string $apiCallClass class name
     *
     * @return string resolved class name
     *
     * @throws \InvalidArgumentException when wrong class name provided
     */
    protected function resolveApiCallClass($apiCallClass)
    {
        $namespacedApiCallClass = self::API_CALL_NAMESPACE . $apiCallClass;

        if (!class_exists($namespacedApiCallClass)) {
            throw new \InvalidArgumentException(sprintf(
                'API call class "%s" not exists',
                $apiCallClass
            ));
        }

        if (!is_subclass_of($namespacedApiCallClass, '\ArenaPl\ApiCall\ApiCallInterface')) {
            throw new \InvalidArgumentException(sprintf(
                'Class "%s" does not implement ApiCallInterface',
                $apiCallClass
            ));
        }

        return $namespacedApiCallClass;
    }
}
