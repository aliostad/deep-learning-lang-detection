<?php

namespace App\Listeners\Model\Facade;

use App\Model\Facade\PohodaFacade;
use Kdyby\Events\Subscriber;
use Nette\Object;

class PohodaListener extends Object implements Subscriber
{

	/** @var PohodaFacade @inject */
	public $pohodaFacade;

	public function getSubscribedEvents()
	{
		return [
			'App\Model\Facade\PohodaFacade::onStartParseXml' => 'onStartParseXml',
		];
	}

	public function onStartParseXml($type)
	{
		$this->pohodaFacade->setLastSync($type, PohodaFacade::LAST_UPDATE);
		$this->pohodaFacade->setLastSync(PohodaFacade::ANY_IMPORT, PohodaFacade::LAST_UPDATE);
	}

}
