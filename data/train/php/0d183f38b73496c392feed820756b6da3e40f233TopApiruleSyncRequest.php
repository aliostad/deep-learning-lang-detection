<?php
/**
 * TOP API: taobao.top.apirule.sync request
 * 
 * @author auto create
 * @since 1.0, 2011-07-20 16:44:37.0
 */
class TopApiruleSyncRequest
{
	/** 
	 * 已发布的api名称。
	 **/
	private $apiName;
	
	private $apiParas = array();
	
	public function setApiName($apiName)
	{
		$this->apiName = $apiName;
		$this->apiParas["api_name"] = $apiName;
	}

	public function getApiName()
	{
		return $this->apiName;
	}

	public function getApiMethodName()
	{
		return "taobao.top.apirule.sync";
	}
	
	public function getApiParas()
	{
		return $this->apiParas;
	}
}
