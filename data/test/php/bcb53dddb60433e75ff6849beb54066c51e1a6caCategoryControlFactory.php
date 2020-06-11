<?php
/**
 * CategoryControlFactory.php
 *
 * @author  Jiří Šifalda <sifalda.jiri@gmail.com>
 * @package Flame\CMS
 *
 * @date    21.10.12
 */

namespace Flame\CMS\PostBundle\Components\Categories;

class CategoryControlFactory extends \Nette\Object
{

	/**
	 * @var \Flame\CMS\PostBundle\Model\Categories\CategoryFacade $categoryFacade
	 */
	private $categoryFacade;

	/**
	 * @param \Flame\CMS\PostBundle\Model\Categories\CategoryFacade $categoryFacade
	 */
	public function injectCategoryFacade(\Flame\CMS\PostBundle\Model\Categories\CategoryFacade $categoryFacade)
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
