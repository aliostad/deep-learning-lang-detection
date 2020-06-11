<?php
class Text {
	//***************************************************************
	// Set property defaults
	//***************************************************************
	var $__apiX = '';  
	var $__apiY = '';  
	var $__apiCoords = '';
	var $__apiLabel = '';
	var $__apiTextMarkerSymbol = '';
	
	//***************************************************************
	// Constructor
	//***************************************************************
	function Text() {
		$numargs = func_num_args();
		$this->__apiX = $numargs > 0 ? func_get_arg(0) : $__apiX;
		$this->__apiY = $numargs > 1 ? func_get_arg(1) : $__apiY;
		$this->__apiLabel = $numargs > 2 ? func_get_arg(2) : $__apiLabel;
		$this->__apiTextMarkerSymbol = $numargs > 3 ? func_get_arg(3) : $__apiTextMarkerSymbol;
		
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
	function SetLabel($__apiParam) { $this->__apiLabel = $__apiParam; }
	function SetTextMarkerSymbol($__apiParam) { $this->__apiTextMarkerSymbol = $__apiParam; }
	
	function WriteXML() {
		$__apiProperties = array();
		$__apiProperties['coords'] = CheckProperty($this->__apiCoords);
		$__apiProperties['label'] = CheckProperty($this->__apiLabel);

		
		$__apiXML = '<TEXT ';
		
		reset($__apiProperties);
		while ($__apiArrayCell = each($__apiProperties)) {
			if (strlen($__apiArrayCell['value']) > 0) {
				$__apiXML .= $__apiArrayCell['key'] . '="' . $__apiArrayCell['value'] . '" ';
			}
		}
		
		$__apiXML .= '>';
			
		if ($this->__apiTextMarkerSymbol) {
			$__apiXML .= $this->__apiTextMarkerSymbol->WriteXML();
			
		} else {
			return 'Text() object contains no symbols';
		}
			
		$__apiXML .= '</TEXT>';
		
		return $__apiXML;
	}
}	
?>
