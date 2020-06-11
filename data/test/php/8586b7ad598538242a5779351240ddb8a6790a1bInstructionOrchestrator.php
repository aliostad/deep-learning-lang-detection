<?php

namespace Cocktales\Domain\Instruction;

use Cocktales\Domain\Instruction\Components\Repository;
use Illuminate\Support\Collection;

class InstructionOrchestrator
{
    /**
     * @var Repository
     */
    private $repository;

    /**
     * InstructionOrchestrator constructor.
     * @param Repository $repository
     */
    public function __construct(Repository $repository)
    {
        $this->repository = $repository;
    }

    /**
     * @param array $instructions
     * @param int $cocktail_id
     */
    public function addInstruction(array $instructions, int $cocktail_id)
    {
        $this->repository->addInstruction($instructions, $cocktail_id);
    }

    /**
     * @param int $id
     * @return Collection
     */
    public function getInstructionsByCocktailId(int $id): Collection
    {
        return $this->repository->getInstructionsByCocktailId($id);
    }
}
