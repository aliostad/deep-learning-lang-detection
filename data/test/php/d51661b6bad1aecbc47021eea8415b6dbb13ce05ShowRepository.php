<?php

namespace model;

require_once("./src/model/Repository.php");
require_once("./src/model/ShowList.php");

class ShowRepository extends base\Repository{
	private $shows;
	
	private static $showDate = "sDate";
	private static $showTime = "sTime";
	private static $showKey = "uniqueShow";
	private static $movieTitle = "title";
	private static $movieDescription = "description";
	private static $movieKey = "uniqueKey";
	private static $movieShowView = "movie_shows";
	private static $showTable = "CinShows";
	private static $showMovieKey = "movieKeyFK";
	
	public function __construct(){
		$this->dbTable = self::$movieShowView;
	}
	
	// return a ShowList object which consists of an array of Shows where every Show contains a DateTime, showId and Movie object
	public function getShowsByDateList($showDate){
		
		try{
			$db = $this->connection();
			
			$sql = "SELECT * FROM $this->dbTable WHERE " . self::$showDate . " = ? ORDER BY " . self::$showTime;
			$params = array($showDate);
					
			$query = $db->prepare($sql);
			
			$query->execute($params);
			
			$result = $query->fetchAll();
			
			$showList = new ShowList();
			
			if($result){
	
				foreach ($result as $dbShow) {
										
					$movie = new Movie($dbShow[self::$movieTitle], $dbShow[self::$movieKey], $dbShow[self::$movieDescription]);
					
					$sDateTime = new \DateTime($dbShow[self::$showDate] . $dbShow[self::$showTime]);
					
					$show = new Show($movie, $sDateTime, $dbShow[self::$showKey]);

					$showList->addShow($show);
				}
				
				return $showList;
				
			} else {
				return $showList;
			}
		} catch(PDOException $e){
		
		}
	}
	
	// get all shows belonging to specific movie
	public function getShowsByMovieIdList($id, $isAdmin){
		try{
			$db = $this->connection();
		
			if($isAdmin){
				$sql = "SELECT * FROM $this->dbTable WHERE " . self::$movieKey . " = ? ORDER BY " . self::$showDate;
			} else {
				$sql = "SELECT * FROM $this->dbTable WHERE " . self::$movieKey . " = ? AND " . self::$showDate . " >= CURDATE() ORDER BY " . self::$showDate;
			}
			
			$params = array($id);
					
			$query = $db->prepare($sql);
			
			$query->execute($params);
			
			$result = $query->fetchAll();
			
			$showList = new ShowList();
			
			if($result){
	
				foreach ($result as $dbShow) {
					
					$movie = new Movie($dbShow[self::$movieTitle], $dbShow[self::$movieKey], $dbShow[self::$movieDescription]);
					
					$sDateTime = new \DateTime($dbShow[self::$showDate] . $dbShow[self::$showTime]);
					
					$show = new Show($movie, $sDateTime, $dbShow[self::$showKey]);

					$showList->addShow($show);
				}
				
				return $showList;
				
			} else {
				return $showList;
			}
		} catch(PDOException $e){
			
		}
	}
	
	// get a specific show by Id
	public function getShowById($showId){
		$db = $this->connection();
		
		$sql = "SELECT * FROM $this->dbTable WHERE " . self::$showKey . " = ?";
		$params = array($showId);
		
		$query = $db->prepare($sql);
		$query->execute($params);
	
		$result = $query->fetch();

		if($result){
			$movie = new Movie($result[self::$movieTitle], $result[self::$movieKey], $result[self::$movieDescription]);
			$sDateTime = new \DateTime($result[self::$showDate] . $result[self::$showTime]);
			$show = new Show($movie, $sDateTime, $result[self::$showKey]);
			return $show;
		} else {
			return null;
		}
	}
	
	// add new Show to db
	public function doAddShow($showDate, $showTime, $showMovieId){
	
		$db = $this->connection();
		
		$sql = "INSERT INTO " . self::$showTable . "(" . self::$showDate . ", " . self::$showTime . ", " . self::$showMovieKey . ") VALUES (?, ?, ?)";
		$params = array($showDate, $showTime, $showMovieId);
		
		$query = $db->prepare($sql);
		$result = $query->execute($params);
		
		if($result){
			return $db->lastInsertId();
		} else {
			return false;
		}
		
	}
}
