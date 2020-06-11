<?php namespace App\Handlers\Commands;

use App\Acme\Modules\Blog\Repositories\Blog\BlogRepositoryInterface;

class CreateBlogPostCommandHandler {

    /**
     * @var
     */
    protected $blogRepository;

    /**
     * @param BlogRepositoryInterface $blogRepository
     */
    function __construct(BlogRepositoryInterface $blogRepository)
    {
        $this->blogRepository = $blogRepository;
    }

    /**
	 * Handle the command.
	 *
	 * @param  CreateBlogPostCommand  $command
	 * @return void
	 */
	public function handle(CreateBlogPostCommand $command)
	{
		dd($command);
	}

}
