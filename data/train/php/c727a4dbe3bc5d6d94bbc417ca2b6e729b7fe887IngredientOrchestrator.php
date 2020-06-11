<?php

namespace Cocktales\Domain\Ingredient;

use Cocktales\Domain\Ingredient\Components\Repository;
use Illuminate\Support\Collection;

class IngredientOrchestrator
{
    /**
     * @var Repository
     */
    private $repository;

    /**
     * IngredientOrchestrator constructor.
     * @param Repository $repository
     */
    public function __construct(Repository $repository)
    {
        $this->repository = $repository;
    }

    /**
     * @return Collection
     */
    public function getIngredients(): Collection
    {
        return $this->repository->getIngredients();
    }

    /**
     * @param int $id
     * @return Ingredient
     * @throws \Cocktales\Framework\Exceptions\NotFoundException
     */
    public function getIngredientById(int $id): Ingredient
    {
        return $this->repository->getIngredientById($id);
    }
}
