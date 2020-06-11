<?php

include_once 'ApiClients/PageApi.php';
include_once 'ApiClients/AccountApi.php';
include_once 'ApiClients/CharityApi.php';
include_once 'ApiClients/DonationApi.php';
include_once 'ApiClients/SearchApi.php';
include_once 'ApiClients/EventApi.php';
include_once 'ApiClients/TeamApi.php';
include_once 'ApiClients/CountriesApi.php';
include_once 'ApiClients/CurrencyApi.php';
include_once 'ApiClients/OneSearchApi.php';
include_once 'ApiClients/ProjectApi.php';
include_once 'ApiClients/SmsApi.php';
include_once 'ApiClients/LeaderboardApi.php';
include_once 'ApiClients/CampaignApi.php';

class JustGivingClient
{	
	public $ApiKey;
	public $ApiVersion;
	public $Username;
	public $Password;
	public $RootDomain;
	
	public $Page;
	public $Account;
	public $Charity;
	public $Donation;
	public $Search;
	public $Event;
	public $Team;
	public $Countries;
	public $Currency;
	public $OneSearch;
	public $Project;
	public $Sms;
	public $Leaderboard;
	public $Campaign;

	public function __construct($rootDomain, $apiKey, $apiVersion, $username="", $password="")
	{
		$this->RootDomain   	= (string) $rootDomain; 
		$this->ApiKey     		= (string) $apiKey;
		$this->ApiVersion     	= (string) $apiVersion;
		$this->Username     	= (string) $username;
		$this->Password     	= (string) $password;
		$this->curlWrapper		= new CurlWrapper();
		$this->debug			= false;
		
		// Init API clients
		$this->Page				= new PageApi($this);
		$this->Account			= new AccountApi($this);
		$this->Charity			= new CharityApi($this);
		$this->Donation			= new DonationApi($this);
		$this->Search			= new SearchApi($this);
		$this->Event			= new EventApi($this);
		$this->Team			    = new TeamApi($this);
		$this->Countries 		= new CountriesApi($this);
		$this->Currency 		= new CurrencyApi($this);
		$this->OneSearch 		= new OneSearchApi($this);
		$this->Project 			= new ProjectApi($this);
		$this->Sms 				= new SmsApi($this);
		$this->Leaderboard 		= new LeaderboardApi($this);
		$this->Campaign 		= new CampaignApi($this);
	}
}