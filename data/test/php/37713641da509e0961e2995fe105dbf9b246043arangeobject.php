<?php
class RangeObject {
	//***************************************************************
	// Set property defaults
	//***************************************************************
	var $__apiLabel = '';  
	var $__apiLower = '';  
	var $__apiUpper = '';  
	var $__apiEquality = '';  
	var $__apiSymbol = '';
	
	//***************************************************************
	// Constructor
	//***************************************************************
	function RangeObject() {
		$numargs = func_num_args();
		$this->__apiLower = $numargs > 0 ? func_get_arg(0) : $__apiLower;
		$this->__apiUpper = $numargs > 1 ? func_get_arg(1) : $__apiUpper;
	}

	//***************************************************************
	// Public Methods
	//***************************************************************
	function SetLabel($__apiParam) { $this->__apiLabel = $__apiParam; }
	function SetLower($__apiParam) { $this->__apiLower = $__apiParam; }
	function SetUpper($__apiParam) { $this->__apiUpper = $__apiParam; }
	function SetEquality($__apiParam) { $this->__apiEquality = $__apiParam; }
	function SetSymbol($__apiParam) { $this->__apiSymbol = $__apiParam; }
	
	function WriteXML() {
		$__apiProperties = array();
		$__apiProperties['lower'] = CheckProperty($this->__apiLower);
		$__apiProperties['upper'] = CheckProperty($this->__apiUpper);
		$__apiProperties['label'] = CheckProperty($this->__apiLabel);
		$__apiProperties['equality'] = CheckProperty($this->__apiEquality);
		
		$__apiXML = '<RANGE ';
		
		reset($__apiProperties);
		while ($__apiArrayCell = each($__apiProperties)) {
			if (strlen($__apiArrayCell['value']) > 0) {
				$__apiXML .= $__apiArrayCell['key'] . '="' . $__apiArrayCell['value'] . '" ';
			}
		}
		$__apiXML .= '>';
		
		if ($this->__apiSymbol) {
			$__apiXML .= $this->__apiSymbol->WriteXML();
		} else {
			return 'Range() does not contain a symbol object';
		}
		
		$__apiXML .= '</RANGE>';
		
		return $__apiXML;
	}
}	
?>