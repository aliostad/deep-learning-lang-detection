<?php
class SpatialFilter {
	//***************************************************************
	// Set property defaults
	//***************************************************************
	var $__apiRelation = '';
	var $__apiChildObject = '';
	var $__apiBuffer = '';
	
	//***************************************************************
	// Constructor
	//***************************************************************
	function SpatialFilter() {
		$numargs = func_num_args();
		$this->__apiRelation = $numargs > 0 ? func_get_arg(0) : $__apiRelation;
		$this->__apiChildObject = $numargs > 1 ? func_get_arg(1) : $__apiChildObject;
	}

	//***************************************************************
	// Public Methods
	//***************************************************************
	function SetRelation($__apiParam) { $this->__apiRelation = $__apiParam; }
	function SetChildObject($__apiParam) { $this->__apiChildObject = $__apiParam; }
	function SetBuffer($__apiParam) { $this->__apiBuffer = $__apiParam; }
	
	function WriteXML() {
		$__apiProperties = array();
		$__apiProperties['relation'] = CheckProperty($this->__apiRelation);
		
		$__apiXML = '<SPATIALFILTER ';
		
		reset($__apiProperties);
		while ($__apiArrayCell = each($__apiProperties)) {
			if (strlen($__apiArrayCell['value']) > 0) {
				$__apiXML .= $__apiArrayCell['key'] . '="' . $__apiArrayCell['value'] . '" ';
			}
		}
		$__apiXML .= '>';
		
		if ($this->__apiChildObject) {
			$__apiXML .= $this->__apiChildObject->WriteXML();
		} else {
			return 'SpatialFilter() does not contain a child object';
		}
		if ($this->__apiBuffer) {
			$__apiXML .= $this->__apiBuffer->WriteXML();
		}
		
		$__apiXML .= '</SPATIALFILTER>';
		
		return $__apiXML;
	}
}	
?>