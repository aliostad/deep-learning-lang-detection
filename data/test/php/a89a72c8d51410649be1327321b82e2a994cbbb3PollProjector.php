<?php

namespace Pollo\Core\ReadModel\Projector;

use Pollo\Core\Domain\Model\Poll\Event\PollCreatedEvent;
use Pollo\Core\ReadModel\Model\Poll;
use Broadway\ReadModel\RepositoryInterface;

final class PollProjector extends Projector
{
    /** @var RepositoryInterface $repository */
    private $repository;

    /**
     * @param RepositoryInterface $repository
     */
    public function __construct(RepositoryInterface $repository)
    {
        $this->repository = $repository;
    }

    public function applyPollCreatedEvent(PollCreatedEvent $event)
    {
        $poll = new Poll(
            (string) $event->getPollId(),
            $event->getTitle()
        );

        $this->repository->save($poll);
    }
}
