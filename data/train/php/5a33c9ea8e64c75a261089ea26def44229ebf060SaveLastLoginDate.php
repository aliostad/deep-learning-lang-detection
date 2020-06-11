<?php namespace Maatwebsite\Usher\Domain\Users\Events\Handlers;

use Maatwebsite\Usher\Contracts\Users\User;
use Maatwebsite\Usher\Contracts\Users\UserRepository;
use Maatwebsite\Usher\Domain\Users\Embeddables\LastLoginAt;

class SaveLastLoginDate
{

    /**
     * @var UserRepository
     */
    protected $repository;

    /**
     * @param UserRepository $repository
     */
    public function __construct(UserRepository $repository)
    {
        $this->repository = $repository;
    }

    /**
     * Handle
     * @param User $user
     */
    public function handle(User $user)
    {
        // Set last attempt timestamp
        $user->setLastLoginAt(
            new LastLoginAt()
        );

        $this->repository->persist($user);
        $this->repository->flush();
    }
}
