<?php
/**
 * Created by PhpStorm.
 * User: vlad
 * Date: 7/24/14
 * Time: 7:25 PM
 */

namespace ModelFramework\AclService;

trait AclServiceAwareTrait
{
    private $_aclService = null;

    /**
     * @param AclServiceInterface $aclService
     *
     * @return $this
     */
    public function setAclService(AclServiceInterface $aclService)
    {
        $this->_aclService = $aclService;
    }

    /**
     * @return AclServiceInterface
     */
    public function getAclService()
    {
        return $this->_aclService;
    }

    /**
     * @return AclServiceInterface
     * @throws \Exception
     */
    public function getAclServiceVerify()
    {
        $_aclService = $this->getAclService();
        if ($_aclService == null || ! $_aclService instanceof AclServiceInterface) {
            throw new \Exception('AclService does not set in the AclServiceAware instance of '.get_class($this));
        }

        return $_aclService;
    }
}
