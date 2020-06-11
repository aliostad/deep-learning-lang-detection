<?php

namespace Play\UseCase;

use Play\Repository\IngredientRepository;

class CreateIngredientUC
{

    private $ingredientRepository;

    public function __construct(IngredientRepository $ingredientRepository)
    {
        $this->ingredientRepository = $ingredientRepository;
    }

    public function execute(CreateIngredientRequest $request)
    {
        $ingredient = $this->ingredientRepository->create();
        $ingredient->setName($request->getName());
        $this->ingredientRepository->save($ingredient);

        return new CreateIngredientResponse($ingredient->getId());
    }
}
