<?php
namespace FrontModule;

use Nette\Application\UI\Form;

class SkolkaPresenter extends SecurityPresenter
{
	
	public function renderDefault($edit=false) {
		$this->edit($edit);
	}

	public function renderProvoz($edit=false) {
		$this->edit($edit);
		
		$facade = $this->getContext()->textFacade;
		$this->template->text = $facade->getTextById(1);
	}

	public function renderProstredi($edit=false) {
		$this->edit($edit);
		
		$facade = $this->getContext()->textFacade;
		$this->template->text = $facade->getTextById(2);
	}

	public function renderDokumenty($edit=false) {
		$this->edit($edit);
		
		$facade = $this->getContext()->textFacade;
		$this->template->text = $facade->getTextById(3);
	}

	public function renderNovinky($edit=false) {
		$this->edit($edit);
		
		$facade = $this->getContext()->listFacade;
		$this->template->novinky = $facade->getListItems(1, true);
	}

	public function renderProbehlo($edit=false) {
		$this->edit($edit);
		
		
	}


}
