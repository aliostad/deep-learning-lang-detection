<?php
class Background {
	//***************************************************************
	// Set property defaults
	//***************************************************************
	var $__apiColor = '255,255,255';
	var $__apiTransColor = '';
	 
	//***************************************************************
	// Constructor
	//***************************************************************
	function Background() {
		$numargs = func_num_args();
		$this->__apiColor = $numargs > 0 ? func_get_arg(0) : $__apiColor;
	}
	
	//***************************************************************
	// Public Methods
	//***************************************************************
	function SetColor($__apiParam) { $this->__apiColor = $__apiParam; }
	function SetTransColor($__apiParam) { $this->__apiTransColor = $__apiParam; }
	
	function WriteXML() {
		$__apiProperties = array();
		$__apiProperties['color'] = CheckProperty($this->__apiColor);
		$__apiProperties['transcolor'] = CheckProperty($this->__apiTransColor);
		
		$__apiXML = '<BACKGROUND ';
		
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
