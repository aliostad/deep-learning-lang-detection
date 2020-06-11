<?php
class ScaleDependentRenderer {
	//***************************************************************
	// Set property defaults
	//*************************************************************** 
	var $__apiLower = '';  
	var $__apiUpper = '';  
	var $__apiRenderer = '';  
	
	//***************************************************************
	// Constructor
	//***************************************************************
	function ScaleDependentRenderer() {
		$numargs = func_num_args();
		$this->__apiLower = $numargs > 0 ? func_get_arg(0) : $__apiLower;
		$this->__apiUpper = $numargs > 1 ? func_get_arg(1) : $__apiUpper;
	}

	//***************************************************************
	// Public Methods
	//***************************************************************
	function SetLower($__apiParam) { $this->__apiLower = $__apiParam; }
	function SetUpper($__apiParam) { $this->__apiUpper = $__apiParam; }
	function SetRenderer($__apiParam) { $this->__apiRenderer = $__apiParam; }
	
	function WriteXML() {
		$__apiProperties = array();
		$__apiProperties['lower'] = CheckProperty($this->__apiLower);
		$__apiProperties['upper'] = CheckProperty($this->__apiUpper);
		
		$__apiXML = '<SCALEDEPENDENTRENDERER ';
		
		reset($__apiProperties);
		while ($__apiArrayCell = each($__apiProperties)) {
			if (strlen($__apiArrayCell['value']) > 0) {
				$__apiXML .= $__apiArrayCell['key'] . '="' . $__apiArrayCell['value'] . '" ';
			}
		}
		$__apiXML .= '>';
		
		if ($this->__apiRenderer) {
			$__apiXML .= $this->__apiRenderer->WriteXML();
		} else {
			return 'ScaleDependentRenderer() does not contain a renderer object';
		}
		
		$__apiXML .= '</SCALEDEPENDENTRENDERER>';
		
		return $__apiXML;
	}
}	
?>