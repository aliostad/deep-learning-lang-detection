<?php
class ServiceController extends Controller
{
   function getTotalRecordCount()
	{
		if (!isset($this->ServiceModelObj))
			$this->loadModel('ServiceModel', 'ServiceModelObj');
		if ($this->ServiceModelObj)
			return $this->ServiceModelObj->getTotalRecordCount();
	}
	function getServiceList($fields,$condition)
	{
		if (!isset($this->ServiceModelObj))
			$this->loadModel('ServiceModel', 'ServiceModelObj');
		if ($this->ServiceModelObj)
			return $this->ServiceModelObj->getServiceList($fields,$condition);
	}
	function deleteServiceDetails($condition)
	{
		if (!isset($this->ServiceModelObj))
			$this->loadModel('ServiceModel', 'ServiceModelObj');
		if ($this->ServiceModelObj)
			return $this->ServiceModelObj->deleteServiceDetails($condition);
	}
	function selectServiceDetails($field,$condition)
	{
		if (!isset($this->ServiceModelObj))
			$this->loadModel('ServiceModel', 'ServiceModelObj');
		if ($this->ServiceModelObj)
			return $this->ServiceModelObj->selectServiceDetails($field,$condition);
	}
	function selectServiceParamsDetails($field,$condition)
	{
		if (!isset($this->ServiceModelObj))
			$this->loadModel('ServiceModel', 'ServiceModelObj');
		if ($this->ServiceModelObj)
			return $this->ServiceModelObj->selectServiceParamsDetails($field,$condition);
	}
	function insertServiceParamsDetails($values)
	{
		if (!isset($this->ServiceModelObj))
			$this->loadModel('ServiceModel', 'ServiceModelObj');
		if ($this->ServiceModelObj)
			return $this->ServiceModelObj->insertServiceParamsDetails($values);
	}
	function deleteServiceParamsDetails($id)
	{
		if (!isset($this->ServiceModelObj))
			$this->loadModel('ServiceModel', 'ServiceModelObj');
		if ($this->ServiceModelObj)
			return $this->ServiceModelObj->deleteServiceParamsDetails($id);
	}
	function insertServiceDetails($values)
	{
		if (!isset($this->ServiceModelObj))
			$this->loadModel('ServiceModel', 'ServiceModelObj');
		if ($this->ServiceModelObj)
			return $this->ServiceModelObj->insertServiceDetails($values);
	}
	function updateServiceDetails($update_string,$condition)
	{
		if (!isset($this->ServiceModelObj))
			$this->loadModel('ServiceModel', 'ServiceModelObj');
		if ($this->ServiceModelObj)
			return $this->ServiceModelObj->updateServiceDetails($update_string,$condition);
	}
}
?>