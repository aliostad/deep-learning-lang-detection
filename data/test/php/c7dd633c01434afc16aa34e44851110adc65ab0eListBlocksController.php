<?php

namespace Block;

class ListBlocksController
{

	/** @var \Block\ResponseGenerator\IListResponseGenerator */
	private $responseGenerator;

	/** @var \Block\ListBlocksFacade */
	private $facade;

	public function __construct(
		\Block\ListBlocksFacade $facade,
		\Block\ResponseGenerator\IListResponseGenerator $responseGenerator
	)
	{
		$this->responseGenerator = $responseGenerator;
		$this->facade = $facade;
	}

	/**
	 * @param \User\Entity\User $user
	 * @return \stdClass[]
	 */
	public function run(\User\Entity\User $user)
	{
		$blocks = $this->facade->getBlocksByUser($user);
		return $this->responseGenerator->generate($blocks);
	}
}