<?php
namespace ZucchiSecurity\Permissions;
 
use ZucchiSecurity\Permissions\Service as PermissionsService;
use Zucchi\ServiceManager\ServiceManagerAwareTrait;

trait PermissionsAwareTrait
{
    use ServiceManagerAwareTrait;
    
    /**
     * 
     * @var ZucchiSecurity\Permissions\Service
     */
    protected $permissionsService;
    
	/**
     * @return the $permissionsService
     */
    public function getPermissionsService ()
    {
        if (!$this->permissionsService) {
            $this->permissionsService = $this->getServiceManager()
                                             ->getServiceLocator()
                                             ->get('zucchisecurity.perm');
        }
        return $this->permissionsService;
    }

	/**
     * @param \ZucchiSecurity\Permission\Service $permissionsService
     */
    public function setPermissionsService (PermissionsService $permissionsService)
    {
        $this->permissionsService = $permissionsService;
    }

}