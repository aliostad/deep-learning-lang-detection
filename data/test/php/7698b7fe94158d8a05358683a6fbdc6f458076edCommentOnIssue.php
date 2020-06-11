<?php

namespace Qissues\Domain\Service;

use Qissues\Domain\Model\Request\NewComment;
use Qissues\Domain\Model\IssueRepository;

class CommentOnIssue
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
     * Posts a comment to an issue
     *
     * @param Message $comment
     * @param Number $issue
     */
    public function __invoke(NewComment $comment)
    {
        $this->repository->comment(
            $comment->getIssue(),
            $comment->getMessage()
        );
    }
}
