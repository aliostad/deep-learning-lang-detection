<?php
use fitshelf\DoFixture;

/*
 * @author Rick Mugridge 6/10/2004
 * Copyright (c) 2004 Rick Mugridge, University of Auckland, NZ
 * Released under the terms of the GNU General Public License version 2 or later.
 * Ported to PHP by MetaClass, www.metaclass.nl
 */

class UserFixture extends DoFixture { //COPY:ALL
	/** @var ChatRoom $chat */
	private $chat; //COPY:ALL
	/** @var User $user; */
	private $user; //COPY:ALL
	 //COPY:ALL
	 
	/**
	 * @param ChatRoom $chat
	 * @param User $user */
	public function __construct(chat\ChatRoom $chat=null, chat\User $user=null) { //COPY:ALL
		$this->chat = $chat; //COPY:ALL
		$this->user = $user; //COPY:ALL
	} //COPY:ALL
	
	/** @param String $roomName 
	* @return boolean */
	public function createsRoom($roomName) { //COPY:ALL
		$this->chat->createRoom($roomName,$this->user); //COPY:ALL
		return true; //COPY:ALL
	} //COPY:ALL
	
	/** @param String $roomName 
	* @return boolean */
	public function entersRoom($roomName) { //COPY:ALL
		return $this->chat->userEntersRoom($this->user->getName(),$roomName); //COPY:ALL
	} //COPY:ALL
} //COPY:ALL

?>