<?php

use Modules\Games\Api\DeveloperApi;
use Modules\Games\Api\GameApi;
use Modules\Games\Api\GenreApi;
use Modules\Games\Api\ModApi;
use Modules\Games\Api\PatchApi;
use Modules\Games\Api\PostApi;
use Modules\Games\Api\PublisherApi;
use Modules\User\Api\UserApi;

return [
    'games-game' => new GameApi,
    'games-genre' => new GenreApi,
    'games-developer' => new DeveloperApi,
    'games-publisher' => new PublisherApi,
    'games-post' => new PostApi,
    'games-patch' => new PatchApi,
    'games-mod' => new ModApi,

    'users-user' => new UserApi,
];
