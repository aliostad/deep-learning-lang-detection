<?php

namespace App\Http\View\Composers;

use Illuminate\View\View;
use App\Repositories\SettingsRepository;

class SettingsComposer
{
    /**
     * The settings repository implementation.
     *
     * @var SettingsRepository
     */
    protected $settingsRepository;

    /**
     * Create a new profile composer.
     *
     * @param  SettingsRepository  $settingsRepository
     * @return void
     */
    public function __construct(SettingsRepository $settingsRepository)
    {
        // Dependencies automatically resolved by service container...
         $this->settingsRepository = $settingsRepository;
    }

    /**
     * Bind data to the view.
     *
     * @param  View  $view
     * @return void
     */
    public function compose(View $view)
    {
        $settings = $this->settingsRepository->get();

        $data = compact('settings');

        $view->with($data);
    }
}
