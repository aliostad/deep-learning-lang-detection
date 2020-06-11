<?php
class Point {
	//***************************************************************
	// Set property defaults
	//***************************************************************
	var $__apiX = '';  
	var $__apiY = '';  
	var $__apiCoords = '';
	var $__apiMarkerSymbol = '';
	var $__apiParentElement = '';
	
	//***************************************************************
	// Constructor
	//***************************************************************
	function Point() {
		$numargs = func_num_args();
		$this->__apiX = $numargs > 0 ? func_get_arg(0) : $__apiX;
		$this->__apiY = $numargs > 1 ? func_get_arg(1) : $__apiY;
		$this->__apiMarkerSymbol = $numargs > 2 ? func_get_arg(2) : $__apiMarkerSymbol;
		$this->__apiParentElement = $numargs > 3 ? func_get_arg(3) : $__apiParentElement;
		
		if ($this->__apiX && $this->__apiY) {
			$this->__apiCoords = $this->__apiX . ' ' . $this->__apiY;
		}
	}

	//***************************************************************
	// Public Methods
	//***************************************************************
	function SetX($__apiParam) { $this->__apiX = $__apiParam; }
	function SetY($__apiParam) { $this->__apiY = $__apiParam; }
	function SetCoords($__apiParam) { 
		$this->__apiCoords = $__apiParam; 
		$__apiCoordsArray = split(" ", $__apiParam); 
		$this->SetX($__apiCoordsArray[0]);
		$this->SetY($__apiCoordsArray[1]);
	}
	function SetMarkerSymbol($__apiParam) { $this->__apiMarkerSymbol = $__apiParam; }
	function SetParentElement($__apiParam) { $this->__apiParentElement = $__apiParam; }
	
	function WriteXML() {
		$__apiProperties = array();
		if (strtoupper($this->__apiParentElement) == 'OBJECT') {
			$__apiProperties['coords'] = CheckProperty($this->__apiCoords);
		} else {
			$__apiProperties['x'] = CheckProperty($this->__apiX);
			$__apiProperties['y'] = CheckProperty($this->__apiY);
		}
		
		$__apiXML = '<POINT ';
		
		reset($__apiProperties);
		while ($__apiArrayCell = each($__apiProperties)) {
			if (strlen($__apiArrayCell['value']) > 0) {
				$__apiXML .= $__apiArrayCell['key'] . '="' . $__apiArrayCell['value'] . '" ';
			}
		}
		
		if (strtoupper($this->__apiParentElement) == 'OBJECT') {
			$__apiXML .= '>';
			if ($this->__apiMarkerSymbol) {
				$__apiXML .= $this->__apiMarkerSymbol->WriteXML();
				$__apiXML .= '</POINT>';
			} else {
				return 'Point() object contains no symbols';
			}
		} else {
			$__apiXML .= '/>';
		}
		
		return $__apiXML;
	}
}	
?>
