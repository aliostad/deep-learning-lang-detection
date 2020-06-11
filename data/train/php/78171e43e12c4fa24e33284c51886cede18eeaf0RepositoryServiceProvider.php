<?php
namespace Comet\Providers;

use Illuminate\Support\ServiceProvider;

class RepositoryServiceProvider extends ServiceProvider
{
    private $repos = [
        'Comet\Core\Contracts\Repositories\MatchesRepositoryInterface'        => 'Comet\Core\Match\MatchesRepository',
        'Comet\Core\Team\Contracts\TeamsRepositoryContract'          => 'Comet\Core\Team\TeamsRepository',
        'Comet\Core\Contracts\Repositories\OpponentsRepositoryInterface'      => 'Comet\Core\Opponent\OpponentsRepository',
        'Comet\Core\Contracts\Repositories\GamesRepositoryInterface'          => 'Comet\Core\Game\GamesRepository',
        'Comet\Core\Contracts\Repositories\UsersRepositoryInterface'          => 'Comet\Core\User\UsersRepository',
        'Comet\Core\Contracts\Repositories\RolesRepositoryInterface'          => 'Comet\Core\Role\RolesRepository',
        'Comet\Core\Contracts\Repositories\MapsRepositoryInterface'           => 'Comet\Core\Map\MapsRepository',
        'Comet\Core\Contracts\Repositories\PostsRepositoryInterface'          => 'Comet\Core\Post\PostsRepository',
        'Comet\Core\Contracts\Repositories\PostCategoriesRepositoryInterface' => 'Comet\Core\Post\PostCategoriesRepository',
        'Comet\Core\Contracts\Repositories\CountriesRepositoryInterface'      => 'Comet\Core\Country\CountriesRepository',
    ];

    /**
     * Register the service provider.
     *
     * @return void
     */
    public function register()
    {
        foreach ($this->repos as $contract => $impl) {
            $this->app->bind($contract, $impl);
        }
    }
}
