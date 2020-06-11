<?php namespace Api;

use Filmoteca\Repository\AuditoriumsRepository;

use Response;

use View;

class AuditoriumController extends ApiController
{
	public function __construct(AuditoriumsRepository $repository)
	{
		$this->repository = $repository;
	}

	public function all()
	{
		$resources = $this->repository->all();

		return Response::json($resources,200);
	}

	public function detail($id)
	{
		$auditorium = $this->repository->find($id);

		return View::make('auditoriums.detail', compact('auditorium'));
	}
}