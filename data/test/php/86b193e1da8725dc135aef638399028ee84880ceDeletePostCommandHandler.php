<?php namespace Dubaisi\Blogger\Posts;

use Dubaisi\Blogger\Repositories\PostRepository;
use Laracasts\Commander\CommandHandler;

class DeletePostCommandHandler implements CommandHandler  {
    /**
     * @var PostRepository
     */
    private $postRepository;

    /**
     * @param PostRepository $postRepository
     */
    function __construct(PostRepository $postRepository)
    {
        $this->postRepository = $postRepository;
    }


    /**
     * Handle the command.
     *
     * @param $command
     * @return mixed
     */
    public function handle($command)
    {
        $this->postRepository->delete($command->post->id);
    }
}