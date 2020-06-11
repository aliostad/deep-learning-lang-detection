<?php

namespace Spliced\Bundle\MediaManagerBundle\Model;

class Repository{
	
	protected $repository;
	
	public function __construct(array $repository){
		$this->repository = $repository;
	}
	
	public function __toString(){
		return $this->getName();
	}
	
	public function getPath(){
		return $this->repository['path'];
	}
	
	public function getName(){
		return $this->repository['name'];
	}
	
	public function getWebPath(){
		return $this->repository['web_path'];
	}
	public function getType(){
		return $this->repository['type'];
	}

}
	