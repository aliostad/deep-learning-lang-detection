<?php
namespace Season\Schedule;

use Season\Entity\Match;
use Season\Services\RepositoryService;
use Season\Entity\MatchDay;
use Season\Entity\League;

/**
 * Class SeasonRepositoryBase
 *
 * @package Season\Schedule
 */
class SeasonRepositoryBase
{
    private $repositoryService;
    private $seasonMapper;
    private $leagueMapper;

    /**
     * @param RepositoryService $repositoryService
     */
    public function __construct(RepositoryService $repositoryService)
    {
        $this->repositoryService = $repositoryService;
    }

    /**
     * @param RepositoryService $repositoryService
     */
    public function setRepositoryService(RepositoryService $repositoryService)
    {
        $this->repositoryService = $repositoryService;
    }

    /**
     * @return \Season\Services\RepositoryService
     */
    public function getRepositoryService()
    {
        return $this->repositoryService;
    }

    /**
     * @return \Season\Mapper\LeagueMapper
     */
    public function getLeagueMapper()
    {
        if (is_null($this->leagueMapper)) {
            $this->leagueMapper = $this->getRepositoryService()->getMapper(RepositoryService::LEAGUE_MAPPER);
        }
        return $this->leagueMapper ;
    }

    /**
     * @return \Season\Mapper\SeasonMapper
     */
    public function getSeasonMapper()
    {
        if (is_null($this->seasonMapper)) {
            $this->seasonMapper = $this->getRepositoryService()->getMapper(RepositoryService::SEASON_MAPPER);
        }
        return $this->seasonMapper ;
    }

}
