<?php

namespace ZenDesk\Service\Feature;

use Zend\Stdlib\Exception\LogicException;

use ZenDesk\Service\TicketService;

trait TicketServiceAwareTrait
{
    /**
     * @var TicketService
     */
    protected $ticketService;

    /**
     * @param TicketService $ticketService
     */
    public function setTicketService(TicketService $ticketService)
    {
        $this->ticketService = $ticketService;
    }

    /**
     * @return TicketService
     * @throws \Zend\Stdlib\Exception\LogicException
     */
    public function getTicketService()
    {
        if (null === $this->ticketService) {
            throw new LogicException('Ticket service must be defined');
        }

        return $this->ticketService;
    }
}
