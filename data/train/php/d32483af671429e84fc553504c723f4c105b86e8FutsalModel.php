<?php

namespace Futsal\Models;

class FutsalModel extends \Nette\Object
{

    /**
     * @var \Rival\Repository\RivalRepository
     */
    private $RivalRepository;

    /** 
     * @var \Futsal\Repository\TeamRepository
     */
    public $TeamRepository;
    
    /**
     * @var \Futsal\Repository\SeasonRepository
     */
    public $SeasonRepository;

    /**
     * @var \Futsal\Repository\SeasonBindPlayerRepository
     */
    public $SeasonBindPlayerRepository;
    
    /**
     * @var \P\Repository\PlayerRepository
     */
    public $PlayerRepository;
    
    public function __construct(\Futsal\Repository\TeamRepository $teamRepository, \Futsal\Repository\SeasonRepository $seasonRepository, \Futsal\Repository\SeasonBindPlayerRepository $seasonBindPlayerRepository, \Player\Repository\PlayerRepository $playerRepository, \Rival\Repository\RivalRepository $RivalRepository)
    {
        $this->SeasonRepository = $seasonRepository;
        $this->TeamRepository = $teamRepository;
        $this->SeasonBindPlayerRepository = $seasonBindPlayerRepository;
        $this->PlayerRepository = $playerRepository;
        $this->RivalRepository = $RivalRepository;
    }
    
    public function seasonList()
    {
        return $this->SeasonRepository->findAll()->orderBy('name DESC');
    }
    
    /**
     * Return single entity by criteria 
     *
     * @param array $criteria
     * 
     * @return \Futsal\Entity\SeasonEntity
     */
    public function seasonGetBy(array $criteria = [])
    {
        return $this->SeasonRepository->getBy($criteria);
    }
    
    /**
     * Return players list by seasonId
     * 
     * @return array
     */
    public function playerListBySeason($id)
    {
        $bindCollection = $this->SeasonBindPlayerRepository->findBy(['season_id' => $id]);
        $positionArray = [
            'K' => 1,
            'D' => 2,
            'U' => 3,
            'S' => 4
        ];
                
        $data = [];
        
        foreach($bindCollection as $bindEntity)
        {
            $playerEntity = $bindEntity->fetchPlayerEntity();

            $data[$positionArray[$playerEntity->position] . $playerEntity->surname . $playerEntity->firstname] = $playerEntity;
        }
        
        ksort($data);
        
        return $data;
    }
    
    /**
     * Return rival selection for grid
     * 
     * @return \Nette\Database\Table\Selection     
     */
    public function rivalGrid()
    {
        return $this->RivalRepository->getTable();
    }
}
