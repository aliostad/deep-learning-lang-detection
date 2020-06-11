<?php

namespace Handler\Payment;

use Broadway\CommandHandling\CommandHandler;
use Broadway\EventSourcing\EventSourcingRepository;
use Command\Payment;
use Entity\PaymentAggregate;

class CancelHandler extends CommandHandler
{
    /** @var EventSourcingRepository */
    private $repository;

    /**
     * CancelHandler constructor.
     *
     * @param EventSourcingRepository $repository
     */
    public function __construct(EventSourcingRepository $repository)
    {
        $this->repository = $repository;
    }

    public function handleCancelCommand(Payment\CancelCommand $command)
    {
        /** @var PaymentAggregate $payment */
        $payment = $this->repository->load($command->getPaymentId());
        $payment->cancel();
        $this->repository->save($payment);
    }
}
