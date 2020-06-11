<?php

namespace DW\UserBundle\Service;

use DW\UserBundle\Entity\Role;
use DW\UserBundle\Repository\RoleRepository;

class RoleService
{
    /**
     * @var RoleRepository
     */
    private $roleRepository;

    /**
     * @param RoleRepository $roleRepository
     */
    public function __construct(RoleRepository $roleRepository)
    {
        $this->roleRepository = $roleRepository;
    }

    /**
     * @param string $name
     * @return Role
     */
    public function getRoleByName(string $name) : Role
    {
        return $this->roleRepository->findOneByName($name);
    }
}