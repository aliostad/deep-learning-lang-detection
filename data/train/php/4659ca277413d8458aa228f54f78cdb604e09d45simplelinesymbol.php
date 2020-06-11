<?php
class SimpleLineSymbol {
	//***************************************************************
	// Set property defaults
	//***************************************************************
	var $__apiAntiAliasing = '';
	var $__apiCapType = '';
	var $__apiColor = '';
	var $__apiJoinType = '';
	var $__apiOverlap = '';
	var $__apiTransparency = '';
	var $__apiType = '';
	var $__apiWidth= '';
	
	//***************************************************************
	// Public Methods
	//***************************************************************
	function SetAntiAliasing($__apiParam) { $this->__apiAntiAliasing = $__apiParam; }
	function SetCapType($__apiParam) { $this->__apiCapType = $__apiParam; }
	function SetColor($__apiParam) { $this->__apiColor = $__apiParam; }
	function SetJoinType($__apiParam) { $this->__apiJoinType = $__apiParam; }
	function SetOverlap($__apiParam) { $this->__apiOverlap = $__apiParam; }
	function SetTransparency($__apiParam) { $this->__apiTransparency = $__apiParam; }
	function SetType($__apiParam) { $this->__apiType = $__apiParam; }
	function SetWidth($__apiParam) { $this->__apiWidth = $__apiParam; }
	
	function WriteXML() {
		$__apiProperties = array();
		$__apiProperties['antialiasing'] = CheckProperty($this->__apiAntiAliasing);
		$__apiProperties['captype'] = CheckProperty($this->__apiCapType);
		$__apiProperties['color'] = CheckProperty($this->__apiColor);
		$__apiProperties['jointype'] = CheckProperty($this->__apiJoinType);
		$__apiProperties['overlap'] = CheckProperty($this->__apiOverlap);
		$__apiProperties['transparency'] = CheckProperty($this->__apiTransparency);
		$__apiProperties['type'] = CheckProperty($this->__apiType);
		$__apiProperties['width'] = CheckProperty($this->__apiWidth);
		
		$__apiXML = '<SIMPLELINESYMBOL ';
		
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
