<?php

namespace Sts\Bundle\AppBundle\Domain;

/**
 * Domain class for tournament entity use cases
 */
class TournamentDomain
{
    protected $tournamentRepository;

    /**
     * construct
     *
     * @param TournamentRepository $tournamentRepository
     */
    public function __construct(TournamentRepository $tournamentRepository)
    {
        $this->tournamentRepository = $tournamentRepository;
    }

    /**
     * create a tournament
     *
     * @param Tournament $tournament
     */
    public function create(Tournament $tournament)
    {
        $this->tournamentRepository->persist($tournament);
        $this->tournamentRepository->flush();
    }
}
