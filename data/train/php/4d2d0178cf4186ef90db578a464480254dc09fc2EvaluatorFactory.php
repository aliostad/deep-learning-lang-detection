<?php

namespace BnpServiceDefinition\Factory;

use BnpServiceDefinition\Dsl\Language;
use BnpServiceDefinition\Service\Evaluator;
use BnpServiceDefinition\Service\ParameterResolver;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class EvaluatorFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        /** @var $language Language */
        $language = $serviceLocator->get('BnpServiceDefinition\Dsl\Language');
        /** @var $parameterResolver ParameterResolver */
        $parameterResolver = $serviceLocator->get('BnpServiceDefinition\Service\ParameterResolver');

        return new Evaluator($language, $parameterResolver);
    }
}
