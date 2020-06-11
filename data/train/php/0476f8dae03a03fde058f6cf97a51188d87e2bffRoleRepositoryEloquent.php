<?php

namespace CodePress\CodeUser\Repository;

use CodePress\CodeDatabase\AbstractRepository;
use CodePress\CodeUser\Models\Role;

class RoleRepositoryEloquent extends AbstractRepository implements RoleRepositoryInterface
{
    /**
     * @var PermissionRepositoryInterface
     */
    private $permissionRepository;

    /**
     * RoleRepositoryEloquent constructor.
     * @param PermissionRepositoryInterface $permissionRepository
     */
    public function __construct(PermissionRepositoryInterface $permissionRepository)
    {
        parent::__construct();
        $this->permissionRepository = $permissionRepository;
    }

    public function addPermissions($id, array $permissions)
    {
        $model = $this->find($id);

        foreach ($permissions as $v) {
            $model->permissions()->save($this->permissionRepository->find($v));
        }

        return $model;
    }

    public function model()
    {
        return Role::class;
    }
}
