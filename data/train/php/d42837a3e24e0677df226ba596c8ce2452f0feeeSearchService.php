<?php

namespace ZenDesk\Service;

use ZenDesk\Service\Remote\SearchServiceInterface;

class SearchService extends AbstractService
{
    /**
     * @param $query
     * @return \ZenDesk\Entity\User[]
     */
    public function users($query)
    {
        /** @var SearchServiceInterface $remoteService */
        $remoteService = $this->getRemoteService();
        return $remoteService->users($query);
    }

    /**
     * @param $query
     * @return \ZenDesk\Entity\Ticket[]
     */
    public function tickets($query)
    {
        /** @var SearchServiceInterface $remoteService */
        $remoteService = $this->getRemoteService();
        return $remoteService->tickets($query);
    }
}