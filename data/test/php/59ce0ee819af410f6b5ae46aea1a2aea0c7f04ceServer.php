<?php
/**
 * @brief API 서버와 통신하기 위한 API 클래스
 */
class ApiServer
{
	protected $api_server; // << API 서버 주소
	protected $api_key; // < API 키

	/**
	 * API 서버 지정
	 */
	function setServer($server_name)
	{
		if(!$server_name)
		{
			return FALSE;
		}

		$this->api_server = $server_name;
	}

	/**
	 * API 키 지정
	 */
	function setApiKey($api_key)
	{
		$this->api_key = $api_key;
	}

	function getServer()
	{
		return $this->api_server;
	}

	function getApiKey()
	{
		return $this->api_key;
	}
}