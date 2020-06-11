<?php

namespace Karma\API;

use \Illuminate\Support\ServiceProvider;

class APIServiceProvider extends ServiceProvider {

    public function register()
    {
        switch(\Session::get('auth'))
        {
            case 'vk':
                \App::bind('Karma\API\InterfaceAPI', 'Karma\API\VkontakteAPI');
                break;
            case 'ok':
                \App::bind('Karma\API\InterfaceAPI', 'Karma\API\OdnoklassnikiAPI');
                break;
            case 'fb':
                \App::bind('Karma\API\InterfaceAPI', 'Karma\API\FacebookAPI');
                break;
        }
    }
}