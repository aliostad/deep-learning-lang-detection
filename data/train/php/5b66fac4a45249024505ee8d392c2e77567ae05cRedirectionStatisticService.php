<?php

namespace AnalyticsBundle\Repository\Service;

class RedirectionStatisticService {

    protected $repository;

    public function __construct($repository) {
        $this->repository = $repository;
    }

    public function create($params) {
        
        return $this->repository->create($params);
    }
    
    public function save($redirection) {
    
        return $this->repository->save($redirection);
    }
    
    public function update($entity, $redirection) {
    
        return $this->repository->update($entity, $redirection);
    }
    
    public function findEntity($entityName, $column) {
        return $this->repository->findEntity($entityName, $column);
    }
    
}
