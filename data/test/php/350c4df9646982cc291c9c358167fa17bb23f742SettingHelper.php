<?php
/**
 * SettingHelper.php
 *
 * @author  Jiří Šifalda <sifalda.jiri@gmail.com>
 * @date    16.02.13
 */

namespace Flame\Blog\SettingBundle\Templating\Helpers;

class SettingHelper extends \Nette\Object
{

	/** @var \Flame\Blog\SettingBundle\Entity\Settings\SettingFacade */
	private $settingFacade;

	/**
	 * @param \Flame\Blog\SettingBundle\Entity\Settings\SettingFacade $settingFacade
	 */
	public function injectSettingFacade(\Flame\Blog\SettingBundle\Entity\Settings\SettingFacade $settingFacade)
	{
		$this->settingFacade = $settingFacade;
	}

	/**
	 * @param $setting
	 * @return string
	 */
	public function setting($setting)
	{
		if($setting = $this->settingFacade->getOneByName($setting)){
			return $setting->getValue();
		}
	}

}
