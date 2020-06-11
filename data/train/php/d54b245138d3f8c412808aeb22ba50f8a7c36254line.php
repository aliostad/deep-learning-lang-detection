<?php
class Line {
	//***************************************************************
	// Set property defaults
	//***************************************************************
	var $__apiCoords = '';
	var $__apiSymbol = '';
	
	//***************************************************************
	// Constructor
	//***************************************************************
	function Line() {
		$numargs = func_num_args();
		$this->__apiCoords = $numargs > 0 ? func_get_arg(0) : $__apiCoords;
		$this->__apiSymbol = $numargs > 1 ? func_get_arg(1) : $__apiSymbol;
	}

	//***************************************************************
	// Public Methods
	//***************************************************************
	function SetCoords($__apiParam) { $this->__apiCoords = $__apiParam; }
	function SetSymbol($__apiParam) { $this->__apiSymbol = $__apiParam; }
	
	function WriteXML() {
		$__apiProperties = array();
		$__apiProperties['coords'] = CheckProperty($this->__apiCoords);
		
		$__apiXML = '<LINE ';
		
		reset($__apiProperties);
		while ($__apiArrayCell = each($__apiProperties)) {
			if (strlen($__apiArrayCell['value']) > 0) {
				$__apiXML .= $__apiArrayCell['key'] . '="' . $__apiArrayCell['value'] . '" ';
			}
		}
		
		if ($this->__apiSymbol) {
			$__apiXML .= '>';
			$__apiXML .= $this->__apiSymbol->WriteXML();
			$__apiXML .= '</LINE>';
		} else {
			$__apiXML .= '/>';
		}
		
		return $__apiXML;
	}
}	
?>
