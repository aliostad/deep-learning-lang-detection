<?php
/**
 * @package OnlinePublisher
 * @subpackage Classes.Part
 */
if (!isset($GLOBALS['basePath'])) {
	header('HTTP/1.1 403 Forbidden');
	exit;
}

Entity::$schema['PersonPart'] = array(
	'table' => 'part_person',
	'properties' => array(
		'align' => array( 'type' => 'string' ),
		'personId' => array( 'type' => 'int', 'column' => 'person_id',
			'relation'=>['class'=>'Person','property'=>'id']
		 ),
		'showFirstName' => array( 'type' => 'boolean', 'column' => 'show_firstname' ),
		'showMiddleName' => array( 'type' => 'boolean', 'column' => 'show_middlename' ),
		'showLastName' => array( 'type' => 'boolean', 'column' => 'show_surname' ),
		'showInitials' => array( 'type' => 'boolean', 'column' => 'show_initials' ),
		'showNickname' => array( 'type' => 'boolean', 'column' => 'show_nickname' ),
		'showJobTitle' => array( 'type' => 'boolean', 'column' => 'show_jobtitle' ),
		'showSex' => array( 'type' => 'boolean', 'column' => 'show_sex' ),
		'showEmailJob' => array( 'type' => 'boolean', 'column' => 'show_email_job' ),
		'showEmailPrivate' => array( 'type' => 'boolean', 'column' => 'show_email_private' ),
		'showPhoneJob' => array( 'type' => 'boolean', 'column' => 'show_phone_job' ),
		'showPhonePrivate' => array( 'type' => 'boolean', 'column' => 'show_phone_private' ),
		'showStreetname' => array( 'type' => 'boolean', 'column' => 'show_streetname' ),
		'showZipcode' => array( 'type' => 'boolean', 'column' => 'show_zipcode' ),
		'showCity' => array( 'type' => 'boolean', 'column' => 'show_city' ),
		'showCountry' => array( 'type' => 'boolean', 'column' => 'show_country' ),
		'showWebAddress' => array( 'type' => 'boolean', 'column' => 'show_webaddress' ),
		'showImage' => array( 'type' => 'boolean', 'column' => 'show_image' )
	)
);

class PersonPart extends Part
{
	var $align;
	var $personId;
	var $showFirstName;
	var $showMiddleName;
	var $showLastName;
	var $showInitials;
	var $showNickname;
	var $showJobTitle;
	var $showSex;
	var $showEmailJob;
	var $showEmailPrivate;
	var $showPhoneJob;
	var $showPhonePrivate;
	var $showStreetname;
	var $showZipcode;
	var $showCity;
	var $showCountry;
	var $showWebAddress;
	var $showImage;
	
	function PersonPart() {
		parent::Part('person');
	}
	
	static function load($id) {
		return Part::get('person',$id);
	}

	function setAlign($align) {
	    $this->align = $align;
	}

	function getAlign() {
	    return $this->align;
	}
	
	function setPersonId($personId) {
	    $this->personId = $personId;
	}

	function getPersonId() {
	    return $this->personId;
	}
	
	function setShowFirstName($showFirstName) {
	    $this->showFirstName = $showFirstName;
	}

	function getShowFirstName() {
	    return $this->showFirstName;
	}
	
	function setShowMiddleName($showMiddleName) {
	    $this->showMiddleName = $showMiddleName;
	}

	function getShowMiddleName() {
	    return $this->showMiddleName;
	}
	
	function setShowLastName($showLastName) {
	    $this->showLastName = $showLastName;
	}

	function getShowLastName() {
	    return $this->showLastName;
	}
	
	function setShowInitials($showInitials) {
	    $this->showInitials = $showInitials;
	}

	function getShowInitials() {
	    return $this->showInitials;
	}
	
	function setShowNickname($showNickname) {
	    $this->showNickname = $showNickname;
	}

	function getShowNickname() {
	    return $this->showNickname;
	}
	
	function setShowJobTitle($showJobTitle) {
	    $this->showJobTitle = $showJobTitle;
	}

	function getShowJobTitle() {
	    return $this->showJobTitle;
	}
	
	function setShowSex($showSex) {
	    $this->showSex = $showSex;
	}

	function getShowSex() {
	    return $this->showSex;
	}
	
	function setShowEmailJob($showEmailJob) {
	    $this->showEmailJob = $showEmailJob;
	}

	function getShowEmailJob() {
	    return $this->showEmailJob;
	}
	
	function setShowEmailPrivate($showEmailPrivate) {
	    $this->showEmailPrivate = $showEmailPrivate;
	}

	function getShowEmailPrivate() {
	    return $this->showEmailPrivate;
	}
	
	function setShowPhoneJob($showPhoneJob) {
	    $this->showPhoneJob = $showPhoneJob;
	}

	function getShowPhoneJob() {
	    return $this->showPhoneJob;
	}
	
	function setShowPhonePrivate($showPhonePrivate) {
	    $this->showPhonePrivate = $showPhonePrivate;
	}

	function getShowPhonePrivate() {
	    return $this->showPhonePrivate;
	}
	
	function setShowStreetname($showStreetname) {
	    $this->showStreetname = $showStreetname;
	}

	function getShowStreetname() {
	    return $this->showStreetname;
	}
	
	function setShowCity($showCity) {
	    $this->showCity = $showCity;
	}

	function getShowCity() {
	    return $this->showCity;
	}
	
	function setShowZipcode($showZipcode) {
	    $this->showZipcode = $showZipcode;
	}

	function getShowZipcode() {
	    return $this->showZipcode;
	}
	
	function setShowCountry($showCountry) {
	    $this->showCountry = $showCountry;
	}

	function getShowCountry() {
	    return $this->showCountry;
	}
	
	function setShowWebAddress($showWebAddress) {
	    $this->showWebAddress = $showWebAddress;
	}

	function getShowWebAddress() {
	    return $this->showWebAddress;
	}
	
	
	function setShowImage($showImage) {
	    $this->showImage = $showImage;
	}

	function getShowImage() {
	    return $this->showImage;
	}
	
}
?>