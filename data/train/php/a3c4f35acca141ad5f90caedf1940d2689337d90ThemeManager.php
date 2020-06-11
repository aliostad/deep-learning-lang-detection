<?php
/**
 * ThemeManager.php
 *
 * @author  Jiří Šifalda <sifalda.jiri@gmail.com>
 * @package Flame\CMS
 *
 * @date    06.08.12
 */

namespace Flame\CMS\Templating;

class ThemeManager extends \Flame\Templating\ThemeManager
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
	 * @return string
	 */
	public function getTheme()
	{
		$theme = parent::getTheme();

		if($option = $this->settingFacade->getSettingValue('theme')){
			$path = $this->getDefaultThemeFolder() . DIRECTORY_SEPARATOR . $option;
			if($this->existTheme($option))
				$theme = $path;
		}

		return $theme;
	}
}
