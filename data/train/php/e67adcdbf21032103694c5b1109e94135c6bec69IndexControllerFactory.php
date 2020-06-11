<?php

namespace ControlPanel\Factory;

use Domain\Service\MemberService;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use ControlPanel\Controller\IndexController;
use ControlPanel\Form\AuthorizationForm;

class IndexControllerFactory
implements FactoryInterface
{
    public function createService (ServiceLocatorInterface $serviceLocator)
    {
        $serviceLocator = $serviceLocator->getServiceLocator( );

        $name = "Domain\Service\MemberService";
        if ($serviceLocator->has($name))
        {
            $memberService = $serviceLocator->get($name);
        } else {
            throw new Exception ("Unable to locate " . $name . ".");
        }

        $name = "Domain\Service\ArticleService";
        if ($serviceLocator->has($name))
        {
            $articleService = $serviceLocator->get($name);
        } else {
            throw new Exception ("Unable to locate " . $name . ".");
        }

        $name = "Domain\Service\ArticleCategoryService";
        if ($serviceLocator->has($name))
        {
            $articleCategoryService = $serviceLocator->get($name);
        } else {
            throw new Exception ("Unable to locate " . $name . ".");
        }

        return new IndexController ($memberService, $articleService, $articleCategoryService, new AuthorizationForm( ));
    }
}