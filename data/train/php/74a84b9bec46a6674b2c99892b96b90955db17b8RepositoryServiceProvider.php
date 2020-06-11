<?php namespace PLM\Repository;

use Illuminate\Support\ServiceProvider;

class RepositoryServiceProvider extends ServiceProvider {

	/**
	 * Bind repository interfaces
	 *
	 * @return 	void
	 */
	public function register()
	{
		// Binds the user repository
		$this->app->bind('PLM\Repository\Interfaces\UserRepositoryInterface',
			'PLM\Repository\Eloquent\UserRepository');

		// Binds the news repository
		$this->app->bind('PLM\Repository\Interfaces\NewsRepositoryInterface',
			'PLM\Repository\Eloquent\NewsRepository');

		// Binds the slideshow repository
		$this->app->bind('PLM\Repository\Interfaces\SlideshowRepositoryInterface',
			'PLM\Repository\Eloquent\SlideshowRepository');

		// Binds the event repository
		$this->app->bind('PLM\Repository\Interfaces\EventRepositoryInterface',
			'PLM\Repository\Eloquent\EventRepository');

		// Binds the album repository
		$this->app->bind('PLM\Repository\Interfaces\AlbumRepositoryInterface',
			'PLM\Repository\Eloquent\AlbumRepository');

		// Binds the photo repository
		$this->app->bind('PLM\Repository\Interfaces\AlbumPhotoRepositoryInterface',
			'PLM\Repository\Eloquent\AlbumPhotoRepository');

		// Binds the milestone* repositories
		$this->app->bind('PLM\Repository\Interfaces\MilestoneRepositoryInterface',
			'PLM\Repository\Eloquent\MilestoneRepository');
		$this->app->bind('PLM\Repository\Interfaces\MilestoneEraRepositoryInterface',
			'PLM\Repository\Eloquent\MilestoneEraRepository');
	}
	
}