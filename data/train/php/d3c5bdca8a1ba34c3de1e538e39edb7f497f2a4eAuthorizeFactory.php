<?php
/**
 * @author 		KIenNN

 */
namespace Authorize\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class AuthorizeFactory implements FactoryInterface
{
    /**
     * @param ServiceLocatorInterface $sl
     * @return \Authorize\Service\Authorize
     */
    public function createService(ServiceLocatorInterface $sl)
    {
        $service = new Authorize();
        $service->setServiceLocator($sl);
        $acl = $sl->get('Authorize\Permission\Acl');
//         $workService = $sl->get('Work\Service\Work');

//         $manageableProject = $workService->getManageableProjectIds();
//         if(count($manageableProject) == 1 && current($manageableProject) < 0){
//         	$userService = $sl->get('User\Service\User');
//         	$acl->denyProjectRole($userService->getRoleName());
//         }
        $service->setAcl($acl);
        $service->setUserService($sl->get('User\Service\User'));
        $service->loadPrivilege();
        return $service;
    }
}