<?php
class SpatialQuery {
	//***************************************************************
	// Set property defaults
	//***************************************************************
	var $__apiAccuracy = '';
	var $__apiFeatureLimit = '';
	var $__apiJoinExpression = '';
	var $__apiJoinTables = '';
	var $__apiSearchOrder = '';
	var $__apiSubFields = '';
	var $__apiWhere = '';
	var $__apiBuffer = '';
	var $__apiFeatureCoordSys = '';
	var $__apiFilterCoordSys = '';
	var $__apiSpatialFilter = '';
	var $__apiRenderer = '';
	
	//***************************************************************
	// Public Methods
	//***************************************************************
	function SetAccuracy($__apiParam) { $this->__apiAccuracy = $__apiParam; }
	function SetFeatureLimit($__apiParam) { $this->__apiFeatureLimit = $__apiParam; }
	function SetJoinExpression($__apiParam) { $this->__apiJoinExpression = $__apiParam; }
	function SetJoinTables($__apiParam) { $this->__apiJoinTables = $__apiParam; }
	function SetSearchOrder($__apiParam) { $this->__apiSearchOrder = $__apiParam; }
	function SetSubFields($__apiParam) { $this->__apiSubFields = $__apiParam; }
	function SetWhere($__apiParam) { $this->__apiWhere = $__apiParam; }
	function SetBuffer($__apiParam) { $this->__apiBuffer = $__apiParam; }
	function SetFeatureCoordSys($__apiParam) { $this->__apiFeatureCoordSys = $__apiParam; }
	function SetFilterCoordSys($__apiParam) { $this->__apiFilterCoordSys = $__apiParam; }
	function SetSpatialFilter($__apiParam) { $this->__apiSpatialFilter = $__apiParam; }
	function SetRenderer($__apiParam) { $this->__apiRenderer = $__apiParam; }
	
	function WriteXML() {
		$__apiProperties = array();
		$__apiProperties['relation'] = CheckProperty($this->__apiRelation);
		$__apiProperties['accuracy'] = CheckProperty($this->__apiAccuracy);
		$__apiProperties['featurelimit'] = CheckProperty($this->__apiFeatureLimit);
		$__apiProperties['joinexpression'] = CheckProperty($this->__apiJoinExpression);
		$__apiProperties['jointables'] = CheckProperty($this->__apiJoinTables);
		$__apiProperties['searchorder'] = CheckProperty($this->__apiSearchOrder);
		$__apiProperties['subfields'] = CheckProperty($this->__apiSubFields);
		$__apiProperties['where'] = CheckProperty($this->__apiWhere);
			
		$__apiXML = '<SPATIALQUERY ';
		
		reset($__apiProperties);
		while ($__apiArrayCell = each($__apiProperties)) {
			if (strlen($__apiArrayCell['value']) > 0) {
				$__apiXML .= $__apiArrayCell['key'] . '="' . $__apiArrayCell['value'] . '" ';
			}
		}
		$__apiXML .= '>';
		
		if ($this->__apiBuffer) {
			$__apiXML .= $this->__apiBuffer->WriteXML();
		}
		if ($this->__apiFeatureCoordSys) {
			$__apiXML .= $this->__apiFeatureCoordSys->WriteXML();
		}
		if ($this->__apiFilterCoordSys) {
			$__apiXML .= $this->__apiFilterCoordSys->WriteXML();
		}
		if ($this->__apiSpatialFilter) {
			$__apiXML .= $this->__apiSpatialFilter->WriteXML();
		}
		if ($this->__apiRenderer) {
			$__apiXML .= $this->__apiRenderer->WriteXML();
		}
		
		$__apiXML .= '</SPATIALQUERY>';
		
		return $__apiXML;
	}
}	
?>