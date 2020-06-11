<?php
/********************************
 * @AUTHOR: Christian Wallervand*
 ********************************/
require_once "Util/DButil.php";	
require_once "Util/GeneralUtil.php";
require_once "Model/Show.php";
class ShowDBC {
	
	/********************************
	 * Query for selecting all shows*
	 ********************************/
	protected $QUERY_SELECT_ALL_SHOWS 	= "SELECT DISTINCT d.defnr, d.name
										   FROM definition d, ondemand o 
										   WHERE o.program = d.defnr 
										   ORDER BY d.name ASC";
	
	/********************************************
	 * Query for selecting a spcified show		*
	 * Retrieves data from the defenitions table*
	 ********************************************/
	protected $QUERY_SELECT_SHOW 		= "SELECT d.defnr, d.name
										   FROM definition d
										   WHERE d.defnr = ?"; 
		
	/****************************************************
	 * Query for selecting show info for a specifed show*
	 * Queries the ondemand table						*
	 ****************************************************/
	/*protected $QUERY_SELECT_SHOW_INFO 	= "SELECT rs.showImgSmall, rs.showInfoShort, rs.showInfoLong
										   FROM RADIO_SHOW rs
										   WHERE rs.showID = ?";*/
	
	//Queries the streamer server
	protected $QUERY_SELECT_SHOW_INFO 	= "SELECT rs.showImgSmall, rs.showInfoShort, rs.showInfoLong, rs.showImgLarge
										   FROM RADIO_SHOW rs
										   WHERE rs.showID = ?";
	
	//Retreives data from ondemand database @ streamer server
	public function selectShowInfo($sID) {
		$con = DButil::connectToFileserver();
		if (DButil::DBconnection($con, DButil::DB_NAME_STREAMER)) {
			if ($stmt = $con->prepare($this->QUERY_SELECT_SHOW_INFO)) {
				$stmt->bind_param("i", $showID);
				$showID = $sID;
				$stmt->execute();
				//$stmt->bind_result($showImg, $showInfoShort, $showInfoLong);
				//$stmt->bind_result($showImgSmall, $showInfoShort, $showInfoLong);
				$stmt->bind_result($showImgSmall, $showInfoShort, $showInfoLong, $showImgLarge); //NEW
			}
			//$list = array();
			if ($stmt->fetch()) {
				$infoShort = GeneralUtil::encode($showInfoShort);
				$infoLong = GeneralUtil::encode($showInfoLong);
				//$show->setImgPath($shoImg);
				$show->setSmallImgPath($showImgSmall);
				$show->setLargeImgPath($showImgLarge); //NEW
				$show->setInfoShort($infoShort);
				$show->setInfoLong($infoLong);
			}
			$con->close();
		}
		
	}
	
	/*********************************************
	 * Select alls shows for the file server*
	 * and streamer server						 *
	 * Used on the main page og SoD				 *
	 *********************************************/
	public function selectAllShows() {
		//global $con;
		//$con = new mysqli(DButil::MYSQL_SERVER, DButil::MYSQL_USER_NAME, DButil::MYSQL_PASSWORD, DButil::DB_NAME);
		$con1 = DButil::connectToFileserver();
		$con2 = DButil::connectToStreamer();
		if (DButil::DBconnection($con1, DButil::DB_NAME_FILESERVER)&& DButil::DBconnection($con2, DButil::DB_NAME_STREAMER)) {		
			
			if ($stmt = $con1->prepare($this->QUERY_SELECT_ALL_SHOWS)) {
				$stmt->execute();
				$stmt->bind_result($defnr, $name);
			}
			
			$list = array();
			while($stmt->fetch()) {
				$name = GeneralUtil::encode($name);
				$show = new Show($defnr, $name);
				
				//Query the streamer server DB
				if ($stmt2 = $con2->prepare($this->QUERY_SELECT_SHOW_INFO)) {
					$stmt2->bind_param("i", $showID);
					$showID = $show->getID();
					$stmt2->execute();
					
					//$stmt2->bind_result($showImg, $showInfoShort, $showInfoLong);
					//$stmt2->bind_result($showImgSmall, $showInfoShort, $showInfoLong);
					$stmt2->bind_result($showImgSmall, $showInfoShort, $showInfoLong, $showImgLarge); //NEW
					
				}
				while ($stmt2->fetch()) {
						
					$infoShort = GeneralUtil::encode($showInfoShort);
					$infoLong = GeneralUtil::encode($showInfoLong);
					//$show->setImgPath($showImg);
					$show->setSmallImgPath($showImgSmall);
					//$show->setLargeImgPath($showImgLarge);
					$show->setInfoShort($infoShort);
					$show->setInfoLong($infoLong);
				}
				//$con2->close();
				array_push($list, $show);
			}
			$con1->close();
			$con2->close();
			//Connect to a new server
			//if (DButil::DBconnection($con2, DButil::DB_NAME_STREAMER)) {
				/*if ($stmt = $con2->prepare($this->QUERY_SELECT_SHOW_INFO)) {
					$stmt->bind_param("i", $showID);
					$showID = $show->getID();
					$stmt->execute();
					$stmt->bind_result($showImg, $showInfoShort, $showInfoLong);
				}
				//$list = array();
				if ($stmt->fetch()) {
					$infoShort = GeneralUtil::encode($showInfoShort);
					$infoLong = GeneralUtil::encode($showInfoLong);
					$show->setImgPath($shoImg);
					$show->setInfoShort($infoShort);
					$show->setInfoLong($infoLong);
					
				}
				$con2->close();*/
			//}
		}
		return $list;
	}
	
	/***************************************************
	 * Queries file and streamer server	        	   *
	 * Used to retrieve information for a spesific show*
	 ***************************************************/
	public function selectShow($sID) {
		$con1 = DButil::connectToFileserver();
		$con2 = DButil::connectToStreamer();
		if (DButil::DBconnection($con1, DButil::DB_NAME_FILESERVER) && DButil::DBconnection($con2, DButil::DB_NAME_STREAMER)) {		
			//Query the file server
			if ($stmt = $con1->prepare($this->QUERY_SELECT_SHOW)) {
				$stmt->bind_param("i", $showID);
				$showID = $sID;
				$stmt->execute();
				$stmt->bind_result($defnr, $name);
			}
			if ($stmt->fetch()) {
				$name = GeneralUtil::encode($name);
				$show = new Show($defnr, $name);
			}
			
			//Query the stremer server DB
			if ($stmt2 = $con2->prepare($this->QUERY_SELECT_SHOW_INFO)) {
				$stmt2->bind_param("i", $showID);
				$showID = $show->getID();
				$stmt2->execute();
				//$stmt2->bind_result($showImg, $showInfoShort, $showInfoLong);
				//$stmt2->bind_result($showImgSmall, $showInfoShort, $showInfoLong);
				$stmt2->bind_result($showImgSmall, $showInfoShort, $showInfoLong, $showImgLarge); //NEW
			}
			//$list = array();
			if ($stmt2->fetch()) {
				$infoShort = GeneralUtil::encode($showInfoShort);
				$infoLong = GeneralUtil::encode($showInfoLong);
				//$show->setImgPath($showImg);
				$show->setSmallImgPath($showImgSmall);
				$show->setLargeImgPath($showImgLarge); //NEW
				$show->setInfoShort($infoShort);
				$show->setInfoLong($infoLong);
			}
			$con1->close();
			$con2->close();
		}
		return $show;
	}
}

?>
