<?php
namespace CASS\Domain\Bundles\Feedback\Middleware\Command;

use CASS\Application\Command\Command as CommandInterface;
use CASS\Domain\Bundles\Auth\Service\CurrentAccountService;
use CASS\Domain\Bundles\Feedback\Service\FeedbackService;

abstract class Command implements CommandInterface
{
    /** @var FeedbackService $feedbackService */
    protected $feedbackService;

    /** @var CurrentAccountService $currentAccountService */
    protected $currentAccountService;

    public function __construct(
        FeedbackService $feedbackService,
        CurrentAccountService $currentAccountService
    ) {
        $this->feedbackService = $feedbackService;
        $this->currentAccountService = $currentAccountService;
    }
}