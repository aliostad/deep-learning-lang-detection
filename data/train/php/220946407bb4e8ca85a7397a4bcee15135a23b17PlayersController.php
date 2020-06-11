<?php

namespace App\Http\Controllers;

use \Illuminate\Http\Request;
use \App\Repositories\Users\IUsersRepository;
use \App\Repositories\Players\IPlayersRepository;

/**
 * Class responsible for the requests
 * Regarding the players.
 */
class PlayersController extends Controller
{
    /**
     * @var IUsersRepository
     */
    protected $usersRepository;

    /**
     * @var IPlayersRepository
     */
    protected $playersRepository;

    /**
     * Constructor.
     *
     * @param IUsersRepository $usersRepository
     * @param IPlayersRepository $playersRepository
     */
    public function __construct(
        IUsersRepository $usersRepository,
        IPlayersRepository $playersRepository
    ) {
        $this->usersRepository = $usersRepository;
        $this->playersRepository = $playersRepository;
    }

    /**
     * Registers a given player.
     *
     * @param Request $request
     *
     * @return Response
     */
    public function registerPlayer(Request $request)
    {
        $data = $request->all();
        $user = $this->usersRepository->addUser(
            $data['email'],
            $data['name'],
            $data['password']
        );
        $player = $this->playersRepository->addPlayer(
            $user,
            $user->name
        );

        return ['player' => $player->toArray()];
    }
}

