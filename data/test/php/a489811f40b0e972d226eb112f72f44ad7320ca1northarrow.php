<?php
class NorthArrow {
	//***************************************************************
	// Set property defaults
	//***************************************************************
	var $__apiAngle = '';
	var $__apiAntiAliasing = '';
	var $__apiCoords = '';
	var $__apiOutline = '';
	var $__apiOverlap = '';
	var $__apiShadow = '';
	var $__apiSize = '';
	var $__apiTransparency = '';
	var $__apiType = '';
	var $__apiX = '';
	var $__apiY = '';
	
	//***************************************************************
	// Constructor
	//***************************************************************
	function NorthArrow() {
		$numargs = func_num_args();
		$this->__apiX = $numargs > 0 ? func_get_arg(0) : $__apiX;
		$this->__apiY = $numargs > 1 ? func_get_arg(1) : $__apiY;
		$this->__apiType = $numargs > 2 ? func_get_arg(2) : $__apiType;
		
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
	function SetAngle($__apiParam) { $this->__apiAngle = $__apiParam; }
	function SetAntiAliasing($__apiParam) { $this->__apiAntiAliasing = $__apiParam; }
	function SetOutline($__apiParam) { $this->__apiOutline = $__apiParam; }
	function SetOverlap($__apiParam) { $this->__apiOverlap = $__apiParam; }
	function SetShadow($__apiParam) { $this->__apiShadow = $__apiParam; }
	function SetSize($__apiParam) { $this->__apiSize = $__apiParam; }
	function SetTransparency($__apiParam) { $this->__apiTransparency = $__apiParam; }
	function SetType($__apiParam) { $this->__apiType = $__apiParam; }
	
	function WriteXML() {
		$__apiProperties = array();
		$__apiProperties['coords'] = CheckProperty($this->__apiCoords);
		$__apiProperties['angle'] = CheckProperty($this->__apiAngle);
		$__apiProperties['antialiasing'] = CheckProperty($this->__apiAntiAliasing);
		$__apiProperties['outline'] = CheckProperty($this->__apiOutline);
		$__apiProperties['overlap'] = CheckProperty($this->__apiOverlap);
		$__apiProperties['shadow'] = CheckProperty($this->__apiShadow);
		$__apiProperties['size'] = CheckProperty($this->__apiSize);
		$__apiProperties['transparency'] = CheckProperty($this->__apiTransparency);
		$__apiProperties['type'] = CheckProperty($this->__apiType);
		
		$__apiXML = '<NORTHARROW ';
		
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