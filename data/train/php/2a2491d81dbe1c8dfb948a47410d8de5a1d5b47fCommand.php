<?php
namespace CASS\Domain\Bundles\ProfileCommunities\Middleware\Command;

use CASS\Domain\Bundles\Auth\Service\CurrentAccountService;
use CASS\Domain\Bundles\ProfileCommunities\Service\ProfileCommunitiesService;

abstract class Command implements \CASS\Application\Command\Command
{
    /** @var ProfileCommunitiesService */
    protected $profileCommunitiesService;

    /** @var CurrentAccountService */
    protected $currentAccountService;

    public function __construct(
        ProfileCommunitiesService $profileCommunitiesService,
        CurrentAccountService $currentAccountService
    ) {
        $this->profileCommunitiesService = $profileCommunitiesService;
        $this->currentAccountService = $currentAccountService;
    }
}