<?php

namespace AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * RepositoryStar.
 *
 * @ORM\Table
 * @ORM\Entity(repositoryClass="RepositoryStarRepository")
 * @ORM\EntityListeners({"RepositoryStarListener"})
 */
class RepositoryStar
{
    /**
     * @var User
     *
     * @ORM\Id
     * @ORM\ManyToOne(targetEntity="User")
     * @ORM\JoinColumn(name="user_id", referencedColumnName="id")
     */
    private $user;

    /**
     * @var Repository
     *
     * @ORM\Id
     * @ORM\ManyToOne(targetEntity="Repository")
     * @ORM\JoinColumn(name="repository_id", referencedColumnName="id")
     */
    private $repository;

    /**
     * @param Repository $repository
     * @param User       $user
     *
     * @return $this
     */
    public static function create(Repository $repository, User $user)
    {
        return (new self())
            ->setRepository($repository)
            ->setUser($user);
    }

    /**
     * @return User
     */
    public function getUser()
    {
        return $this->user;
    }

    /**
     * @param User $user
     *
     * @return $this
     */
    public function setUser(User $user)
    {
        $this->user = $user;

        return $this;
    }

    /**
     * @return Repository
     */
    public function getRepository()
    {
        return $this->repository;
    }

    /**
     * @param Repository $repository
     *
     * @return $this
     */
    public function setRepository(Repository $repository)
    {
        $this->repository = $repository;

        return $this;
    }
}
