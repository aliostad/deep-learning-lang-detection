<?php

namespace Qissues\Domain\Service;

use Qissues\Domain\Model\Number;
use Qissues\Domain\Model\IssueRepository;

class LookupIssue
{
    protected $repository;

    /**
     * @param IssueRepository $repository
     */
    public function __construct(IssueRepository $repository)
    {
        $this->repository = $repository;
    }

    /**
     * Lookup an Issue by its Number
     *
     * @param Number $issue
     * @return Issue
     */
    public function __invoke(Number $issue)
    {
        return $this->repository->lookup($issue);
    }
}
