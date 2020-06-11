<?php

namespace SisConPat\Repositories;

use SisConPat\Service;

class ServiceRepository
{
	
	private $service;

	public function __construct(Service $service)
	{
		$this->service = $service;
	}

	public function allServices()
	{
		return $this->service
			->orderBy('description', 'asc')
			->get();
	}

	public function findServiceById($id)
    {
        return $this->service->find($id);
    }

    public function storeService($input)
    {
        $service = $this->service->fill($input);
        $service->save();
    }
}