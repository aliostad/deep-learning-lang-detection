<?php namespace PITG\Repository;

use Sentry;
use User;
use Post;
use Thread;
use Hit;
use Illuminate\Support\ServiceProvider;
use PITG\Repository\Hit\EloquentHitRepository;
use PITG\Repository\User\EloquentUserRepository;
use PITG\Repository\Profile\EloquentProfileRepository;
use PITG\Repository\Category\EloquentCategoryRepository;
use PITG\Repository\Thread\EloquentThreadRepository;
use PITG\Repository\Post\EloquentPostRepository;
use PITG\Repository\Message\EloquentMessageRepository;

class RepositoryServiceProvider extends ServiceProvider {

	/**
	 * Register the repositories
	 *
	 * @return 	void
	 */
	public function register()
	{
		$app = $this->app;

		/* Users */
		$app->bind('PITG\Repository\User\UserRepositoryInterface', function() {
			return new EloquentUserRepository(new Sentry);
		});

		/* Thread */
		$app->bind('PITG\Repository\Thread\ThreadRepositoryInterface', function($app) {
			return new EloquentThreadRepository(
				new Thread,
				$app->make('PITG\Repository\Hit\HitRepositoryInterface')
			);
		});

		/* Post */
		$app->bind('PITG\Repository\Post\PostRepositoryInterface', function() {
			return new EloquentPostRepository(new Post);
		});

		/* Message */
		$app->bind('PITG\Repository\Message\MessageRepositoryInterface', function() {
			return new EloquentMessageRepository(new Message);
		});

		/* Category */
		$app->bind('PITG\Repository\Category\CategoryRepositoryInterface', function() {
			return new EloquentCategoryRepository(new Category);
		});

		/* Hit */
		$app->bind('PITG\Repository\Hit\HitRepositoryInterface', function($app) {
			return new EloquentHitRepository(
				new Hit,
				$app->make('PITG\Repository\User\UserRepositoryInterface')
			);
		});
	}
}