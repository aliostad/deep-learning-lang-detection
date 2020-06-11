<?php
class Buffer {
	//***************************************************************
	// Set property defaults
	//***************************************************************
	var $__apiDistance = '';
	var $__apiBufferUnits = '';
	var $__apiProject = '';
	var $__apiSpatialQuery = '';
	var $__apiTargetLayer = '';
	var $__apiParentElement = '';
	
	//***************************************************************
	// Constructor
	//***************************************************************
	function Buffer() {
		$numargs = func_num_args();
		$this->__apiDistance = $numargs > 0 ? func_get_arg(0) : $__apiDistance;
	}

	//***************************************************************
	// Public Methods
	//***************************************************************
	function SetDistance($__apiParam) { $this->__apiDistance = $__apiParam; }
	function SetBufferUnits($__apiParam) { $this->__apiBufferUnits = $__apiParam; }
	function SetProject($__apiParam) { $this->__apiProject = $__apiParam; }
	function SetSpatialQuery($__apiParam) { $this->__apiSpatialQuery = $__apiParam; }
	function SetTargetLayer($__apiParam) { $this->__apiTargetLayer = $__apiParam; }
	function SetParentElement($__apiParam) { $this->__apiParentElement = $__apiParam; }
	
	function WriteXML() {
		$__apiProperties = array();
		$__apiProperties['distance'] = CheckProperty($this->__apiDistance);
		$__apiProperties['bufferunits'] = CheckProperty($this->__apiBufferUnits);
		$__apiProperties['project'] = CheckProperty($this->__apiProject);
		
		$__apiXML = '<BUFFER ';
		
		reset($__apiProperties);
		while ($__apiArrayCell = each($__apiProperties)) {
			if (strlen($__apiArrayCell['value']) > 0) {
				$__apiXML .= $__apiArrayCell['key'] . '="' . $__apiArrayCell['value'] . '" ';
			}
		}
		$__apiXML .= '>';
		
		if (strtoupper($this->__apiParentElement) == 'SPATIALQUERY') {
			if ($this->__apiSpatialQuery) {
				$__apiXML .= $this->__apiSpatialQuery->WriteXML();
			}
			if ($this->__apiTargetLayer) {
				$__apiXML .= $this->__apiTargetLayer->WriteXML();
			}
		}
		
		$__apiXML .= '</BUFFER>';
		
		return $__apiXML;
	}
}	
?>