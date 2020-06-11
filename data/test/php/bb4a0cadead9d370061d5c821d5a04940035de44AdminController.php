<?php
/**
 * @file
 *
 */

namespace User\Controller;


use Application\Controller\AbstractController;
use Doctrine\Common\Persistence\ObjectRepository;
use User\Entity\User;

class AdminController extends AbstractController
{
    /**
     * @var ObjectRepository
     */
    protected $repository;

    public function __construct(ObjectRepository $objectRepository)
    {
        $this->setRepository($objectRepository);
    }

    public function indexAction()
    {
        // todo: paginator require.
        $users = $this->getRepository()->findAll();

        return array('users' => $users);
    }

    public function editAction(User $user)
    {
        return array('user' => $user);
    }

    public function viewAction(User $user)
    {
        return array('user' => $user);
    }

    /**
     * @return ObjectRepository
     */
    public function getRepository()
    {
        return $this->repository;
    }

    /**
     * @param ObjectRepository $repository
     *
     * @return self
     */
    public function setRepository(ObjectRepository $repository)
    {
        $this->repository = $repository;

        return $this;
    }
}