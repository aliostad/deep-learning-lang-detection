<?php

namespace Moderator;

use Moderator\Service\ServiceInterface;

class Moderator
{
    protected $moderationService;

    public function checkContent(Content $content) {
        if($this->moderationService === null) {
            throw new \Exception('you must set a moderation service');
        }

        return $this->moderationService->checkContent($content);
    }

    /**
     * Get moderationService.
     *
     * @return ServiceInterface
     */
    public function getModerationService()
    {
        return $this->moderationService;
    }

    /**
     * Set moderationService.
     *
     * @param ServiceInterface $moderationService
     */
    public function setModerationService(ServiceInterface $moderationService)
    {
        $this->moderationService = $moderationService;
    }
}
