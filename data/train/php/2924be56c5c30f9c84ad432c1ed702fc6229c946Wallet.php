<?php

namespace Mealz\AccountingBundle\Service;

use Mealz\AccountingBundle\Entity\TransactionRepository;
use Mealz\MealBundle\Entity\ParticipantRepository;
use Mealz\UserBundle\Entity\Profile;

class Wallet
{
    /**
     * @var ParticipantRepository
     */
    protected $participantRepository;

    /**
     * @var TransactionRepository
     */
    protected $transactionRepository;

    public function __construct(ParticipantRepository $participantRepository, TransactionRepository $transactionRepository)
    {
        $this->participantRepository = $participantRepository;
        $this->transactionRepository = $transactionRepository;
    }

    /**
     * @param Profile $profile
     * @return float
     */
    public function getBalance(Profile $profile)
    {
        $costs = $this->participantRepository->getTotalCost($profile);
        $transactions = $this->transactionRepository->getTotalAmount($profile);

        return bcsub($transactions, $costs, 4);
    }
}