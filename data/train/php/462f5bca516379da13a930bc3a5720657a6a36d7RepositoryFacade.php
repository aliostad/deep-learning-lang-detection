<?php

namespace Screwfix;

/**
 * RepositoryFacade
 *
 * @author Daniel Silovsky
 * @copyright (c) 2013, Daniel Silovsky
 * @license http://www.screwfix-calendar.co.uk/license
 */
abstract class RepositoryFacade {

	/**
	 * @var Repository
	 */
	protected $repository;
	
	/**
	 * @var Cache 
	 */
	protected $cache;

	/**
	 * @var CalendarDateTime 
	 */
	protected $date;
	
	public function __construct(Repository $repository, Cache $cache, CalendarDateTime $date)
	{
		$this->repository = $repository;
		$this->cache = $cache;
		$this->date = $date;
	}
}
