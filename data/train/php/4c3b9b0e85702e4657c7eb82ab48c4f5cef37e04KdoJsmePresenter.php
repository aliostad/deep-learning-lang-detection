<?php
namespace FrontModule;

use Nette\Application\UI\Form;

class KdoJsmePresenter extends SecurityPresenter
{
	
	public function renderDefault($edit=false) {
		$this->edit($edit);
	}

	public function renderKontakty($edit=false) {
		$this->edit($edit);

		$facade = $this->getContext()->textFacade;
		$this->template->text = $facade->getTextById(13);
	}

	public function renderLide($edit=false) {
		$this->edit($edit);

		$facade = $this->getContext()->textFacade;
		$this->template->text = $facade->getTextById(14);
	}

	public function renderONas($edit=false) {
		$this->edit($edit);

		$facade = $this->getContext()->textFacade;
		$this->template->text = $facade->getTextById(17);
	}

	public function renderSpolek($edit=false) {
		$this->edit($edit);

		$facade = $this->getContext()->textFacade;
		$this->template->text = $facade->getTextById(15);
	}

	public function renderMisto($edit=false) {
		$this->edit($edit);

		$facade = $this->getContext()->textFacade;
		$this->template->text = $facade->getTextById(16);
	}

}
