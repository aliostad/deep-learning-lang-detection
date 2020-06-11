<?php
class Scalebar {
	//***************************************************************
	// Set property defaults
	//***************************************************************
	var $__apiAntiAliasing = '';
	var $__apiBackColor = '';
	var $__apiBarColor = '';
	var $__apiBarTransparency = '';
	var $__apiBarWidth = '';
	var $__apiCoords = '';
	var $__apiDistance = '';
	var $__apiFont = '';
	var $__apiFontColor = '';
	var $__apiFontSize = '';
	var $__apiFontStyle = '';
	var $__apiMapUnits = '';
	var $__apiMode = '';
	var $__apiOutline = '';
	var $__apiOverlap = '';
	var $__apiPrecision = '';
	var $__apiRound = '';
	var $__apiScaleUnits = '';
	var $__apiScreenLength = '';
	var $__apiTextTransparency = '';
	var $__apiX = '';
	var $__apiY = '';
	
	//***************************************************************
	// Constructor
	//***************************************************************
	function Scalebar() {
		$numargs = func_num_args();
		$this->__apiX = $numargs > 0 ? func_get_arg(0) : $__apiX;
		$this->__apiY = $numargs > 1 ? func_get_arg(1) : $__apiY;
		
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
	function SetAntiAliasing($__apiParam) { $this->__apiAntiAliasing = $__apiParam; }
	function SetBackColor($__apiParam) { $this->__apiBackColor = $__apiParam; }
 	function SetBarColor($__apiParam) { $this->__apiBarColor = $__apiParam; } 
	function SetBarTransparency($__apiParam) { $this->__apiBarTransparency = $__apiParam; }
	function SetBarWidth($__apiParam) { $this->__apiBarWidth = $__apiParam; }
	function SetDistance($__apiParam) { $this->__apiDistance = $__apiParam; }
	function SetFont($__apiParam) { $this->__apiFont = $__apiParam; }
	function SetFontColor($__apiParam) { $this->__apiFontColor = $__apiParam; }
	function SetFontSize($__apiParam) { $this->__apiFontSize = $__apiParam; }
	function SetFontStyle($__apiParam) { $this->__apiFontStyle = $__apiParam; } 
	function SetMapUnits($__apiParam) { $this->__apiMapUnits = $__apiParam; }
	function SetMode($__apiParam) { $this->__apiMode = $__apiParam; }
	function SetOutline($__apiParam) { $this->__apiOutline = $__apiParam; }
	function SetOverlap($__apiParam) { $this->__apiOverlap = $__apiParam; }
	function SetPrecision($__apiParam) { $this->__apiPrecision = $__apiParam; }
	function SetRound($__apiParam) { $this->__apiRound = $__apiParam; }
	function SetScaleUnits($__apiParam) { $this->__apiScaleUnits = $__apiParam; }
	function SetScreenLength($__apiParam) { $this->__apiScreenLength = $__apiParam; }
	function SetTextTransparency($__apiParam) { $this->__apiTextTransparency = $__apiParam; }
	
	function WriteXML() {
		$__apiProperties = array();
		$__apiProperties['antialiasing'] = CheckProperty($this->__apiAntiAliasing);
		$__apiProperties['barcolor'] = CheckProperty($this->__apiBarColor); 
		$__apiProperties['bartransparency'] = CheckProperty($this->__apiBarTransparency);
		$__apiProperties['barwidth'] = CheckProperty($this->__apiBarWidth);
		$__apiProperties['coords'] = CheckProperty($this->__apiCoords);
		$__apiProperties['distance'] = CheckProperty($this->__apiDistance);
		$__apiProperties['font'] = CheckProperty($this->__apiFont);
		$__apiProperties['fontcolor'] = CheckProperty($this->__apiFontColor);
		$__apiProperties['fontsize'] = CheckProperty($this->__apiFontSize); 
		$__apiProperties['fontstyle'] = CheckProperty($this->__apiFontStyle); 
		$__apiProperties['mapunits'] = CheckProperty($this->__apiMapUnits);
		$__apiProperties['mode'] = CheckProperty($this->__apiMode);
		$__apiProperties['outline'] = CheckProperty($this->__apiOutline);
		$__apiProperties['overlap'] = CheckProperty($this->__apiOverlap);
		$__apiProperties['precision'] = CheckProperty($this->__apiPrecision);
		$__apiProperties['round'] = CheckProperty($this->__apiRound);
		$__apiProperties['scaleunits'] = CheckProperty($this->__apiScaleUnits);
		$__apiProperties['screenlength'] = CheckProperty($this->__apiScreenLength);
		$__apiProperties['texttransparency'] = CheckProperty($this->__apiTextTransparency); 
		
		$__apiXML = '<SCALEBAR ';
		
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
