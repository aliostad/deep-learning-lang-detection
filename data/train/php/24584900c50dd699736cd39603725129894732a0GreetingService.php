<?php

namespace Helloworld\Service;

class GreetingService
{
	private $loggingService;

	public function getGreeting()
	{
		//$this->loggingService->log('getGreeting abc!');

		if(date('H') <= 11)
			return '早上好！';
		else if(date('H' > 11 && date('H') < 17))
			return '好呀！';
		else
			return '晚上好！';
	}

	public function setLoggingService(LoggingServiceInterface $loggingService)
	{
		return $this->loggingService = $loggingService;
	}

	public function getLoggingService()
	{
		return $this->loggingService;
	}
}

