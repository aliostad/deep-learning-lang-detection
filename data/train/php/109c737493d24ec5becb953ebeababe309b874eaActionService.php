<?php

namespace Action\Service;

class ActionService
{
	/**
	 * @var IdleService
	 */
	protected $idleService;

	/**
	 * @var MoveService
	 */
	protected $moveService;

	public function __construct(
		IdleService $idleService,
		MoveService $moveService
	)
	{
		$this->idleService = $idleService;
		$this->moveService = $moveService;
	}

	/**
	 * @return IdleService
	 */
	public function getIdleService()
	{
		return $this->idleService;
	}

	/**
	 * @return MoveService
	 */
	public function getMoveService()
	{
		return $this->moveService;
	}
}