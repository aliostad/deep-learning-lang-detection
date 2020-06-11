<?php

/**
 * This file is part of the Venne:CMS (https://github.com/Venne)
 *
 * Copyright (c) 2011, 2012 Josef Kříž (http://www.josef-kriz.cz)
 *
 * For the full copyright and license information, please view
 * the file license.txt that was distributed with this source code.
 */

namespace CatalogModule\Pages\Catalog;

/**
 * @author Josef Kříž <pepakriz@gmail.com>
 */
class RoutePresenter extends AbstractRoutePresenter
{


	/** @var ItemRepository */
	private $repository;

	/** @var CategoryRepository */
	private $categoryRepository;


	/**
	 * @param ItemRepository $repository
	 * @param CategoryRepository $categoryRepository
	 */
	public function injectRepository(
		ItemRepository $repository,
		CategoryRepository $categoryRepository
	){
		$this->repository = $repository;
		$this->categoryRepository = $categoryRepository;
	}


	/**
	 * @return CategoryRepository
	 */
	protected function getCategoryRepository()
	{
		return $this->categoryRepository;
	}


	/**
	 * @return ItemRepository
	 */
	protected function getRepository()
	{
		return $this->repository;
	}


}
