<?php


namespace Nam\Facade;


class Statistics
{
    private $clientData;
    private $facade;

    public function __construct(ClientFacade $facade)
    {
        $this->clientData = new ClientData;
        $this->facade     = $facade;
    }

    public function loadAllClientStats($clientId)
    {
        $clientData                     = $this->facade->getAllClientData($clientId);
        $this->clientData->id           = $clientData[0];
        $this->clientData->address      = $clientData[1];
        $this->clientData->mostPayedFor = $clientData[2];
        $this->clientData->userHistory  = $clientData[3];
    }
} 