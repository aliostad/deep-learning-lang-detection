<?php

namespace TimeBoard;

use Symfony\Component\HttpFoundation\Response;
use TimeBoard\Repository\TimeBoardRepository;
use TimeBoard\Repository\UserRepository;

/**
 * Class Fixtures
 * @package TimeBoard
 */
class Fixtures
{
    /**
     * @var UserRepository
     */
    private $userRepository;

    /**
     * @var TimeBoardRepository
     */
    private $timeBoardRepository;

    public function __construct(UserRepository $userRepository, TimeBoardRepository $timeBoardRepository)
    {
        $this->userRepository = $userRepository;
        $this->timeBoardRepository = $timeBoardRepository;
    }


    /**
     * @return Response
     */
    public function createStructure()
    {
        $this->userRepository->createStructure();
        $this->timeBoardRepository->createStructure();

        return new Response("DONE");
    }



}