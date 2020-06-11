<?php
class SimpleMarkerSymbol {
	//***************************************************************
	// Set property defaults
	//***************************************************************
	var $__apiAntiAliasing = '';
	var $__apiColor = '';
	var $__apiOutline = '';
	var $__apiOverlap = '';
	var $__apiShadow = '';
	var $__apiTransparency = '';
	var $__apiType = '';
	var $__apiUseCentroid = '';
	var $__apiWidth = '';
	
	//***************************************************************
	// Public Methods
	//***************************************************************
	function SetAntiAliasing($__apiParam) { $this->__apiAntiAliasing = $__apiParam; }
	function SetColor($__apiParam) { $this->__apiColor = $__apiParam; }
	function SetOutline($__apiParam) { $this->__apiOutline = $__apiParam; }
	function SetOverlap($__apiParam) { $this->__apiOverlap = $__apiParam; }
	function SetShadow($__apiParam) { $this->__apiShadow = $__apiParam; }
	function SetTransparency($__apiParam) { $this->__apiTransparency = $__apiParam; }
	function SetType($__apiParam) { $this->__apiType = $__apiParam; }
	function SetUseCentroid($__apiParam) { $this->__apiUseCentroid = $__apiParam; }
	function SetWidth($__apiParam) { $this->__apiWidth = $__apiParam; }
	
	function WriteXML() {
		$__apiProperties = array();
		$__apiProperties['antialiasing'] = CheckProperty($this->__apiAntiAliasing);
		$__apiProperties['color'] = CheckProperty($this->__apiColor);
		$__apiProperties['outline'] = CheckProperty($this->__apiOutline);
		$__apiProperties['overlap'] = CheckProperty($this->__apiOverlap);
		$__apiProperties['shadow'] = CheckProperty($this->__apiShadow);
		$__apiProperties['transparency'] = CheckProperty($this->__apiTransparency);
		$__apiProperties['type'] = CheckProperty($this->__apiType);
		$__apiProperties['usecentroid'] = CheckProperty($this->__apiUseCentroid);
		$__apiProperties['width'] = CheckProperty($this->__apiWidth);
			
		$__apiXML = '<SIMPLEMARKERSYMBOL ';
		
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
