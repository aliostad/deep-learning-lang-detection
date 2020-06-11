<?php
/**
 * @file
 *
 */

namespace User\Controller;


use Application\Controller\AbstractController;
use Doctrine\Common\Persistence\ObjectRepository;
use User\Entity\User;

class IndexController extends AbstractController
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
        $identity = $this->identity();
        if (!$identity instanceof User) {
            return $this->redirect()->toRoute('user/login');
        }

        return array('user' => $identity);
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
     * @return IndexController
     */
    public function setRepository(ObjectRepository $repository)
    {
        $this->repository = $repository;

        return $this;
    }
}