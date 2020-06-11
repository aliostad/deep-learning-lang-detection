<?php
/**
 * SettingHelper.php
 *
 * @author  Jiří Šifalda <sifalda.jiri@gmail.com>
 * @date    16.02.13
 */

namespace Flame\CMS\SettingBundle\Templating\Helpers;

class SettingHelper extends \Nette\Object
{

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
