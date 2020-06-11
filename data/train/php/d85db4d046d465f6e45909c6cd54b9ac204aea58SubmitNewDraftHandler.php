<?php namespace App\Communications\Handlers;

use App\Accounts\Repositories\UserRepository;
use App\Communications\Draft;
use App\Communications\Repositories\AuthorRepository;
use App\Communications\Repositories\DraftRepository;
use Laracasts\Commander\CommandHandler;

class SubmitNewDraftHandler implements CommandHandler
{

    /**
     * @var DraftRepository
     */
    private $draftRepository;
    /**
     * @var AuthorRepository
     */
    private $authorRepository;
    /**
     * @var UserRepository
     */
    private $userRepository;

    /**
     * @param DraftRepository $draftRepository
     * @param AuthorRepository $authorRepository
     * @param UserRepository $userRepository
     */
    public function __construct(DraftRepository $draftRepository, AuthorRepository $authorRepository, UserRepository $userRepository)
    {
        $this->draftRepository = $draftRepository;
        $this->authorRepository = $authorRepository;
        $this->userRepository = $userRepository;
    }

    /**
     * Handle the command.
     *
     * @param $command
     * @return mixed
     */
    public function handle($command)
    {
        // faking this for now - normally you'd get your authenticated user
        $user = $this->userRepository->getByEmail($command->email);

        $author = $this->authorRepository->fromUser($user);
        $draft = Draft::write($author, $command->title, $command->content);

        $this->draftRepository->save($draft);
    }
}