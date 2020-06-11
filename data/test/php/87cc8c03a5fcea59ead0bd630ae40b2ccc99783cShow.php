<?php

namespace model;

class Show{
	private $showDateTime;
	private $movie;
	private $showId;
	
	public function __construct(Movie $movie, \DateTime $showDateTime, $showId){
		$this->movie = $movie;
		$this->showDateTime = $showDateTime;
		$this->showId = $showId;
	}
	
	public function getTitle(){
		$ret = $this->movie->getTitle();
		return $ret;
	}
	
	public function getMovieId(){
		$ret = $this->movie->getId();
		return $ret;
	}

	public function getShowId(){
		return $this->showId;	
	}
	
	public function getShowDate(){
		$ret = $this->showDateTime->format("d/m/Y");
		return $ret;
	}
	
	public function getShowTime(){
		$time = $this->showDateTime->format("H:i");
		return $time;
	}
}