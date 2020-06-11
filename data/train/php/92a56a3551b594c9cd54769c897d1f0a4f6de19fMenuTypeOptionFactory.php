<?php

namespace Admin;

use Model\MenuTypeFacade;
use Model\SectionFacade;
use Nette\Object;

/**
 * @author Petr Hlavac
 */
class MenuTypeOptionFactory extends Object
{

	/** @var MenuTypeFacade */
	protected $menuTypeFacade;

	/** @var SectionFacade */
	protected $sectionFacade;

	/**
	 * @param \Model\MenuTypeFacade $menuTypeFacade
	 * @param \Model\SectionFacade $sectionFacade
	 */
	function __construct(MenuTypeFacade $menuTypeFacade, SectionFacade $sectionFacade)
	{
		$this->menuTypeFacade = $menuTypeFacade;
		$this->sectionFacade = $sectionFacade;
	}

	/**
	 * @param int $id
	 * @return array
	 */
	public function getOptionsBySection($id)
	{
		return $this->sectionFacade->getMenuType($id)
			->select('menu_type.name, menu_type.code')
			->order('name')
			->fetchPairs('code', 'name');
	}

	/**
	 * @return array
	 */
	public function getOptions()
	{
		return $this->menuTypeFacade->all()
			->order('name')
			->fetchPairs('code', 'name');
	}

}
