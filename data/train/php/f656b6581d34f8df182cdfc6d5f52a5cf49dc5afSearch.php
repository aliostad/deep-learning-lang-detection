<?php
namespace Pm\Crawler;
use Pm\Vo\Repository;

class Search{
    private $repositoryName;
    private function __construct($repositoryName){
        $this->repositoryName = $repositoryName;
    }
    public function getInstance($repositoryName){
        return new self($repositoryName);
    }
    public function getResults(){
        $results = json_decode(file_get_contents("http://github.com/api/v2/json/repos/search/{$this->repositoryName}?language=php",false, PROXY));
        $repositoryVo = new Repository();
        $repositories = array();
        $results = $results->repositories;
        for($i=0;$i<count($results);$i++){
            $repositoryVoClone = clone $repositoryVo;
            foreach($results[$i] as $key=>$value){
                $repositoryVoClone->$key = $value;
            }
            $repositories[] = $repositoryVoClone;
        }
        return $repositories;
    }
}