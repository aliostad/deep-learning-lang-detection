<?php

namespace TicTacToe\Controller;

use TicTacToe\Service\GameService;
use TicTacToe\Service\GameServiceInterface;
use TicTacToe\Service\IOService;
use TicTacToe\Service\StringService;

class GameController
{
    /**
     * @var GameServiceInterface
     */
    protected $gameService;

    public function __construct()
    {
        $ioService = new IOService(new StringService());
        $this->gameService = new GameService($ioService);
    }

    public function play()
    {
        $this->gameService->play();
    }
}
