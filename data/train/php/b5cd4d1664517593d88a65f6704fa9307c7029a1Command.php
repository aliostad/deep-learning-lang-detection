<?php
namespace CASS\Chat\Middleware\Command;

use CASS\Chat\Service\MessageService;
use CASS\Domain\Bundles\Auth\Service\CurrentAccountService;
use CASS\Domain\Bundles\Profile\Service\ProfileService;

abstract class  Command implements \CASS\Application\Command\Command
{

    protected $profileService;
    protected $messageService;
    protected $currentAccountService;

    public function __construct(ProfileService $profileService, MessageService $messageService, CurrentAccountService $currentAccountService)
    {
        $this->profileService = $profileService;
        $this->messageService = $messageService;
        $this->currentAccountService = $currentAccountService;
    }

}