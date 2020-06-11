<?php
/**
 * DoctrineAchievementsProvider
 *
 * @category  AxalianAchievementsDoctrine\AchievementsProvider
 * @package   AxalianAchievementsDoctrine\AchievementsProvider
 * @author    Michel Maas <michel@michelmaas.com>
 */

namespace AxalianAchievementsDoctrine\AchievementProvider;

use AxalianAchievements\AchievementProvider\AchievementProviderInterface;
use AxalianAchievementsDoctrine\Repository\AchievementRepository;
use AxalianAchievementsDoctrine\Repository\CategoryRepository;

class DoctrineAchievementProvider implements AchievementProviderInterface
{
    /**
     * @var AchievementRepository
     */
    protected $achievementRepository;

    /**
     * @var CategoryRepository
     */
    protected $categoryRepository;

    /**
     * @var array
     */
    protected $achievements;

    /**
     * @var array
     */
    protected $categories;

    /**
     * @param AchievementRepository $achievementRepository
     * @param CategoryRepository $categoryRepository
     */
    public function __construct(AchievementRepository $achievementRepository, CategoryRepository $categoryRepository)
    {
        $this->setAchievementRepository($achievementRepository);
        $this->setCategoryRepository($categoryRepository);
    }

    /**
     * @return array
     */
    public function getAchievements()
    {
        if (count($this->achievements) == 0) {
            $this->setAchievements($this->getAchievementRepository()->findAll());
        }

        return $this->achievements;
    }

    /**
     * @return array
     */
    public function getCategories()
    {
        if (count($this->categories) == 0) {
            $this->setCategories($this->getCategoryRepository()->findAll());
        }

        return $this->categories;
    }

    /**
     * @return AchievementRepository
     */
    public function getAchievementRepository()
    {
        return $this->achievementRepository;
    }

    /**
     * @param AchievementRepository $achievementRepository
     * @return self
     */
    public function setAchievementRepository($achievementRepository)
    {
        $this->achievementRepository = $achievementRepository;

        return $this;
    }

    /**
     * @return CategoryRepository
     */
    public function getCategoryRepository()
    {
        return $this->categoryRepository;
    }

    /**
     * @param CategoryRepository $categoryRepository
     * @return self
     */
    public function setCategoryRepository($categoryRepository)
    {
        $this->categoryRepository = $categoryRepository;

        return $this;
    }

    /**
     * @param array $achievements
     * @return self
     */
    public function setAchievements($achievements)
    {
        $this->achievements = $achievements;

        return $this;
    }

    /**
     * @param array $categories
     * @return self
     */
    public function setCategories($categories)
    {
        $this->categories = $categories;

        return $this;
    }
}
