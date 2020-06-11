<?php namespace PITG\Repository\Category;

use PITG\Repository\EloquentBaseRepository;
use PITG\Repository\Category\CategoryRepositoryInterface;
use Illuminate\Database\Eloquent\Model;

class EloquentCategoryRepository extends EloquentBaseRepository implements CategoryRepositoryInterface {
	
	/**
	 * Eloquent model
	 *
	 * @var Illuminate\Database\Eloquent\Model
	 */
	protected $category;

	/**
	 * Embed model to instance
	 *
	 * @return 	void
	 */
	public function __construct(Model $category)
	{
		parent::__construct($category)
		$this->category = $category;
	}
}