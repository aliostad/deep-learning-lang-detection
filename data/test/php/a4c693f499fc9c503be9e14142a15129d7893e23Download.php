<?php
namespace Pm\Crawler;
use Pm\Vo\Repository as RepositoryVO;
class Download{
    private $repository;
    private $folder;
    
    private function __construct(RepositoryVO $repository, $folder){
        $this->repository = $repository;
        $this->folder = $folder;
    }
    
    public static function getInstance(RepositoryVO $repository, $folder){
        return new self($repository, $folder);
    }
    
    public function get(){
        return exec("git clone {$this->repository} {$this->folder}");
    }
}