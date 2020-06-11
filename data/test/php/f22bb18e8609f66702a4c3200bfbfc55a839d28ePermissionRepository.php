<?php

namespace JhUser\Repository;

use Doctrine\Common\Persistence\ObjectRepository;
use JhUser\Entity\Permission;

/**
 * Class PermissionRepository
 * @package JhUser\Repository
 * @author Aydin Hassan <aydin@hotmail.co.uk>
 */
class PermissionRepository implements PermissionRepositoryInterface, ObjectRepository
{

    /**
     * @var \Doctrine\Common\Persistence\ObjectRepository
     */
    protected $permissionRepository;

    /**
     * @param ObjectRepository $permissionRepository
     */
    public function __construct(ObjectRepository $permissionRepository)
    {
        $this->permissionRepository = $permissionRepository;
    }

    /**
     * @param string $name
     * @return Permission|null
     */
    public function findByName($name)
    {
        return $this->permissionRepository->findOneBy(['name' => $name]);
    }

    /**
     * findAll(): defined by ObjectRepository.
     *
     * @see    ObjectRepository::findAll()
     * @return Permission[]
     */
    public function findAll()
    {
        return $this->permissionRepository->findAll();
    }

    /**
     * find(): defined by ObjectRepository.
     *
     * @see    ObjectRepository::find()
     * @param  int $id
     * @return Permission|null
     */
    public function find($id)
    {
        return $this->permissionRepository->find($id);
    }

    /**
     * findBy(): defined by ObjectRepository.
     *
     * @see    ObjectRepository::findBy()
     * @param  array      $criteria
     * @param  array|null $orderBy
     * @param  int|null   $limit
     * @param  int|null   $offset
     * @return Permission[]
     */
    public function findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
    {
        return $this->permissionRepository->findBy($criteria, $orderBy, $limit, $offset);
    }

    /**
     * findOneBy(): defined by ObjectRepository.
     *
     * @see    ObjectRepository::findOneBy()
     * @param  array $criteria
     * @return Permission|null
     */
    public function findOneBy(array $criteria)
    {
        return $this->permissionRepository->findOneBy($criteria);
    }

    /**
     * getClassName(): defined by ObjectRepository.
     *
     * @see    ObjectRepository::getClassName()
     * @return string
     */
    public function getClassName()
    {
        return $this->permissionRepository->getClassName();
    }
}
