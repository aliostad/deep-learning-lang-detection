<?php namespace App;

use App\Contracts\IdeaRepositoryInterface;

class IdeaController {

	/**
	 * @var IdeaRepositoryInterface
	 */
	protected $ideaRepository;

	/**
	 * Instantiate our dependencies.
	 *
	 * @param IdeaRepositoryInterface $ideaRepository
	 */
	public function __construct(IdeaRepositoryInterface $ideaRepository) {
		$this->ideaRepository = $ideaRepository;
	}

	/**
	 * Get a listing of ideas.
	 *
	 * @return Collection
	 */
	public function index() {

	}

	/**
	 * Delete an idea.
	 *
	 * @param  int $id
	 * @return bool
	 */
	public function delete($id) {

	}

}
