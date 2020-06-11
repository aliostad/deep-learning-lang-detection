<?php namespace Rpgo\Application\Commands\Handlers;

use Rpgo\Application\Commands\RenameLocationCommand;
use Rpgo\Application\Repository\LocationRepository;

class RenameLocationCommandHandler {
    /**
     * @var LocationRepository
     */
    private $repository;

    /**
     * Create the command handler.
     * @param LocationRepository $repository
     */
	public function __construct(LocationRepository $repository)
	{
        $this->repository = $repository;
    }

	/**
	 * Handle the command.
	 *
	 * @param  RenameLocationCommand  $command
	 * @return void
	 */
	public function handle(RenameLocationCommand $command)
	{
        $location = $command->location;

		$location->name($command->name);

        $this->repository->save($location);

        return $location;
	}

}
