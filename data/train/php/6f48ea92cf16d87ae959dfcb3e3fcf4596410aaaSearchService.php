<?php
/**
 * Created by JetBrains PhpStorm.
 * User: ukiitan
 * Date: 08/10/13
 * Time: 00:37
 * To change this template use File | Settings | File Templates.
 */
namespace Search\Service;

use Client\Service\ClientService;
use Bow\Service\BowService;

use Collection\Dao\CollectionDao;
use Collection\Model\Collection;
use Collection\Enum\CollectionEnum;

class SearchService
{
    protected $serviceManager;

    public function __construct($serviceManager){
        $this->serviceManager = $serviceManager;
    }

   public function getSearchResult(){
   }

    public function searchClient($query){
        $clients = array();

        if($query){
            /** @var  $clientService ClientService */
            $clientService = $this->serviceManager->get('ClientService');
            $clients = $clientService->search($query);
        }

        return $clients;
    }

    public function searchCollection($query){
        $collections = array();

        if($query){
            /** @var  $collectionService CollectionService */
            $collectionService = $this->serviceManager->get('CollectionService');
            $collections = $collectionService->search($query);
        }

        return $collections;
    }

    public function searchBow($query){
        $bows = array();

        if($query){
            /** @var  $bowService BowService */
            $bowService = $this->serviceManager->get('BowService');
            $bows = $bowService->search($query);
        }

        return $bows;
    }
}