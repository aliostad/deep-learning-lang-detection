<?php

namespace App\Providers;

use App\Contracts\AgentRepositoryInterface;
use App\Contracts\ContactTypeRepositoryInterface;
use App\Contracts\CountryRepositoryInterface;
use App\Contracts\CurrencyRepositoryInterface;
use App\Contracts\OfferRepositoryInterface;
use App\Contracts\OwnershipStatusRepositoryInterface;
use App\Contracts\StateRepositoryInterface;
use App\Contracts\SubcategoryRepositoryInterface;
use App\Contracts\UserRepositoryInterface;
use App\Contracts\CategoryRepositoryInterface;
use App\Repositories\CurrencyRepository;
use Illuminate\Support\ServiceProvider;

class RepositoryServiceProvider extends ServiceProvider
{
    /**
     * Indicates if loading of the provider is deferred.
     *
     * @var bool
     */
    protected $defer = true;

    /**
     * Register the application services.
     *
     * @return void
     */
    public function register()
    {
        $this->app->singleton(CurrencyRepositoryInterface::class, function ($app) {
            return new CurrencyRepository(new Client());
        });
        $this->app->bind(UserRepositoryInterface::class, 'App\Repositories\UserRepository');
        $this->app->bind(CategoryRepositoryInterface::class, 'App\Repositories\CategoryRepository');
        $this->app->bind(SubcategoryRepositoryInterface::class, 'App\Repositories\SubcategoryRepository');
        $this->app->bind(AgentRepositoryInterface::class, 'App\Repositories\AgentRepository');
        $this->app->bind(CountryRepositoryInterface::class, 'App\Repositories\CountryRepository');
        $this->app->bind(StateRepositoryInterface::class, 'App\Repositories\StateRepository');
        $this->app->bind(OwnershipStatusRepositoryInterface::class, 'App\Repositories\OwnershipStatusRepository');
        $this->app->bind(OfferRepositoryInterface::class, 'App\Repositories\OfferRepository');
        $this->app->bind(ContactTypeRepositoryInterface::class, 'App\Repositories\ContactTypeRepository');
    }

    /**
     * Get the services provided by the provider.
     *
     * @return array
     */
    public function provides()
    {
        return [
            UserRepositoryInterface::class,
            CurrencyRepositoryInterface::class,
            CategoryRepositoryInterface::class,
            OfferRepositoryInterface::class,
        ];
    }
}
