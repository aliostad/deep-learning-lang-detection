<?php
class DataSet {
	//***************************************************************
	// Set property defaults
	//***************************************************************
	var $__apiName = '';
	var $__apiType = '';
	var $__apiWorkspace = '';
	var $__apiFromLayer = '';

	//***************************************************************
	// Public Methods
	//***************************************************************
	function SetName($__apiParam) { $this->__apiName = $__apiParam; }
	function SetType($__apiParam) { $this->__apiType = $__apiParam; }
	function SetWorkspace($__apiParam) { $this->__apiWorkspace = $__apiParam; }
	function SetFromLayer($__apiParam) { $this->__apiFromLayer = $__apiParam; }
	
	function WriteXML() {
		$__apiProperties = array();
		$__apiProperties['name'] = CheckProperty($this->__apiName);
		$__apiProperties['type'] = CheckProperty($this->__apiType);
		$__apiProperties['workspace'] = CheckProperty($this->__apiWorkspace);
		$__apiProperties['fromlayer'] = CheckProperty($this->__apiFromLayer);
			
		$__apiXML = '<DATASET ';
		
		reset($__apiProperties);
		while ($__apiArrayCell = each($__apiProperties)) {
			if (strlen($__apiArrayCell['value']) > 0) {
				$__apiXML .= $__apiArrayCell['key'] . '="' . $__apiArrayCell['value'] . '" ';
			}
		}
		$__apiXML .= '/>';
		
		return $__apiXML;
	}
}	
?>