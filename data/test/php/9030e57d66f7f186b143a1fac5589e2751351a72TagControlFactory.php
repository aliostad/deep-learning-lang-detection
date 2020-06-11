<?php
/**
 * TagControlFactory.php
 *
 * @author  Jiří Šifalda <sifalda.jiri@gmail.com>
 * @package Flame\CMS
 *
 * @date    21.10.12
 */

namespace Flame\CMS\PostBundle\Components\Tags;

class TagControlFactory extends \Nette\Object
{

	/**
	 * @var \Flame\CMS\PostBundle\Model\Tags\TagFacade $tagFacade
	 */
	private $tagFacade;

	/**
	 * @var int
	 */
	private $countOfItems = 10;

	/** @var \Flame\CMS\SettingBundle\Model\SettingFacade */
	private $settingFacade;

	/**
	 * @param \Flame\CMS\SettingBundle\Model\SettingFacade $settingFacade
	 */
	public function injectSettingFacade(\Flame\CMS\SettingBundle\Model\SettingFacade $settingFacade)
	{
		$this->settingFacade = $settingFacade;
	}

	/**
	 * @param \Flame\CMS\PostBundle\Model\Tags\TagFacade $tagFacade
	 */
	public function injectTagFacade(\Flame\CMS\PostBundle\Model\Tags\TagFacade $tagFacade)
	{
		$this->tagFacade = $tagFacade;
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
		$countOfItems = $this->settingFacade->getSettingValue('menu_tagsCount');
		if((int) $countOfItems > 0) $this->countOfItems = (int) $countOfItems;
	}

}
