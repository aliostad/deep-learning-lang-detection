<?php

namespace ThePot\Interactor;

use ThePot\Validator\PlayerValidator;
use ThePot\Repository\PlayerRepository;
use ThePot\Entity\PlayerEntity;

class CreatePlayerInteractor
{
	private $validator;
	private $repository;

    public function __construct(
		PlayerValidator $validator,
		PlayerRepository $repository
	) {
        $this->validator = $validator;
		$this->repository = $repository;
    }

	public function execute(array $data)
	{
		$player = new PlayerEntity($data);

		$this->validator->validate($player);

		$this->repository->create($player);
	}
}
