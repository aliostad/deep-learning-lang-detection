<?php
/**
 * @author     Andrey Lis <me@andreylis.ru>
 */

namespace SMSSender\Service;


trait SenderServiceTrait
{

    /**
     * @var SenderService
     */
    protected $senderService;

    /**
     * @param \SMSSender\Service\SenderService $senderService
     */
    public function setSenderService($senderService)
    {
        $this->senderService = $senderService;
    }

    /**
     * @return \SMSSender\Service\SenderService
     */
    public function getSenderService()
    {
        if (!$this->senderService) {
            $this->setSenderService($this->getServiceLocator()->get("SMSSenderService"));
        }
        return $this->senderService;
    }

}