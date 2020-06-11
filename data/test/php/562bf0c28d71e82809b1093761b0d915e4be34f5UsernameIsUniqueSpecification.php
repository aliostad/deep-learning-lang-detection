<?php

namespace Domain\Specification;

use Domain\Repository\ConsumerRepositoryInterface;
use Domain\ValueObject\Username;

/**
 * Class UsernameIsUniqueSpecification
 */
final class UsernameIsUniqueSpecification
{
    /**
     * @var ConsumerRepositoryInterface
     */
    private $consumerRepository;

    /**
     * @param ConsumerRepositoryInterface $consumerRepository
     */
    public function __construct(ConsumerRepositoryInterface $consumerRepository)
    {
        $this->consumerRepository = $consumerRepository;
    }

    /**
     * @param Username $username
     *
     * @return bool
     */
    public function isStatisfiedBy(Username $username)
    {
        return $this->consumerRepository->hasConsumerWithUsername($username) === false;
    }
}
