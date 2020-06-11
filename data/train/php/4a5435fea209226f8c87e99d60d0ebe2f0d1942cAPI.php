<?php

namespace MWP;

use MWP\Entity\Group;
use MWP\Entity\User;
use MWP\Repository\FavoriteRepository;
use MWP\Repository\GroupRepository;
use MWP\Repository\RepositoryManager;
use MWP\Repository\SiteRepository;
use MWP\Repository\UserRepository;

class API
{
    protected $repositoryManager;

    function __construct(RepositoryManager $repositoryManager)
    {
        $this->repositoryManager = $repositoryManager;
    }


    public function getSitesByUser(User $user)
    {
        /** @var $repository SiteRepository */
        $repository = $this->repositoryManager->getRepository('Site');

        $data = array();
        $sites = $repository->findByUser($user);
        foreach ($sites as $site) {
            $data[$site->getId()] = array(
                'id' => $site->getId(),
                'name' => $site->getWpUrl(),
                'key' => $site->getSiteKey(),
            );
        }
        return $data;
    }

    /**
     * @param Entity\User $user
     * @param bool $includeZeroGroup
     * @return array
     */
    public function getGroupsByUser(User $user, $includeZeroGroup = false)
    {
        /** @var $repository GroupRepository */
        $repository = $this->repositoryManager->getRepository('Group');

        $data = array();
        $groups = $repository->findByUser($user);
        if ($includeZeroGroup) {
            $groups[] = $this->getZeroGroupByUser($user);
        }
        foreach ($groups as $group) {
            $data[$group->getId()] = array(
                'id' => $group->getId(),
                'name' => $group->getGroupName(),
                'sites' => $group->getSiteIds()
            );
        }
        return $data;
    }

    /**
     * @param User $user
     * @param string $name
     * @return Group
     */
    public function getZeroGroupByUser(User $user, $name = "Ungrouped")
    {
        /** @var $repository SiteRepository */
        $repository = $this->repositoryManager->getRepository('Site');
        $ids = $repository->findUngroupedIdsByUser($user);
        $group = new Group();
        $group->setId(0);
        $group->setGroupName($name);
        $group->setSiteIds($ids);
        return $group;
    }

    public function getFavorites($type, $limit)
    {
        /** @var $repository FavoriteRepository */
        $repository = $this->repositoryManager->getRepository('Favorite');

        $data = array();
        $favorites = $repository->findPopular($type, array('limit' => $limit));
        foreach ($favorites as $favorite) {
            $data[$favorite->getUrl()] = array(
                'name' => $favorite->getName(),
                'description' => $favorite->getDescription(),
                'popularity' => $favorite->getPopularity(),
                'url' => $favorite->getUrl(),
            );
        }
        return $data;
    }

    /**
     * @param $int
     * @return User|null
     */
    public function getUserById($int)
    {
        /** @var $repository UserRepository */
        $repository = $this->repositoryManager->getRepository('User');

        $user = $repository->findById($int);
        return $user;
    }
}