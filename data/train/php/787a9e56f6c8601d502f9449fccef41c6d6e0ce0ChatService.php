<?php

namespace App\Services;

use App\Repositories\Contracts\CommentRepositoryInterface;
use App\Repositories\Contracts\UserRepositoryInterface;
use App\Services\Interfaces\ChatServiceInterface;

class ChatService implements ChatServiceInterface
{
    private $userRepository;
    private $commentRepository;

    public function __construct(
        UserRepositoryInterface $userRepository,
        CommentRepositoryInterface $commentRepository
    ) {
        $this->userRepository = $userRepository;
        $this->commentRepository = $commentRepository;
    }

    public function getAllCommentsByRequest($rid)
    {
        return $this->commentRepository->findByField('review_request_id', $rid);
    }


    public function addComment($data, $rid)
    {
        return $this->commentRepository->addCommentToRequest($data, $rid);
    }
}