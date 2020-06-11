<?php
/**
 * CategoryControlFactory.php
 *
 * @author  Jiří Šifalda <sifalda.jiri@gmail.com>
 * @package Flame\CMS
 *
 * @date    21.10.12
 */

namespace Flame\CMS\Components\Categories;

class CategoryControlFactory extends \Nette\Object
{

	/**
	 * @var \Flame\CMS\Models\Categories\CategoryFacade $categoryFacade
	 */
	private $categoryFacade;

	/**
	 * @param \Flame\CMS\Models\Categories\CategoryFacade $categoryFacade
	 */
	public function injectCategoryFacade(\Flame\CMS\Models\Categories\CategoryFacade $categoryFacade)
	{
		$this->categoryFacade = $categoryFacade;
	}

	/**
	 * @param null $data
	 * @return CategoryControl
	 */
	public function create($data = null)
	{
		$control = new CategoryControl();
		$control->setItems($this->categoryFacade->getLastCategories());
		return $control;
	}

}
