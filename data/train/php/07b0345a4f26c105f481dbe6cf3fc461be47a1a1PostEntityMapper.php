<?php

namespace Fire\Model\Post;

use Fire\Foundation\Collection;
use Fire\Contracts\Model\EntityMapper as EntityMapperContract;
use Fire\Contracts\Model\Entity as EntityContract;
use Fire\Contracts\Model\Post\PostRepository as PostRepositoryContract;
use Fire\Contracts\Model\Category\CategoryRepository as CategoryRepositoryContract;
use Fire\Contracts\Model\Tag\TagRepository as TagRepositoryContract;

class PostEntityMapper implements EntityMapperContract
{
    /**
     * @var Fire\Contracts\Model\Post\PostRepository
     */
    protected $postRepository;

    /**
     * @var Fire\Contracts\Model\Category\CategoryRepository
     */
    protected $categoryRepository;

    /**
     * @var Fire\Contracts\Model\Tag\TagRepository
     */
    protected $tagRepository;

    /**
     * @param Fire\Contracts\Model\Post\PostRepository          $postRepository
     * @param Fire\Contracts\Model\Category\CategoryRepository  $categoryRepository
     * @param Fire\Contracts\Model\Tag\TagRepository            $tagRepository
     */
    public function __construct(
        PostRepositoryContract $postRepository,
        CategoryRepositoryContract $categoryRepository,
        TagRepositoryContract $tagRepository
    ) {
        $this->postRepository     = $postRepository;
        $this->categoryRepository = $categoryRepository;
        $this->tagRepository      = $tagRepository;
    }

    public function map(EntityContract $entity, array $data)
    {
        $id = $data['post_parent'];

        $entity->setParent(function () use ($id) {
            $parent = null;

            if ($id) {
                $parent = $this->postRepository->postOfId($id);
            }

            return $parent;
        });

        $id = $data['ID'];

        $entity->setCategories(function () use ($id) {
            $categories = new Collection;

            foreach (wp_get_post_categories($id) as $termId) {
                $categories->push($this->categoryRepository->categoryOfId($termId));
            }

            return $categories;
        });

        $entity->setTags(function () use ($id) {
            $tags = new Collection;

            foreach (wp_get_post_tags($id) as $termId) {
                $tags->push($this->tagRepository->tagOfId($termId));
            }

            return $tags;
        });
    }
}
