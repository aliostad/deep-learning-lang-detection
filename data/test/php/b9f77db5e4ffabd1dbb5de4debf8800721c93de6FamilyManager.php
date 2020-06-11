<?php

namespace Fambad\Service\Family;

use Fambad\Repository\FamilyRepository;
use Fambad\Repository\UserRepository;
use Fambad\Model\User\AuthUser;

class FamilyManager
{
    /**
     * @var FamilyRepository
     */
    private $familyRepository;

    /**
     * @var UserRepository
     */
    private $userRepository;

    /**
     * FamilyManager constructor.
     * @param FamilyRepository $familyRepository
     * @param UserRepository $userRepository
     */
    public function __construct(FamilyRepository $familyRepository, UserRepository $userRepository)
    {
        $this->familyRepository = $familyRepository;
        $this->userRepository = $userRepository;
    }

    /**
     * @param int $userId
     *
     * @return AuthUser[]
     */
    public function getUsersOfFamilyByUserId($userId)
    {
        $family = $this->familyRepository->getFamilyByUserId($userId);
        if (!$family) {
            return [];
        }

        $relationsOfFamily = $this->familyRepository->getRelationsOfFamily($family->getFamilyId());
        $userIds = [];
        foreach ($relationsOfFamily as $relation) {
            $userIds[] = $relation->getUserId();
        }

        if (empty($userIds)) {
            return [];
        }

        return $this->userRepository->getUsersByIds($userIds);
    }
}