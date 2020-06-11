<?php

namespace Test\ServiceBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;

class ServiceTestController extends Controller
{

    /**
     * @Route("/service-test")
     * @Template()
     */
    public function serviceTestAction()
    {
        $annotationService = $this->container->get('phpstorm.annotation_service');
        $phpService = $this->container->get('phpstorm.php_service');
        $ymlService = $this->container->get('phpstorm.yml_service');
        $xmlService = $this->container->get('phpstorm.xml_service');
        $serviceNames =
            [
                $annotationService->getServiceName(),
                $phpService->getServiceName(),
                $ymlService->getServiceName(),
                $xmlService->getServiceName(),
            ];

        return ['serviceNames' => $serviceNames];
    }
}



