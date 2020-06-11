<?php
namespace App\Message\Consumer;

use App\Message\MessageRepository;

class MessageConsumer implements Consumer
{
    /**
     * @var MessageRepository
     */
    public $repository;

    /**
     * @param MessageRepository $repository
     */
    public function __construct(MessageRepository $repository)
    {
        $this->repository = $repository;
    }

    /**
     * Message consume function of Consumer Class
     * @param null $request
     */
    public function consume($request = null)
    {

    }



}