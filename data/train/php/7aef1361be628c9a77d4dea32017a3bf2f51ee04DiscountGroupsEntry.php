<?php

use fitshelf\ColumnFixture;

/*
 * @author Rick Mugridge 24/12/2003
 *
 * Copyright (c) 2003 Rick Mugridge, University of Auckland, NZ
 * Released under the terms of the GNU General Public License version 2 or later.
 * Ported to PHP by MetaClass, www.metaclass.nl
 */

/**
  *
*/
class DiscountGroupsEntry extends ColumnFixture { //COPY:ALL
	/** @var double */
	public $maxBalance, $minPurchase; //COPY:ALL
	/** @var String */
	public $futureValue, $description = ""; //COPY:ALL
	/** @var double */
	public $discountPercent; //COPY:ALL
	//COPY:ALL
	
	//moved to function getApp: private static DiscountApplication APP; //COPY:ALL
	
	//COPY:ALL
	/** @return boolean */
	public function add() { //COPY:ALL
		$this->getApp()->addDiscountGroup($this->futureValue,$this->maxBalance, //COPY:ALL
		                     $this->minPurchase,$this->discountPercent); //COPY:ALL
		return true; //COPY:ALL
	} //COPY:ALL
	/** @return DiscountApplication */
	public static function getApp() { //COPY:ALL
		static $APP;
		if ($APP == null) //COPY:ALL
			$APP = new DiscountApplication(); //COPY:ALL
		return $APP; //COPY:ALL
	} //COPY:ALL
} //COPY:ALL
?>