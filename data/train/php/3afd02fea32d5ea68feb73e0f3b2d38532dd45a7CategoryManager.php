<?php

namespace Fambad\Service\Category;

use Fambad\Model\User\AuthUser;
use Fambad\Repository\CategoryRepository;
use Fambad\Repository\FamilyRepository;
use Fambad\Model\Category;

class CategoryManager
{
    /** @var FamilyRepository */
    private $familyRepository;

    /** @var CategoryRepository */
    private $categoryRepository;

    /**
     * @param FamilyRepository $familyRepository
     * @param CategoryRepository $categoryRepository
     */
    public function __construct(FamilyRepository $familyRepository, CategoryRepository $categoryRepository)
    {
        $this->familyRepository = $familyRepository;
        $this->categoryRepository = $categoryRepository;
    }

    /**
     * @param AuthUser $user
     * @param string $categoryName
     *
     * @return bool
     */
    public function add(AuthUser $user, $categoryName)
    {
        $family = $this->familyRepository->getFamilyByUserId($user->getUserId());

        return $this->categoryRepository
            ->insert(['family_id', 'category_name'])
            ->values([$family->getFamilyId(), $categoryName]);
    }

    /**
     * @param int $userId
     *
     * @return Category[]
     */
    public function getListOfCategoryByUserId($userId)
    {
        $family = $this->familyRepository->getFamilyByUserId($userId);

        return $this->categoryRepository->getListOfCategoriesByFamilyId($family->getFamilyId());
    }
}