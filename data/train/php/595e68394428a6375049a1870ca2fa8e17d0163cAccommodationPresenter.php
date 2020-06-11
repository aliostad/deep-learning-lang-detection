<?php

namespace JR\CMS\Modules\FrontOfficeModule\AccommodationModule\Presenters;

use JR\CMS\Application\UI\Presenter;
use JR\CMS\Modules\PageModule\Model\Facades\PageFacade\IPageFacade;
use JR\CMS\Modules\AccommodationModule\Model\Facades\AccommodationFacade\IAccommodationFacade;

/**
 * Description of AccommodationPresenter.
 *
 * @author RebendaJiri <jiri.rebenda@htmldriven.com>
 */
class AccommodationPresenter extends Presenter
{
	/**
	 * @persistent
	 * @var int Page ID
	 */
	public $id;
	
	/**
	 * @inject
	 * @var IPageFacade
	 */
	public $pageFacade;
	
	/**
	 * @inject
	 * @var IAccommodationFacade
	 */
	public $accommodationFacade;
	
	/**
	 * Shortcut for finding page with given ID.
	 * 
	 * @param int
	 * @return Entities\Page
	 */
	public function getPage($id)
	{
		return $this->pageFacade->findOnePage($id);
	}
	
	public function getAccommodation($id)
	{
		return $this->accommodationFacade->findOneAccommodation($id);
	}
	
	/*
	 * @inheritdoc
	 */
	protected function createTemplate()
	{
		$tpl = parent::createTemplate();
		$page = $this->getPage($this->id);
		$tpl->accommodation = $this->accommodationFacade->findOneAccommodationByPage($page);
		return $tpl;
	}
}
