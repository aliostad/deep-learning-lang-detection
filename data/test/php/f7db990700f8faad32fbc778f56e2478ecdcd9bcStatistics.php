<?php

class Statistics
{
	private $clientData;
	private $facade;

	function __construct(ClientFacade $facade)
	{
		$this->clientData = new ClientData();
		$this->facade = $facade;
	}

	function loadAllClientStats($clientId)
	{
		$allClientDataArray = $this->facade->getAllClientData($clientId);

		$this->clientData->id = $allClientDataArray[0];
		$this->clientData->address = $allClientDataArray[1];
		$this->clientData->mostPaidFor = $allClientDataArray[2];
		$this->clientData->userHistory = $allClientDataArray[3];
	}
}
