<?php namespace Rpgo\Application\Commands\Handlers;

use Rpgo\Application\Commands\PublishWorldCommand;
use Rpgo\Application\Repository\WorldRepository;

class PublishWorldCommandHandler {
    /**
     * @var WorldRepository
     */
    private $repository;

    /**
     * Create the command handler.
     * @param WorldRepository $repository
     */
	public function __construct(WorldRepository $repository)
	{
		//
        $this->repository = $repository;
    }

	/**
	 * Handle the command.
	 *
	 * @param  PublishWorldCommand  $command
	 * @return void
	 */
	public function handle(PublishWorldCommand $command)
	{
		$world = $command->world;

        $world->publish();

        return $this->repository->save($world);
	}

}
