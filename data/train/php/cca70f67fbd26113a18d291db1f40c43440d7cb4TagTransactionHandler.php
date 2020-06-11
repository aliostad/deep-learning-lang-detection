<?php

namespace AppBundle\CommandBus;

use AppBundle\Entity\TagRepository;
use AppBundle\Entity\TransactionRepository;
use SimpleBus\Message\Handler\MessageHandler;
use SimpleBus\Message\Message;

class TagTransactionHandler implements MessageHandler
{
    /**
     * @var TagRepository
     */
    private $tagRepository;

    /**
     * @var TransactionRepository
     */
    private $transactionRepository;

    /**
     * @param TagRepository         $tagRepository
     * @param TransactionRepository $transactionRepository
     */
    public function __construct(TagRepository $tagRepository, TransactionRepository $transactionRepository)
    {
        $this->tagRepository = $tagRepository;
        $this->transactionRepository = $transactionRepository;
    }

    /**
     * {@inheritDoc}
     */
    public function handle(Message $message)
    {
        $tag = $this->tagRepository->findByName($message->tagName);
        $transaction = $this->transactionRepository->findByLabel($message->transactionLabel);
        $transaction->addTag($tag);
        $this->transactionRepository->persist($transaction);
    }
}
