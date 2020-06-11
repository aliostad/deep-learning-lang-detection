<?php
/**
 * ARTEMIS copyright message placeholder.
 *
 * @category Member
 *
 * @author    Andre Hebben  <andre.hebben@artemis-ia.eu>
 * @copyright Copyright (c) 2008-2014 ARTEMIS-IA (http://artemis-ia.eu)
 */
namespace Member\Service\Factory;

use Doctrine\ORM\EntityManager;
use Member\Options\ModuleOptions;
use Member\Service\MemberService;
use Member\Service\InvoiceService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
* Class MemberServiceFactory
*
* @package Member\Factory
*/
class MemberServiceFactory implements FactoryInterface
{
    /**
    * @param ServiceLocatorInterface $serviceLocator
    *
    * @return MemberService
    */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $memberService = new MemberService();
        /** @var EntityManager $entityManager */
        $entityManager = $serviceLocator->get(EntityManager::class);
        $memberService->setEntityManager($entityManager);

        /** @var ModuleOptions $moduleOptions */
        $moduleOptions = $serviceLocator->get(ModuleOptions::class);
        $memberService->setOptions($moduleOptions);

        /** @var InvoiceService $invoiceService */
        $invoiceService = $serviceLocator->get(InvoiceService::class);
        $memberService->setInvoiceService($invoiceService);

        return $memberService;
    }
}
