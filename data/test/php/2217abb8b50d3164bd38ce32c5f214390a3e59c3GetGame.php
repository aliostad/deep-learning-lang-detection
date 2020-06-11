<?php

namespace Hangman\Services;

use Hangman\Repositories\MongoDB\Word as WordRepository;
use Hangman\Repositories\MongoDB\Game as GameRepository;

class GetGame implements ServiceInterface
{
    private $word_repository;
    private $game_repository;

    public function initialize(WordRepository $word_repository, GameRepository $game_repository)
    {
        $this->word_repository = $word_repository;
        $this->game_repository = $game_repository;
    }

    public function execute(array $get_parameters, array $post_parameters)
    {
        return $this->game_repository->get($get_parameters['game_id']);
    }
}
