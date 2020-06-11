<?php

namespace ZenDesk\Service;

use ZenDesk\Service\Remote\AgentServiceInterface;

class AgentService extends UserService
{
    /**
     * @param $query
     * @return \ZenDesk\Entity\User[]
     */
    public function search($query)
    {
        /** @var AgentServiceInterface $remoteService */
        $remoteService = $this->getRemoteService();
        /** @var \ZenDesk\Entity\User[] $agents */
        return $remoteService->search($query);
    }

    /**
     * @param $name
     * @return \ZenDesk\Entity\User[]
     */
    public function autocomplete($name)
    {
        /** @var AgentServiceInterface $remoteService */
        $remoteService = $this->getRemoteService();
        return $remoteService->autocomplete($name);
    }
}