<?php
	include_once("nusoap.php");
	include_once("apiutil.php");

	class DomOrderSetup
	{
		var $serviceObj;
		var $wsdlFileName;
		function DomOrderSetup($wsdlFileName="wsdl/DomOrderSetup.wsdl")
		{
			$this->wsdlFileName = $wsdlFileName;
			$this->serviceObj = new soapclient_nusoap($this->wsdlFileName,"wsdl");
		}
		function getCustomerDefaultParams(
			$SERVICE_USERNAME, $SERVICE_PASSWORD, $SERVICE_ROLE, $SERVICE_LANGPREF, $SERVICE_PARENTID, $customerId, $type)
		{
			$return = $this->serviceObj->call("getCustomerDefaultParams",array($SERVICE_USERNAME, $SERVICE_PASSWORD, $SERVICE_ROLE, $SERVICE_LANGPREF, $SERVICE_PARENTID, $customerId, $type));
			debugfunction($this->serviceObj);
			return $return;
		}
		function getResellerTldsSettingsPref(
			$SERVICE_USERNAME, $SERVICE_PASSWORD, $SERVICE_ROLE, $SERVICE_LANGPREF, $SERVICE_PARENTID)
		{
			$return = $this->serviceObj->call("getResellerTldsSettingsPref",array($SERVICE_USERNAME, $SERVICE_PASSWORD, $SERVICE_ROLE, $SERVICE_LANGPREF, $SERVICE_PARENTID));
			debugfunction($this->serviceObj);
			return $return;
		}
		function listResellerTldsPricingDetails(
			$SERVICE_USERNAME, $SERVICE_PASSWORD, $SERVICE_ROLE, $SERVICE_LANGPREF, $SERVICE_PARENTID, $customerId)
		{
			$return = $this->serviceObj->call("listResellerTldsPricingDetails",array($SERVICE_USERNAME, $SERVICE_PASSWORD, $SERVICE_ROLE, $SERVICE_LANGPREF, $SERVICE_PARENTID, $customerId));
			debugfunction($this->serviceObj);
			return $return;
		}
		function getCustomerCostPrice(
			$SERVICE_USERNAME, $SERVICE_PASSWORD, $SERVICE_ROLE, $SERVICE_LANGPREF, $SERVICE_PARENTID, $customerId)
		{
			$return = $this->serviceObj->call("getCustomerCostPrice",array($SERVICE_USERNAME, $SERVICE_PASSWORD, $SERVICE_ROLE, $SERVICE_LANGPREF, $SERVICE_PARENTID, $customerId));
			debugfunction($this->serviceObj);
			return $return;
		}
		function getResellerCostPrice(
			$SERVICE_USERNAME, $SERVICE_PASSWORD, $SERVICE_ROLE, $SERVICE_LANGPREF, $SERVICE_PARENTID)
		{
			$return = $this->serviceObj->call("getResellerCostPrice",array($SERVICE_USERNAME, $SERVICE_PASSWORD, $SERVICE_ROLE, $SERVICE_LANGPREF, $SERVICE_PARENTID));
			debugfunction($this->serviceObj);
			return $return;
		}
	}
?>