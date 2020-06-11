<?php

class Statistics
{

    private $clientData;
    private $facade;

    public function __construct(ClientFacade $facade)
    {
        $this->clientData = new ClientData();
        $this->facade     = $facade;
    }

    public function loadAllClientStats($clientId)
    {
        $allClientDataArray = $this->facade->getAllClientData($clientID);

        $this->clientData->id           = $allClientDataArray[0];
        $this->clientData->address      = $allClientDataArray[1];
        $this->clientData->mostPayedFor = $allClientDataArray[2];
        $this->clientData->userHistory  = $allClientDataArray[3];

    }

}
