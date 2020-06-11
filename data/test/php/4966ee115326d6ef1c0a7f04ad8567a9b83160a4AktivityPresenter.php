<?php
namespace FrontModule;

use Nette\Application\UI\Form;

class AktivityPresenter extends SecurityPresenter
{

	public function renderDefault($edit=false) {
		$this->edit($edit);
	}

	public function renderNejmladsi($edit=false) {
		$this->edit($edit);

		$this->template->items = $this->getContext()->listFacade->getAllItems();

		$this->template->editables = $this->getContext()->contentFacade->getEditablesForPage(2);

	}

	public function renderPredskolni($edit=false) {
		$this->edit($edit);

		$facade = $this->getContext()->textFacade;
		$this->template->text = $facade->getTextById(5);
	}

	public function renderSkolaci($edit=false) {
		$this->edit($edit);

		$facade = $this->getContext()->textFacade;
		$this->template->text = $facade->getTextById(6);
	}

	public function renderStarsi($edit=false) {
		$this->edit($edit);

		$facade = $this->getContext()->textFacade;
		$this->template->text = $facade->getTextById(7);
	}

	public function renderTerapie($edit=false) {
		$this->edit($edit);

		$facade = $this->getContext()->textFacade;
		$this->template->text = $facade->getTextById(8);
	}

	public function renderNovinky($edit=false) {
		$this->edit($edit);

		$facade = $this->getContext()->listFacade;
		$this->template->novinky = $facade->getListItems(2, true);
	}

	public function renderProbehlo($edit=false) {
		$this->edit($edit);


	}


}