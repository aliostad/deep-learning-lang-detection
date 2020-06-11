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

	/**
	 * @var \Flame\CMS\Models\Options\OptionFacade $optionFacade
	 */
	private $optionFacade;

	/**
	 * @param \Flame\CMS\Models\Options\OptionFacade $optionFacade
	 */
	public function injectOptionFacade(\Flame\CMS\Models\Options\OptionFacade $optionFacade)
	{
		$this->optionFacade = $optionFacade;
	}

	/**
	 * @return string
	 */
	public function getTheme()
	{
		$theme = parent::getTheme();

		if($option = $this->optionFacade->getOptionValue('Theme')){
			$path = $this->getDefaultThemeFolder() . DIRECTORY_SEPARATOR . $option;
			if($this->existTheme($option))
				$theme = $path;
		}

		return $theme;
	}
}
