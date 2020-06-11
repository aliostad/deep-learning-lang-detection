<?php  namespace Giraffe\Events; 
use Giraffe\Authorization\GatekeeperUnauthorizedException;
use Giraffe\Comments\CommentStreamModel;
use Giraffe\Comments\CommentStreamRepository;
use Giraffe\Common\Service;
use Giraffe\Users\UserRepository;

class EventCommentingService extends Service
{

    /**
     * @var EventRepository
     */
    private $eventRepository;
    /**
     * @var UserRepository
     */
    private $userRepository;
    /**
     * @var CommentStreamRepository
     */
    private $commentStreamRepository;

    public function __construct(EventRepository $eventRepository, UserRepository $userRepository, CommentStreamRepository $commentStreamRepository)
    {
        $this->eventRepository = $eventRepository;
        $this->userRepository = $userRepository;
        $this->commentStreamRepository = $commentStreamRepository;
        parent::__construct();
    }

    public function getForEvent($event, $options = [])
    {
        /** @var EventModel $event */
        $event = $this->eventRepository->getByHash($event);
        $comments = $event->getComments($options);

        return $comments;
    }

    public function addComment($event, $body, $user)
    {
        if (!$user) throw new GatekeeperUnauthorizedException;

        /** @var EventModel $event */
        $event = $this->eventRepository->getByHash($event);
        $user = $this->userRepository->getByHash($user);

        $comment = $event->addComment($body, $user);
        return $comment;
    }
} 