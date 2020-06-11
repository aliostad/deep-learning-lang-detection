<?php
/**
 * TagControlFactory.php
 *
 * @author  Jiří Šifalda <sifalda.jiri@gmail.com>
 * @package Flame\CMS
 *
 * @date    21.10.12
 */

namespace Flame\CMS\Components\Tags;

class TagControlFactory extends \Nette\Object
{

	/**
	 * @var \Flame\CMS\Models\Options\OptionFacade $optionFacade
	 */
	private $optionFacade;

	/**
	 * @var \Flame\CMS\Models\Tags\TagFacade $tagFacade
	 */
	private $tagFacade;

	/**
	 * @var int
	 */
	private $countOfItems = 10;

	/**
	 * @param \Flame\CMS\Models\Tags\TagFacade $tagFacade
	 */
	public function injectTagFacade(\Flame\CMS\Models\Tags\TagFacade $tagFacade)
	{
		$this->tagFacade = $tagFacade;
	}

	/**
	 * @param \Flame\CMS\Models\Options\OptionFacade $optionFacade
	 */
	public function injectOptionFacade(\Flame\CMS\Models\Options\OptionFacade $optionFacade)
	{
		$this->optionFacade = $optionFacade;
	}

	/**
	 * @param null $data
	 * @return TagControl
	 */
	public function create($data = null)
	{
		$this->initCountOfItems();
		$control = new TagControl();
		$control->setItems($this->tagFacade->getLastTags($this->countOfItems));
		return $control;
	}

	private function initCountOfItems()
	{
		$countOfItems = $this->optionFacade->getOptionValue('Menu:TagsCount');
		if((int) $countOfItems > 0) $this->countOfItems = (int) $countOfItems;
	}

}
